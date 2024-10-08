#' Build age-class and sex structured table. The output table (using mmage naming convention tcla) is the first step for herd projection.
#'
#' @param female.ages A numeric vector specifying the bin widths of age classes in years for females where c(0.5, 1, 1) corresponds to 6 months, 1 year, 2 years of age. If terminal age is not Inf, a truncated model will be produced.
#' @param male.ages a vector of numbers containing the length of age classes in years for males where c(0.5, 1, 1) corresponds to 6 months, 1 year, 2 years of age. If terminal age is not Inf, a truncated model will be produced.
#' @param nbphase An integer by which age classes will be multiplied. Default is 1. Set to 12 to model population growth by month.
#' @return  data.frame created with fclass function (see mmage package)
#' @export
#' @import mmage
#' @examples
#' build_tcla(lclassf = c(1, 3, 10, Inf), lclassm = c(1, 3, 5, Inf), nbphase = 1)
#' @references Lesnoff, M. (*), 2015. mmage: A R package for age-structured population matrix models. CIRAD, Montpellier, France. http://livtools.cirad.fr.



build_tcla <- function(female.ages, male.ages = NULL, nbphase = 1) {
  lclassf <- female.ages
  if (is.null(male.ages)) {
    lclassm <- NULL
  } else {
    lclassm <- male.ages
  }
  # if (isTRUE(lclassf[length(lclassf)] == Inf)) {
  if (lclassf[length(lclassf)] == Inf) {
    truncated <- FALSE
  } else {
    truncated <- TRUE
  }

  if (truncated) {
    agef <- female.ages
    lclassf <- c(agef * nbphase, 1) # convert ages to months (if nbphase = 12) and add class value 1 to end for truncated model
    agem <- male.ages
    lclassm <- c(agem * nbphase, 1) # convert ages to months and add class value 1 to end for truncated model
  } else {
    lclassf <- lclassf * nbphase
    lclassm <- lclassm * nbphase
  }

  # lclassf[length(lclassf)-1]=lclassf[length(lclassf)-1]-1

  # lclassm[length(lclassm)-1]=lclassm[length(lclassm)-1]-1
  #-- create tcla dataframe
  # tcla = mmage::fclass(lclassf, lclassm)
  tcla <- mmage_fclass(lclassf, lclassm)
  return(tcla)
}
