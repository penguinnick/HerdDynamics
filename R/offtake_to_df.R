#' Prepare list of offtake models for printing
#' @param offtake a list of vectors with numbers corresponding the offtake probabilities by age
#' @param ages a vector of numbers corresponding to the age of an animal. Length should be equal to length of each offtake model
#' @importFrom tidyr gather
#'
offtake_to_df = function(offtake, ages){
  df = data.frame(matrix(unlist(offtake), ncol=length(offtake), byrow = FALSE))
  df$age = ages
  colnames(df) = c(names(offtake), "age")
  df = df %>% tidyr::gather(key = "strategy", value = "p.slaughter", -age)
  df$p.survival = 1 - df$p.slaughter
  return(df)
}
