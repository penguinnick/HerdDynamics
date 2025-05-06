#' Quickly plot survivorship curves
#' @param x a list of vectors with numbers corresponding the survival probabilities by age
#' @param ages a vector of numbers corresponding to the age of an animal. Length should be equal to length of each offtake model
#' @param title a string providing the title for the graph
#' @param key a string providing label to use in legend, e.g., "Strategy" or "Site"
#' @return  a line graph with offtake models colored by strategy.
#' @examples
#' plot_survivorship(
#'   x = list(
#'     Meat = c(0, 0.10, 0.25, 0.50, 0.75, 0.90),
#'     Milk = c(0, 0.10, 0.15, 0.20, 0.65, 0.95)
#'   ),
#'   ages = c(0.5, 1, 2, 3, 4, 5),
#'   title = "Meat vs Milk",
#'   key = "Strategy"
#' )
#' @export
#' @import ggplot2
#' @importFrom rcartocolor carto_pal
#' @importFrom tidyr gather
#' @importFrom stats aggregate
#'
# plot_survivorship = function(offtake, ages, title=title){
#   df = offtake_to_df(offtake, ages)
#   ggplot(data = df, aes( x = .data$age, y = .data$p.survival, group = .data$strategy)) +
#   geom_line( aes( colour = .data$strategy )) +
#   geom_point( aes( colour = .data$strategy )) +
#   labs(title = title, y = "Probability of Survival", x = "Age in years", colour = "Strategy")
# }
#-- a function to plot survivorship curves
plot_survivorship <- function(x, ages = NULL, title = "Survivorship Curves", key = "strategy") {
  cbPalette <- rcartocolor::carto_pal(length(x), "Safe")
  df <- data.frame(matrix(unlist(x), ncol = length(x), byrow = F)) # create dataframe from offtake.models
  if (is.null(ages)) {
    df$age <- c("", Payne_ages$ageClasses)
  } else {
    df$age <- ages
  }
  colnames(df) <- c(names(x), "age")
  df <- df %>% tidyr::gather(key = key, value = "p.survival", -age)
  df$p.survival <- df$p.survival / 100 # convert percentages to probability
  ggplot(data = df, aes(x = age, y = p.survival, group = key)) +
    geom_line(aes(colour = key), alpha = 0.8) +
    geom_point(aes(colour = key), alpha = 0.8) +
    scale_color_manual(values = cbPalette) +
    labs(
      title = title,
      y = "Probability of Survival",
      x = "Age Class",
      colour = key
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(hjust = 1))
}
