#' bundles param and repro parameter sets into a list for use in *project_herd* function
#' @param param a dataframe or list of dataframes created with *build_param* function
#' @param repro a list (or lists of) of vectors and dataframe created with *get_lambda* function
#' @return a list of parameters
#' @export


param_list = function(param, repro){
  if (is.data.frame(param)) {
    all.param = list(param)
    all.param = append(all.param, repro)
    # all.param[2:5] =  c(repro[[1]], repro[[2]], repro[[3]], repro[[4]])
    names(all.param) = c("param", names(repro[]))
    } else {
      all.param = vector("list", length = length(param))
      for(i in 1:length(param)){
        all.param[i]=list(c(param=param[i],repro[i][[1]]))
        names(all.param[[i]]) = c("param", names(repro[i][[1]]))
        names(all.param) = names(param)
      }
    }
  return(all.param)
}
