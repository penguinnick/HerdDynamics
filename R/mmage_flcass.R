#' A modification of mmage::flcass function used to build tcla table.
#' @param lclassf a vector giving the lengths of each age class for females
#' @param lclassm a vector giving the lengths of each age class for males
#' @param inf if TRUE

mmage_fclass = function ( lclassf, lclassm = NULL ) {
  sex <- "F"
  lclass <- lclassf
  if (!(lclass[length(lclass)] %in% c(1, Inf))) {
    stop("\n\nThe length of the terminal age class in lclassf should be either 1 or Inf.\n\n")
  }
  nbclass <- length(lclass)
  u <- data.frame(sex = rep(sex, nbclass + 1), class = 0:nbclass)
  # u$lclass <- c(1, lclass) # from original function
  u$lclass <- c(lclass[1], lclass)
  z <- u
  Lm <- length(lclassm)
  if (Lm > 0) { 
    sex <- "M"
    lclass <- lclassm
    if (!(lclass[length(lclass)] %in% c(1, Inf))) {
      stop("\n\nThe length of the terminal age class in lclassm should be either 1 or Inf.\n\n")
    }
    nbclass <- length(lclass)
    u <- data.frame(sex = rep(sex, nbclass + 1), class = 0:nbclass)
    u$lclass <- c(lclass[1], lclass)
    # u$lclass <- c(1, lclass)
    z <- rbind(z, u)
  }
  z$cellmax <- z$cellmin <- rep(0, nrow(z))
  for (i in 2:nrow(z)) {
      l = z$lclass[i]  
      if (l>0 && l<1){ # modified to include lclass lengths less than 1 year
        z$cellmin[i] = l
        z$cellmax[i] = l*2 # arbitrarily set max of class to 2*lclass for lclass<1
      } else {
        z$cellmin[i] <- z$cellmax[i - 1] + 1
        z$cellmax[i] <- z$cellmin[i] + z$lclass[i] - 1
      }
      if (z$class[i] == 0) {
        z$cellmax[i] <- z$cellmin[i] <- 0
      }
    }
  z
}
