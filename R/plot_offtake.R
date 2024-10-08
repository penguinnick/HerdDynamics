#' Quickly plot survivorship curves based on offtake rates
#' @param offtake a list of vectors with numbers corresponding the offtake probabilities by age
#' @param ages a vector of numbers corresponding to the age of an animal. Length should be equal to length of each offtake model
#' @param title a string providing the title for the graph
#' @return  a line graph with offtake models colored by strategy.
#' @examples
#'   x = list(
#'     Meat = c(0, 0.10, 0.25, 0.50, 0.75, 0.90 ),
#'     Milk = c(0, 0.10, 0.15, 0.20, 0.65, 0.95 )
#'     )
#'   a = c(0.5, 1, 2, 3, 4, 5)
#'   plot_offtake(offtake = x, ages = a , title="Meat vs Milk")
#' @export
#'
#'
plot_offtake <- function(offtake, ages, title = title) {
  df <- offtake_to_df(offtake, ages)
  ggplot(data = df, aes(x = .data$age, y = .data$p.survival, group = .data$strategy)) +
    geom_line(aes(colour = .data$strategy)) +
    geom_point(aes(colour = .data$strategy)) +
    labs(title = title, y = "Probability of Survival", x = "Age in years", colour = "Strategy")
}
