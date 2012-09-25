\name{fscores}
\alias{fscores}
\title{Methods for Function fscores}
\usage{
  fscores(object, rotate = "", full.scores = FALSE,
    method = "EAP", quadpts = NULL, verbose = TRUE)
}
\arguments{
  \item{object}{a computed model object of class
  \code{ExploratoryClass}, \code{ConfirmatoryClass}, or
  \code{MultipleGroupClass}}

  \item{full.scores}{if \code{FALSE} (default) then a
  summary table with factor scores for each unique pattern
  is displayed. Otherwise the original data matrix is
  returned with the computed factor scores appended to the
  rightmost column}

  \item{rotate}{rotation declaration to be used when
  estimating the factor scores. If \code{""} then the
  \code{object@rotate} default value is used (only
  applicable to \code{ExploratoryClass} objects)}

  \item{method}{type of factor score estimation method. Can
  be expected a-posteriori (\code{"EAP"}), Bayes modal
  (\code{"MAP"}), or maximum likelihood (\code{"ML"})}

  \item{quadpts}{number of quadratures to use per
  dimension}

  \item{verbose}{logical; print verbose output messages?}
}
\description{
  Computes MAP, EAP, or ML factor scores with a
  multivariate normal prior distribution.
}
\examples{
\dontrun{

mod <- mirt(Science, 1)
tabscores <- fscores(mod)
fullscores <- fscores(mod, full.scores = TRUE)
fullscores <- fscores(mod, full.scores = TRUE, method='MAP')


  }
}
\author{
  Phil Chalmers \email{rphilip.chalmers@gmail.com}
}
\keyword{factor.scores}
