\docType{class}
\name{ExploratoryClass-class}
\alias{ExploratoryClass-class}
\title{Class "ExploratoryClass"}
\description{
Defines the object returned from \code{\link{mirt}} when
model is exploratory.
}
\section{Slots}{
  \describe{ \item{\code{iter}:}{Object of class
  \code{"numeric"}, number of iterations }
  \item{\code{pars}:}{Object of class \code{"list"},
  estimated parameter objects list }
  \item{\code{model}:}{Object of class \code{"list"}, list
  containing original model } \item{\code{K}:}{Object of
  class \code{"numeric", number of item categories} }
  \item{\code{itemloc}:}{Object of class \code{"numeric",
  index for tabdata} } \item{\code{AIC}:}{Object of class
  \code{"numeric"}, Akaike's information criteria }
  \item{\code{BIC}:}{Object of class \code{"numeric"},
  Bayesian information criteria } \item{\code{G2}:}{Object
  of class \code{"numeric"}, G squared stat }
  \item{\code{p}:}{Object of class \code{"numeric"},
  p-value for G2 } \item{\code{df}:}{Object of class
  \code{"numeric"}, degrees of freedom }
  \item{\code{RMSEA}:}{Object of class \code{"numeric"},
  root mean-square error of approximation for G2}
  \item{\code{TLI}:}{Object of class \code{"numeric"},
  Tucker-Lewis index for G2} \item{\code{CFI}:}{Object of
  class \code{"numeric"}, CFI for G2}
  \item{\code{logLik}:}{Object of class \code{"numeric"},
  observed log-likelihood } \item{\code{SElogLik}:}{Object
  of class \code{"numeric"}, Monte Carlo standard error for
  log-likelihood } \item{\code{F}:}{Object of class
  \code{"matrix"}, unrotated factor loadings }
  \item{\code{h2}:}{Object of class \code{"numeric"},
  commonalities } \item{\code{tabdata}:}{Object of class
  \code{"matrix"}, tabulated data }
  \item{\code{tabdatalong}:}{Object of class
  \code{"matrix"}, dichotomous version of tabulated data }
  \item{\code{Theta}:}{Object of class \code{"matrix"},
  ability grid } \item{\code{Pl}:}{Object of class
  \code{"numeric"}, normed likelihoods for tabulated
  response} \item{\code{prodlist}:}{Object of class
  \code{"list"}, list containing product combination of
  factors } \item{\code{data}:}{Object of class
  \code{"matrix"}, complete data }
  \item{\code{rotate}:}{Object of class \code{"character"},
  type of rotation to be used in \code{summary}}
  \item{\code{converge}:}{Object of class \code{"numeric"},
  convergence diagnostic } \item{\code{quadpts}:}{Object of
  class \code{"numeric"}, number of quadrature points }
  \item{\code{esttype}:}{Object of class
  \code{"character"}, indicates whether estimation was 'EM'
  or 'MHRM'} \item{\code{null.mod}:}{Object of class
  \code{"ExploratoryClass"}, null model}
  \item{\code{Target}:}{Object of class \code{"numeric"},
  dummy rotation matrix} \item{\code{condnum}:}{Object of
  class \code{"numeric"}, condition number of information
  matrix} \item{\code{secondordertest}:}{Object of class
  \code{"logical"}, indicate whether information matrix
  passes second-order test} \item{\code{bfactor}:}{Object
  of class \code{"list"}, an empty list}
  \item{\code{CUSTOM.IND}:}{Object of class
  \code{"integer"}, an internal index}
  \item{\code{SLOW.IND}:}{Object of class \code{"integer"},
  an internal index} \item{\code{Call}:}{Object of class
  \code{"call"}, call } }
}

\section{Methods}{
  \describe{ \item{anova}{\code{signature(object =
  "ExploratoryClass")}} \item{coef}{\code{signature(object
  = "ExploratoryClass")}} \item{plot}{\code{signature(x =
  "ExploratoryClass", y = "missing")}}
  \item{print}{\code{signature(x = "ExploratoryClass")} }
  \item{residuals}{\code{signature(object =
  "ExploratoryClass")}} \item{show}{\code{signature(object
  = "ExploratoryClass")} }
  \item{summary}{\code{signature(object =
  "ExploratoryClass")}} }
}
\author{
Phil Chalmers \email{rphilip.chalmers@gmail.com}
}
\keyword{classes}

