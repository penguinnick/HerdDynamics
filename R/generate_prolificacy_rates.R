#' Generate Prolificacy rates
#' This function generates prolificacy rates based on mean and standard deviation of provided list of prolificacy rates
#' @param meanPro mean prolificacy
#' @param sdPro standard deviation of prolificacy
#' @param n number of prolificacy rates to generate
#' @param sample_size number of samples to generate
#' @export
#' @return a vector of generated prolificacy rates
#'
#'
#' #-- function to autogenerate prolificacy rates, used when prolificacyRate set to "auto". These lines to be removed in package version.
generate_prolificacy_rates <- function( meanPro, sdPro,  n, sample_size = 100 ) {
  # Generate a sequence of numbers from 1 to n
  s = seq( 1 : n )
  # order the sequence so that the first half is in ascending order and the second half is in descending order
  p.order = c( s[ s %% 2 == 1 ], rev( s[ s %% 2 != 1 ] ))
  # Generate n values from a normal distribution
  values <- stats::rnorm(sample_size, meanPro, sdPro)
  # sample values
  value.sample = sample(values, n)
  # Sort the values
  sv <- sort( abs( values ) )
  sv <- sort( abs( value.sample ) )
  # Arrange values so that peak values are in the middle
  arranged_values = sv[ p.order ]

  return(abs( arranged_values) )
}
