#' Script summarizes population change through time.
#' @param x list created with projectHerd function
#' @param interval a character string, either "month" to get results by time step or "year" to get results by cycle
#' @return data.frame with two columns (time, population)
#' @export
#'
#'
pop_summary = function(x, interval){
  vecx=x$vecx
  if(interval=="month"){
    out = aggregate(x~tim, data=vecx, FUN=sum)
  }
  if(interval=="year"){
    out = aggregate(x~cycle, data=vecx, FUN=sum)
  }
  colnames(out) = c("time", "pop")
  return(out)
}
