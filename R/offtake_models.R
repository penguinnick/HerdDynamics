#' Theoretical culling strategies
#'
#' A list of commonly cited culling strategies containing survivorship
#' probabilities corresponding to a standardized set of age classes (Marom and Bar-Oz 2009).
#' The list contains the following culling strategies:
#'
#' Energy, Security (Redding 1981), Meat, Milk, Wool (Payne 1973), Meat A,
#' Meat B, Milk A, Milk B, and Fleece (Vigne and Helmer 2007).
#'
#'
#'
#' @format ## `offtake_models`
#' A list of 10 vectors of 10 values representing percentage of animals of
#' different ages surviving.
#' \describe{
#'   \item{ageClasses}{string/character class containing Age classes A-I}
#'   \item{ages}{Age of animals in each age class in years}
#'   \item{lclass}{the length of each age class in months}
#'
#' }
#' @source
#' Payne, S. (1973). Kill-off Patterns in Sheep and Goats: The Mandibles from Aşvan Kale. Anatolian Studies, 23, 281–303. https://doi.org/10.2307/3642547
#'
#' Marom, N., & Bar-Oz, G. (2009). Culling profiles: the indeterminacy of archaeozoological data to survivorship curve modelling of sheep and goat herd maintenance strategies. Journal of Archaeological Science, 36(5), 1184–1187. https://doi.org/10.1016/j.jas.2009.01.007
#'
#' Redding, R. W. (1981). Decision making in subsistence herding of sheep and goats in the Middle East. University of Michigan.
#'
#' Vigne, J. D., & Helmer, D. (2007). Was milk a “secondary product” in the Old World? In J. D. Vigne, D. Helmer, & S. Peters (Eds.), The first steps of animal domestication: New archaeozoological approaches (pp. 1–12). Oxbow Books.
#'
"offtake_models"
