#--  function to transform rates based on nbphase
#' @param x rates to transform

convert_to_phase = function(x){
  out = x / nbphase
  return(out)
}
