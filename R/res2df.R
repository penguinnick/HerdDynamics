#' transform projection results into a dataframe for plotting with ggplot
#'
#' @param result.list a list of results produced using pop_summary function
#' @export
#' @return a dataframe containing time step, population size, and strategy
#'
res2df = function(result.list){
  df = do.call(rbind.data.frame, args=c(result.list, make.row.names=FALSE))
  strats = names(result.list)
  df$strategy = unlist(lapply(strats, FUN=rep, (nrow(df)/length(strats))))
  return(df)
}
