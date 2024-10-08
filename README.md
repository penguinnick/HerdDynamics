
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->
<!-- badges: end -->

# HerdDynamics

The goal of HerdDynamics is to provide a set of scripts to simulate the
growth of livestock herds under various management strategies.

## Installation

You can install the development version of HerdDynamics from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("penguinnick/HerdDynamics")
```

## Introduction - Livestock Population Dynamics and Stochastic Dynamic Programming

This document outlines the procedures for simulating goat and sheep herd
dynamics and using the resulting models in a stochastic dynamic program
that will identify the optimal culling strategy and herd reproduction
parameters. The code here supports Chapter 2 of Nick Triozzi’s PhD
Dissertation.

This is a basic example which shows you how to project herd growth under
a single offtake strategy:

``` r
library(HerdDynamics)
```

## Age Classes

The first step is to build a table containing information about the age
groups used in the projections. In this program age classes for males
and females may be specified separately. However, culling profiles
constructed from archaeological remains cannot distinguish male from
female mandibles. Therefore, offtake rates modeled here will be applied
to the entire herd while intrinsic mortality rates will be defined
separately for males and females.

``` r
# Age classes specifying the length of each age class, in years.
ages <- c(0.17, 0.5, 1, 2, 3, 4, 5, 6, 7, 8)
lclass <- c(0.17, 0.5, 1, 1, 1, 1, 1, 1, 1, 1)
tcla <- build_tcla( female.ages = lclass, 
  male.ages = lclass, 
  nbphase = 12 #The parameter nbphase is set to 12 which converts ages to months.
  ) 
head(tcla)
#>   sex class lclass cellmin cellmax
#> 1   F     0   2.04    0.00    0.00
#> 2   F     1   2.04    1.00    2.04
#> 3   F     2   6.00    3.04    8.04
#> 4   F     3  12.00    9.04   20.04
#> 5   F     4  12.00   21.04   32.04
#> 6   F     5  12.00   33.04   44.04
```

# Offtake

The offtake rates given here are generated from zooarchaeological
research which does not account for sex-based differences in culling
practices. These offtake rates usually describe culling strategies for a
whole herd, regardless of sex. Here we use them to model the offtake
rates of females.

``` r
#-- create a list of offtake strategies specifying probability of survival by age
offtake.models <- list(
  Meat     = c(100, 85, 75, 70, 50, 30, 22, 19, 19, 10), # Payne 1973
  Milk     = c(100, 47, 42, 39, 35, 28, 23, 18, 19, 10), # Payne 1973
  Wool     = c(100, 85, 75, 65, 63, 57, 50, 43, 43, 20)
) # Payne 1973

#-- convert survivorship to mortality
offtake.models <- lapply(offtake.models, function(x) {
  1 - (x / 100)
})

#-- plot offtake models
title <- "Culling Strategies for Sheep and Goats"
plot_offtake(offtake.models, ages, title)
```

<img src="man/figures/README-offtake-1.png" width="100%" />

## Herd Population Growth Parameters - Intrinsic Mortality

The probability that an animal will survive from one timestep to the
next is affected by the competing risks of being slaughtered (i.e.,
offtake) and intrinsic mortality. We set intrinsic mortality for males
and females separately.

``` r
#-- goat intrinsic mortality rates
doe.mortality =  c(0.179, 0.453, 0.18, 0.18, 0.18, 0.18, 0.18,  0.18,  0.18, 0.18)
buck.mortality = c(0.179, 0.453, 0.15, 0.15, 0.05, 0.05, 0.05,  0.05,  1.00, 1.00)
```

## Reproduction Parameters

Several parameters are important regarding the reproductive biology of
goats and sheep. *part.age* specifies the age of first parturition.
*parturition* specifies the number of parturitions per female per year.
*prolificacy* specifies the prolificacy rate, defined as the number of
live offspring per parturition per year. Age-specific rates are
available.

After setting these variables we create a parameter data frame that will
be used to compute lambda, reproductive values, and project herd growth

``` r
goat.parms = list(
  ages=ages,
  parturition = 1.2,
  part.age = 2,  # age of first parturition
  prolificacy = c( 0, 0, 0, 0.82, 1.10, 1.41, 1.45, 1.03, 1.03, 1.03),
  f.mortality = doe.mortality,
  m.mortality = buck.mortality,
  m.offtake = c(    0,   25,   25,     50, 75, 75,   75,   80, 90,  100)  / 100 # male offtake
)

param = lapply(offtake.models, function(o){build_param(tcla = tcla, parms=goat.parms, male.offtake = TRUE, offtake = o, phase="month")})
repro = lapply(param, function(p){ get_lambda(p, tcla, p0=1000) }) 
```

## Demographic Projection

Now we run the projection. We start with an initial herd size of 200
animals. First we define *nbcycle* as number of cycles to project
through (i.e., years). We keep the previously defined value *nbphase*
(nbphase=12=12 months). *nbstep* is the product of these values and will
calculate the change in herd demography from one phase to the next
(i.e., from 1 month to the next).

lapply is used to run the function *projest_herd* and stores the
projection *results* as a list.

``` r
#-- put all parameters into a list
all.param = param_list(param, repro)
#-- project hurts
results = lapply(all.param, function(a){project_herd(a, 20, 12)})
```

<img src="man/figures/README-plot-1.png" width="100%" /><img src="man/figures/README-plot-2.png" width="100%" />

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.
