#' Annual Reproduction Rate (ARR)
#' @param offtake a list of vectors with numbers corresponding the offtake probabilities by age
#' @param ages a vector of numbers corresponding to the age of an animal. Length should be equal to length of each offtake model
#' @references
#' Wilson, R. T. (1989). Reproductive performance of African indigenous small ruminants under various management systems: a review. Animal Reproduction Science, 20(4), 265–286.
#' Upton, M. (1984). Models of improved production systems for small ruminants. In J. E. Sumberg & K. Cassaday (Eds.), Proceedings of the Workshop on Small Ruminant Production Systems in the Humid Zone of West Africa (pp. 55–67). International Livestock Centre for Africa. https://api.semanticscholar.org/CorpusID:131461953
#'
#'
#-- ARR calculation
ARR = function(mean_litter_size, parturition_interval){
  (mean_litter_size * 365) / parturition_interval
}
