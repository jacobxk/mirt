\name{randef}
\alias{randef}
\title{Compute random effects}
\usage{
randef(x, ndraws = 1000, thin = 10)
}
\arguments{
  \item{x}{an estimated model object from the
  \code{\link{mixedmirt}} function}

  \item{ndraws}{total number of draws to perform. Default
  is 1000}

  \item{thin}{amount of thinning to apply. Default is to
  use every 10th draw}
}
\description{
Stochastically compute random effects for \code{MixedClass}
objects with Metropolis-Hastings samplers and averaging
over the draws. Returns a list of the estimated effects.
}
\examples{
\dontrun{
effects <- randef(mod1, ndraws = 2000, thin = 20)

}
}
\author{
Phil Chalmers \email{rphilip.chalmers@gmail.com}
}
\keyword{effects}
\keyword{random}

