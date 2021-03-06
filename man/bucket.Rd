\name{bucket}
\alias{bucket}
\alias{bucket.sim}
\title{ Single-bucket Soil Moisture Accounting models }
\description{
  Single-bucket Soil Moisture Accounting models with
  saturated/unsaturated zones and interception. 
}
\usage{
bucket.sim(DATA, Sb, fc = 1, a.ei = 0, M = 0, a.ss = 0,
           etmult = 1, S_0 = 0.5, return_state = FALSE)
}
\arguments{
  \item{DATA}{time-series-like object with columns P (precipitation,
    mm) and E (potential evapo-transpiration, mm).}
  \item{Sb}{Maximum soil water storage (mm).}
  \item{fc}{Field capacity (0 - 1).}
  \item{a.ei}{Interception coefficient (\eqn{\alpha_{ei}}).}
  \item{M}{Fraction of catchment area covered by deep rooted vegetation.}
  \item{a.ss}{Recession coefficients for subsurface flow from
    saturated zone (\eqn{\alpha_{ss}}).}
  \item{etmult}{Multiplier for the \code{E} input data.}
  \item{S_0}{Initial soil moisture level as a fraction of \code{Sb}.}
  \item{return_state}{to return the series U, S and ET (evapotranspiration).}
}
\details{
  From formulations given in Bai et. al. (2009), which were based on
  Farmer et. al. (2003). 
  
  The general mass balance structure is:
  \deqn{dS/dt = p - q(S) - e(S, Ep)}

  The default parameter ranges were also taken from Bai et. al. (2009).
}
\value{
  the simulated effective rainfall, a time series of the same length as
  the input series.  
}
\references{
  Farmer, D., M. Sivapalan, Farmer, D. (2003). Climate, soil and
  vegetation controls upon the variability of water balance in temperate
  and semiarid landscapes: downward approach to water balance
  analysis. \emph{Water Resources Research} 39(2), p 1035.
  
  Bai, Y., T. Wagener, P. Reed (2009). A top-down framework for
  watershed model evaluation and selection under
  uncertainty. \emph{Environmental Modelling and Software} 24(8),
  pp. 901-916.
}
\author{ Felix Andrews \email{felix@nfrac.org} }
\seealso{
  \code{\link{hydromad}(sma = "bucket")} to work with models as objects (recommended).
}
\examples{
## view default parameter ranges:
str(hydromad.options("bucket"))

data(HydroTestData)
mod0 <- hydromad(HydroTestData, sma = "bucket", routing = "expuh")
mod0

## simulate with some arbitrary parameter values
mod1 <- update(mod0, Sb = 10, fc = 0.5, M = 0.5, etmult = 0.05,
                     a.ei = 0.05, a.ss = 0.01, tau_s = 10)
## plot results with state variables
testQ <- predict(mod1, return_state = TRUE)
xyplot(cbind(HydroTestData[,1:2], bucket = testQ))

## show effect of increase/decrease in each parameter
parRanges <- hydromad.getOption("bucket")
parsims <- mapply(val = parRanges, nm = names(parRanges),
  FUN = function(val, nm) {
    lopar <- min(val)
    hipar <- max(val)
    names(lopar) <- names(hipar) <- nm
    fitted(runlist(decrease = update(mod1, newpars = lopar),
                   increase = update(mod1, newpars = hipar)))
  }, SIMPLIFY = FALSE)

xyplot.list(parsims, superpose = TRUE, layout = c(1,NA),
            strip = FALSE, strip.left = TRUE,
            main = "Simple parameter perturbation example") +
  layer(panel.lines(fitted(mod1), col = "grey", lwd = 2))
}
\keyword{models}
