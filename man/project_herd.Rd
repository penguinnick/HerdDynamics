% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/project_herd.R
\name{project_herd}
\alias{project_herd}
\title{Function for projecting herd growth. Modified version of fproj (mmage) that builds listpar in the function allowing for function to run on multiple strategies in a list using lapply}
\usage{
project_herd(all.param, nbcycle, nbphase, vec = TRUE)
}
\arguments{
\item{all.param}{A list containing param data.frame created with fvh2par function (see mmage package) and initial.herd calculated with getLambda function}

\item{nbcycle}{an integer specifying how many years to run projection on}

\item{nbphase}{an integer specifying how many phases to run projection on. Set to 12 for monthly, set to 1 for yearly.
Default is NULL, which assumes the same ages were used for males and females when building tcla.}

\item{p0}{integer the initial population size}
}
\value{
a list containing: lambda of herd, a dataframe with sex proportions of the herd, and a dataframe with initial herd traits, including reproductive value by sex/age class
}
\description{
Function for projecting herd growth. Modified version of fproj (mmage) that builds listpar in the function allowing for function to run on multiple strategies in a list using lapply
}
\references{
Lesnoff, M. (*), 2015. mmage: A R package for age-structured population matrix models. CIRAD, Montpellier, France. http://livtools.cirad.fr.
}
