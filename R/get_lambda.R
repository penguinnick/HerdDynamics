#' Function for computing reproduction traits
#' This function takes param as input and returns lambda, reproductive value, and herd sex proportions
#' @param param data.frame created with fvh2par function (see mmage package)
#' @param tcla dataframe of the original tcla table used to produce param (see mmage package)
#' Default is NULL, which assumes the same ages were used for males and females when building tcla.
#' @param p0 integer the initial population size
#' @return a list containing: lambda of herd, a dataframe with sex proportions of the herd, and a dataframe with initial herd traits, including reproductive value by sex/age class
#' @references Lesnoff, M. (*), 2015. mmage: A R package for age-structured population matrix models. CIRAD, Montpellier, France. http://livtools.cirad.fr.
#' @importFrom mmage feig
#' @importFrom dplyr group_by summarise %>%
#' @export

get_lambda = function(param, tcla, p0){
  # source("../R/mmagefmat.R")
  # if(is.null(lclassm)){
  #   Lf=Lm=length(lclass)+1
  # } else {
  #   Lf = length(lclass)+1
  #   Lm = length(lclassm)+1
  # }
  Lf = length(param$sex[param$sex == "F"]) - 1
  Lm = length(param$sex[param$sex == "M"]) - 1
  Lm = ifelse(Lm > 0, Lm , 0)
  mat = mmage.fmat(param, Lf, Lm) # compute demographic matrices
  lambda = feig(mat$A)$lambda %>% round(3)
  tabp0 = tcla[tcla$class>0,]
  # tabp0$x = feig(mat$A, left=TRUE)$v*p0
  tabp0$xini = feig(mat$A)$v*p0
  rep.val = feig(mat$A, left=TRUE)$u %>% round(3)
  tabp0$rep.val = feig(mat$A, left=TRUE)$u %>% round(3)
  p.sex = tabp0 %>% dplyr::group_by(sex) %>% dplyr::summarise(p.sex = sum(xini)/p0)
  # p.sex = aggregate(xini~sex,data=tabp0, FUN=sum)
  return(list(lambda=lambda, sex.proportion=p.sex, initial.herd=tabp0, p0=p0))
}
