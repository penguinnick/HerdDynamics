#' Rewritten zcal script from mmage updating aggregate function, eliminating formula param from aggregate function
#' This function creates the calendar matrix
#' @param nbphase number of phases (1 for yearly, 12 for monthly). Inherited
#' @param nbstep product of nbphase and nbcycle
#' @export
#' @references Lesnoff, M. (*), 2015. mmage: A R package for age-structured population matrix models. CIRAD, Montpellier, France. http://livtools.cirad.fr.


mmage.zcal = function (nbphase, nbstep)
{
  tim <- 0:(nbstep - 1)
  z <- nbstep/nbphase
  if (!is.integer(z))
    z <- trunc(z) + 1
  z <- sort(rep(1:z, nbphase))
  cycle <- z[1:nbstep]
  z <- rep(1:nbphase, max(cycle))
  phase <- z[1:nbstep]
  cal <- data.frame(cycle = cycle, phase = phase, tim = tim,
                    timend = tim + 1)
  cal
  z <- cal
  z$tim <- ifelse(z$phase == 1, z$tim, 0)
  z$nbphase <- rep(1, nrow(z))
  tmp <- aggregate(cbind(tim, nbphase) ~ cycle, data = z,
                   FUN = sum)
  tmp
  list(cal = cal, cal.summ = tmp)
}
