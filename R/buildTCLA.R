#' Script replacement for fmat function in mmage package.
#' This function solves an error thrown when fmat(param) is run by specifying Lf and Lm as performed in fvh2par
#' @param female.ages a list containing age classes of females
#' @param male.ages a list containing age classes of males
#' @param nbphase an integer by which age classes will be multiplied. Set nbphase to 1 to model population growth by year, set to 12 to model monthly growth
#' @return  data.frame created with fclass function (see mmage package)
#' @references Lesnoff, M. (*), 2015. mmage: A R package for age-structured population matrix models. CIRAD, Montpellier, France. http://livtools.cirad.fr.



build.tcla = function(female.ages, male.ages, nbphase){
  ages=female.ages
  lclassf = c(ages*nbphase, 1) # convert ages to months (if nbphase = 12) and add class value 1 to end for truncated model
  lclassf[length(lclassf)-1]=lclassf[length(lclassf)-1]-1
  ages=male.ages
  lclassm = c(ages*nbphase, 1)  # convert ages to months and add class value 1 to end for truncated model
  lclassm[length(lclassm)-1]=lclassm[length(lclassm)-1]-1
  #-- create tcla dataframe
  tcla = fclass(lclassf, lclassm)
  return(tcla)
}