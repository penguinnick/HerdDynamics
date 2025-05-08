#' Quick multi-plot of survivorship curves based on offtake rates
#' @param survivorship_profiles a named list of vectors with numbers corresponding the offtake probabilities by age. Default is offtake_models list included with HerdDynamics
#' @param Payne if TRUE (default) uses Payne's 1973 age class categories. Note: provided survivorship profiles must contain the same number (9) of survivorship probabilities as Payne's age classes. If FALSE, the user must provide their own age categories in the agecats argument.
#' @param agecats a vector of age categories to use for plotting. Length must match length of individual survivorship probabilities
#' @return  a line graph with offtake models colored by strategy.
#' @examples
#'   x = list(
#'     Meat = c(0, 0.10, 0.25, 0.50, 0.75, 0.90 ),
#'     Milk = c(0, 0.10, 0.15, 0.20, 0.65, 0.95 )
#'     )
#'   a = c(0.5, 1, 2, 3, 4, 5)
#'   plot_offtake(offtake = x, ages = a , title="Meat vs Milk")
#' @export
#' @import ggplot2
#' @importFrom tidyr gather
#' @references Payne, S. (1973). Kill-off Patterns in Sheep and Goats: The Mandibles from Aşvan Kale. Anatolian Studies, 23, 281–303. https://doi.org/10.2307/3642547
#'
culling_multiplot = function(survivorship_profiles = offtake_models, Payne = TRUE, agecats = NULL){

  if (Payne){
    df = cbind.data.frame(
      ages = c("", Payne_ages$ageClasses),
      do.call( cbind.data.frame, args = c( survivorship_profiles) )
    )
  } else {
    df = cbind.data.frame(
      ages = agecats,
      do.call( cbind.data.frame, args = c( survivorship_profiles) )
    )
  }
  df %>%
    tidyr::gather(key = "Strategy", value = "p", -ages) %>%
    ggplot(aes(x = ages, y = p, group = Strategy)) +
    geom_line( colour = rcartocolor::carto_pal(10,"Safe")[1], lwd = 1) +
    ylab("Survivorship (%)") +
    xlab("Age Class") +
    facet_wrap(~Strategy) +
    theme_classic() +
    theme(
      axis.text.x = element_text(angle = 90, hjust = 1, size = 8),
      axis.text.y = element_text(size = 10),
      legend.text = element_text(size = 10),
      legend.title = element_text(size = 12),
      axis.title = element_text(size = 12)
    )
}
