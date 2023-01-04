#' Script summarizes population change through time.
#' @param x list created with projectHerd function
#' @param ... field names passed on to group_by arg in dplyr. This will be any combination of tim, cycle, sex, class, etc.
#' @return data.frame with two columns (time, population)
#' @importFrom dplyr group_by %>% summarise
#' @export


pop_summary = function( x, ... , interval=NULL) {
  x = x$vecx
  x %>% group_by( ... ) %>% summarise( n = sum( x ))
}
