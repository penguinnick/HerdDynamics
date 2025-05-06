#' Generate Infant mortality rates
#' This function generates infant mortality rates rates based on mean and standard deviation of provided list of mortality rates.
#' @param Mort vector of mortality rates
#' @param n number of mortality rates corresponding to the number of infant age classes (ages below 1). Default is 3.
#' @export
#' @return a vector of generated prolificacy rates
#'

#' @describeIn vary_fert_mort Generate infant mortality rates
#' @export


generate_infant_mortality_rates <- function( Mort, n = 3) {
  inf.mort = Mort[1:n]
  sort(generate_prolificacy_rates(meanPro = mean(inf.mort), sdPro = sd(inf.mort), n = n), decreasing = TRUE )
}
