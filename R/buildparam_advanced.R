#' Script replacement for fmat function in mmage package.
#' This function solves an error thrown when fmat(param) is run by specifying Lf and Lm as performed in fvh2par
#' @param tcla data.frame created with fclass function (see mmage package)
#' @param parms a list containing:
#' - pfbirth (vector of probabilities of each age class giving birth to a female),
#' - part.age (age of first parturition; index corresponding to class in tcla$class ),
#' - prolificacy (average number of offspring per birth per age, corresponding to age classes)
#' - f.mortality (a vector of length=number of age classes specifying mortality rates for each class of females)
#' - m.mortality (a vector of length=number of age classes specifying mortality rates for each class of males)
#' - f.offtake (a vector of length=number of age classes specifying culling rates for each class of females)
#' @param nbphase an integer, set as 1 for yearly projections, 12 for monthly.
#' @param offtake vector of age-structured offtake probabilities. Length should be same as number of age classes (if male and females are equal), plus 1. A probability of 0 should lead the vector. Typical offtake for a model with ages 1, 2, 3, 4 would be c(0, 0.10, 0.15, 0.3, 0.3). In the function, the first value is omitted.
#' @param female.offtake Integer. Specifies the factor by which offtake rates should be reduced for female animals. If left as the default, NULL, the same offtake rates are applied to both males and females. Can be a vector of probabilities with length equal to length(lclass).
#' @param fbirthRate default is 0.5 (probability of a female birth)
#' @param terminal Set to "off" if probability of offtake competes with probability of intrinsic mortality, otherwise set to "dea". This is only used for truncated models where terminal age class is set to 1.
#' @param phi for use in optimizing routines. Female offtake probabilities will be multiplied by phi if a value is specified. Default is 1.
#' @param offtake a vector of length=length of age classes giving the harvest profile (probability of individual being killed under a particular strategy)
#' @param lambda set to 1 default
#' @param correctionfec default is TRUE
#' @param Inf.Mortality if set to "auto", variation in mortality for the first three age classes is introduced using normal distribution of mean and sd obtained from input *parms$f.mortality*
#' @param prolificacyRate if set to "auto", variation in prolificacy for the reproductive age classes is introduced using normal distribution of mean and sd obtained from input *parms$MeanProlificacy* and *parms$sdProlificacy*
#' @param method set to "steady"
#' @param hazards set to TRUE if output should include a table of hazards rather than probabilities (i.e., variable hh in code)
#' @return a data.frame to use for projecting herd demography
#' @export
#' @import mmage
#' @references Lesnoff, M. (*), 2015. mmage: A R package for age-structured population matrix models. CIRAD, Montpellier, France. http://livtools.cirad.fr.
#' @examples
#'   lclass <- c(0.17, 0.5, 1, 1, 1, Inf)
#'   nbphase = 12
#'   tcla <- build_tcla( female.ages = lclass, male.ages = lclass, nbphase = nbphase)
#'   parms = list(
#'     ages = c( 0.17, 0.5, 1, 2, 3, 4),
#'     parturition = 1.2,
#'     part.age = 2,
#'     prolificacy = c( 0, 0.82, 1.10, 1.41, 1.45, 1.03),
#'     f.mortality = c(0, 0.10, 0.10, 0.20, 0.50, 0.75),
#'     m.mortality = c(0, 0.10, 0.10, 0.20, 0.50, 0.75)
#'     )
#'   build_param(tcla, parms=parms, nbphase = nbphase, offtake = c(0, 0, 0.10, 0.25, 0.50, 0.75, 0.90 ), prolificacyRate = "auto", Inf.Mortality = "auto")



build_param = function(
    tcla,
    parms,
    nbphase,
    offtake,
    female.offtake=NULL,
    phi = NULL,
    Inf.Mortality=c(NULL, "auto"),
    prolificacyRate=c(NULL, "auto"),
    fbirthRate=0.5,
    lambda = 1,
    correctionfec = TRUE,
    method = "steady",
    terminal = c("off", "dea"),
    hazards = FALSE
    ){
  #-- check if model uses truncated ages
  truncated = any(tcla$lclass > 9999)
  #-- if net female offtake rate is specified, calculate as percentage of offtake rates
  if ( !is.null(female.offtake) ) {
    # f.off =  distribute_offtake( net_offtake_rate = as.numeric(female.offtake)/100, offtake[-1])  # for distribute offtake function, future build
    f.off = offtake[-1] * (as.numeric(female.offtake)/100)
  } else {
    f.off = offtake[-1]
  }
  f.off = f.off

  with( parms, {

    #-- hazard rates data.frame
    z = tcla[tcla$class > 0, ]  # subset tcla where class > 0

    len.class = nrow(z) #length(z$lclass)
    len.fclass = length(z$lclass[z$sex=="F"])  # set length of female age classes

    part = parturition
    # fbirthRate = 0.5
    fbirthRate = fbirthRate

    hpar = vector(length = len.class) # create vector to store fecundity values for male and females
    hpar[] = 0
    netpro = pfbirth = hpar  # create hpar, netpro, pfbirth vectors from fecm
    part.age.Ind = which(part.age==ages)[[1]]
    hpar[part.age.Ind:len.fclass] = part  # create vector of partutition rates
    pfbirth[part.age.Ind:len.fclass] = fbirthRate # create vector of female birth probabilities

    MeanProlificacy = mean( prolificacy[ prolificacy > 0 ] )
    sdProlificacy = sd( prolificacy[ prolificacy > 0 ] )

    #-- function to autogenerate prolificacy rates, used when prolificacyRate set to "auto". These lines to be removed in package version.
    generate_ProlificacyRates <- function( meanPro = MeanProlificacy, sdPro = sdProlificacy,  n = length( part.age.Ind : len.fclass )) {

      s = seq( 1 : n )
      p.order = c( s[ s %% 2 == 1 ], rev( s[ s %% 2 != 1 ] ))
      # Generate n values from a normal distribution
      values <- rnorm(100, meanPro, sdPro)
      # sample values
      value.sample = sample(values, n)
      # Sort the values
      sv <- sort( abs( values ) )
      sv <- sort( abs( value.sample ) )
      # Arrange values so that peak values are in the middle
      arranged_values = sv[ p.order ]

      return(abs( arranged_values) )
    }

    #-- used when Inf.Mortality set to "auto". To be removed in package version!
    generate_InfantMortalityRates <- function( Mort = f.mortality, n = 3) {
      inf.mort = Mort[1:3]
      sort(generate_ProlificacyRates(meanPro = mean(inf.mort), sdPro = sd(inf.mort), n = 3), decreasing = TRUE )
    }

    if (is.null( prolificacyRate )) {
      Prolificacy.Rate = prolificacy[prolificacy > 0]
    } else {
      if ( prolificacyRate=="auto" ) {
        Prolificacy.Rate = generate_ProlificacyRates()
      }
    }

    netpro[ part.age.Ind:len.fclass ] = Prolificacy.Rate

    if ( is.null( Inf.Mortality )) {
      f.mortality = f.mortality
      m.mortality = m.mortality
    } else {
      if (Inf.Mortality == "auto" ) {
        f.mortality[1:3] = generate_InfantMortalityRates()
        m.mortality[1:3] = generate_InfantMortalityRates()
      }
    }

    Mortality = mean(c(f.mortality, m.mortality)) # calculate overall mortality rate (for output)
    NetProlificacy = mean( Prolificacy.Rate ) # calculate net prolificacy rate from auto-generated rates (for output)

    # assign vectors to columns in dataframe
    z$hpar  = hpar
    z$hfecf = pfbirth * netpro * hpar
    z$hfecm = (1-pfbirth) * netpro * hpar

    #-- checks if truncated model, checks if female offtake is specified.
    # if( truncated ){
    #   z$hoff = c( f.off, 1, offtake[-1], 1 )
    #   z$hdea = c(f.mortality, 1, m.mortality, 1)
    # } else {
    #   z$hoff = c( f.off, offtake[-1] )
    #   z$hdea = c(f.mortality, m.mortality)
    # }

    z$hoff = c( f.off, offtake[-1] )
    z$hdea = c(f.mortality, m.mortality)

    #--  function to transform rates based on nbphase
    convert.to.phase = function(x){
      out = x / nbphase
      return(out)
    }

    z[,6:10] = sapply(z[,6:10], convert.to.phase)

    hh = z
    vh = fhh2vh(hh)

    param = fvh2par(vh, lambda = lambda, correctionfec = correctionfec, terminal = terminal, method = method)

    # used when hazards are needed, otherwise probabilities returned in output param table
    if(isTRUE(hazards)){
      return(hh)
    } else {
      return(list(param = param, parms = parms, NetProlificacy = NetProlificacy, Mortality = Mortality, offtake = offtake, female.offtake = female.offtake, correctionfec = correctionfec, phi = phi))
    }
  })
}
