% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/correct_counts.R
\name{correct.counts}
\alias{correct.counts}
\title{Correct Counts function used for building mortality profiles.
Function takes as input a string of letters A:I corresponding to Payne's Age classes.
Creates a data.frame tallying age classes.
Function corrects counts of age class occurrences by adding fractions to total count based on number of different age classes suggested for an individual.}
\usage{
correct.counts(a, probability.correction = FALSE)
}
\arguments{
\item{a}{column containing Payne's Age Groups}

\item{probability.correction}{logical. Whether to correct counts using Vigne and Helmer's (2007) probability correction rule. Default FALSE. If TRUE, combines age groups EF, and HI}
}
\value{
A two-column dataframe of age class (V) and corrected count (n)
}
\description{
Function works as follows... to correct counts of age groups we need to:
\enumerate{
\item create a vector of valid groups, v (i.e., A-I)
\item create a table, t to store the number of occurrences, n of each group in v that exist in the input table
\item for each item, i that has 0 groups listed, skip.
\item for each item i, that has only one group listed, add 1 to n in table t for group v\link{i}
\item for multiple groups listed, create a vector, g to store the groups listed.
\item calculate the fraction, f that must be added to each group (i.e., 1/length(g))
\item add f to the sum of occurrences for each group in g
\item update t with the new count
}
}
