#' Function for computing reproduction traits
#' This function takes param as input and returns lambda, reproductive value, and herd sex proportions
#' @param param data.frame created with fvh2par function (see mmage package)
#' @param tcla dataframe of the original tcla table used to produce param (see mmage package)
#' @param lclass a vector of age classes (same as used to build tcla in earlier step)
#' @param lclassm a vector of age classes for males used to build tcla, if applicable. 
#' Default is NULL, which assumes the same ages were used for males and females when building tcla.
#' @param p0 integer the initial population size
#' @return a list containing: lambda of herd, a dataframe with sex proportions of the herd, and a dataframe with initial herd traits, including reproductive value by sex/age class
#' @references Lesnoff, M. (*), 2015. mmage: A R package for age-structured population matrix models. CIRAD, Montpellier, France. http://livtools.cirad.fr.

getLambda = function(param, tcla, lclass, lclassm=NULL, p0){
  source("../R/mmagefmat.R")
  if(is.null(lclassm)){
    Lf=Lm=length(lclass)+1
  } else {
    Lf = length(lclass)+1
    Lm = length(lclassm)+1
  }
  mat = mmage.fmat(param, Lf, Lm) # compute demographic matrices
  lambda = feig(mat$A)$lambda %>% round(3)
  tabp0 = tcla[tcla$class>0,]
  tabp0$x = feig(mat$A, left=TRUE)$v*p0
  rep.val = feig(mat$A, left=TRUE)$u %>% round(3)
  tabp0$rep.val = feig(mat$A, left=TRUE)$u %>% round(3)
  p.sex = aggregate(x~sex,data=tabp0, FUN=sum)
  return(list(lambda=lambda, sex.proportion=p.sex, initial.herd=tabp0, p0=p0))
}
