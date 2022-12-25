#' Script replacement for fmat function in mmage package.
#'
#' This function solves an error thrown when fmat(param) is run by specifying Lf and Lm as performed in fvh2par
#'
#' @param tcla data.frame created with fclass function (see mmage package)
#' @param parms a list containing:
#' pfbirth (vector of probabilities of each age class giving birth to a female),
#' part.age (age of first parturition; index corresponding to class in tcla$class ),
#' prolificacy (average number of offspring per birth per age, corresponding to age classes)
#' f.mortality (a vector of length=number of age classes specifying mortality rates for each class of females)
#' m.mortality (a vector of length=number of age classes specifying mortality rates for each class of males)
#' f.offtake (a vector of length =number of age classes specifying culling rates for each class of females)
#' @param phase a string either "year" or "month". To model annual growth, nbphase must be set to 1 when creating tcla and nbphase set to "year"
#' To model monthly changes in growth set nbphase to "month" and 12 when creating tcla table.
#' @param parturition parturition rate - a number representing frequency of births per year
#' @param offtake a vector of length=length of age classes giving the harvest profile (probability of individual being killed under a particular strategy)
#' @param lambda set to 1 default
#' @param correctionfec default is TRUE
#' @param method set to "steady"
#' @param hazards set to TRUE if output should include a table of hazards rather than probabilities (i.e., variable hh in code)
#' @export
#' @return a data.frame to use for projecting herd demography
#' @examples
#'
#' # Build tcla table
#' lclass = c(0.17, 0.5, 1, 2, 3, 4, 5, 6, 7)
#' tcla = build.tcla(female.ages = lclass, male.ages = lclass, nbphase = 12)
#'
#' # build parms list
#' parms = list(
#'   parturition = 1.2,
#'   part.age = 2,  # age of first parturition
#' # number of livebirths expected per animal per parturition per year by age class
#'   prolificacy = c( 0, 0, 0, 0.82, 1.10, 1.41, 1.45, 1.03, 1.03),
#'   f.mortality = c( 0.05, 0.45, 0.18, 0.18, 0.18, 0.18, 0.18,  0.18,  0.18),
#' # m.mortality = buck.mortality
#' # f.offtake = doe.mortality/2
#' )
#'
#' # run function
#' build.param = function(tcla, parms, phase="month", offtake=c(0.45,  0.45, 0.15, 0.15, 0.05, 0.05, 0.05,  0.05,  1.00))
#'
#' @references Lesnoff, M. (*), 2015. mmage: A R package for age-structured population matrix models. CIRAD, Montpellier, France. http://livtools.cirad.fr.
#'





build.param = function(tcla, parms, phase, offtake, female.offtake=NULL, prolificacyRate=NULL, fbirthRate=0.5, lambda = 1, correctionfec = TRUE, truncated=TRUE, method = "steady", hazards = FALSE){
  # if (!require('mmage')) {
  #   PackageURL="ftp://ftp.cirad.fr/pub/livtools/Materials/HerdPerf/Models/mmage/mmage_2.4-2.tar.gz"
  #   install.packages(PackageURL, repos=NULL, type="source")
  #   library(mmage)
  # }
  with(parms, {
    part=parturition
    z = tcla[tcla$class > 0, ]  # subset tcla sans lclass of 0
    len.class = nrow(z) #length(z$lclass)
    len.fclass = length(z$lclass[z$sex=="F"])  # set length of female age classes
    fecm = vector(length = len.class) # create vector to store fecundity values for male and females
    fecm[] = 0
    hpar = netpro = pfbirth = fecm  # create hpar, netpro, pfbirth vectors from fecm
    hpar[part.age:len.fclass] = part  # create vector of partutition rates
    pfbirth[part.age:len.fclass] = fbirthRate # create vector of female birth probabilities
    netpro[part.age:len.fclass]=prolificacy

    # assign vectors to columns in dataframe
    z$hpar  = hpar
    z$hfecf = pfbirth * netpro * hpar
    z$hfecm = (1-pfbirth) * netpro * hpar

    #-- checks if truncated model, checks if female offtake is specified.
    if(truncated){
      z$hdea = c(f.mortality, 1, m.mortality,1)
      if(is.null(female.offtake)){
        z$hoff = c(offtake, 1, offtake,1)
      }
      else{
        z$hoff = c(female.offtake, 1, offtake, 1)
      }
    } else {
      z$hdea = c(f.mortality, m.mortality)
      if(is.null(female.offtake)){
        z$hoff = c(offtake, offtake)
      }
      else{
        z$hoff = c(female.offtake, offtake)
      }
    }

    #--  function to transform annual rates to monthly rates, or rates defined by nbphase
    convert.to.phase = function(x){
      out=x/12
      return(out)
    }

    #-- checks if sub-annual rates are specified by nbphase and transforms columns
    if(phase=="month"){
      z[,6:10] = sapply(z[,6:10], convert.to.phase)
    }

    hh = z
    vh = mmage::fhh2vh(hh)
    # param = fvh2par(vh, lambda=lambda, correctionfec = correctionfec, method="geom")
    param = mmage::fvh2par(vh, lambda=lambda, correctionfec = correctionfec, terminal = "off", method=method)
    if(isTRUE(hazards)){
      return(hh)
    } else {
      return(param)
    }
  })
}
