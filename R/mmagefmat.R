#' Script replacement for fmat function in mmage package.
#' This function solves an error thrown when fmat(param) is run by specifying Lf and Lm as performed in fvh2par
#' Build matrices F, D, O, I, G and A from the input parameters.
#' @param param dataframe built from birth, survival, and death rates
#' @return list of arrays FEC, DEA, OFF, ID, G, A, and PAR
#' @references Lesnoff, M. (*), 2015. mmage: A R package for age-structured population matrix models. CIRAD, Montpellier, France. http://livtools.cirad.fr.
#' @importFrom mmage fmatfec fmatg
#' @export

mmage.fmat=function (param, Lf, Lm)
{
  z <- param
  # Lf <- length(z$sex[z$sex == "F"]) - 1
  # u <- length(z$sex[z$sex == "M"])
  # if (u > 0)
  #   Lm <- u - 1
  # else Lm <- 0
  FEC <- mmage::fmatfec(z, Lf, Lm)
  DEA <- diag(z$pdea)
  OFF <- diag(z$poff)
  ID <- diag( 1, nrow(z))
  G <- mmage::fmatg( z, Lf, Lm)
  A <- G %*% (ID - DEA - OFF) %*% FEC
  z$ff <- z$nupar
  z$fm <- rep(0, Lf + Lm + 2)
  PAR <- mmage::fmatfec(z, Lf, Lm)
  list(FEC = FEC, DEA = DEA, OFF = OFF, ID = ID, G = G, A = A,
       PAR = PAR)
}
