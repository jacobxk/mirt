\docType{methods}
\name{anova-method}
\alias{anova,ConfirmatoryClass-method}
\alias{anova,ExploratoryClass-method}
\alias{anova,MixedClass-method}
\alias{anova,MultipleGroupClass-method}
\alias{anova-method}
\title{Compare nested models}
\usage{
\S4method{anova}{ExploratoryClass}(object, object2, verbose = TRUE)
}
\arguments{
  \item{object}{an object of class \code{ExploratoryClass},
  \code{ConfirmatoryClass}, \code{MultipleGroupClass}, or
  \code{MixedClass}}

  \item{object2}{a second model estimated from any of the
  mirt package estimation methods}

  \item{verbose}{logical; print additional information to
  console?}
}
\description{
Compare nested models using likelihood ratio, AIC, BIC,
etc.
}
\examples{
\dontrun{
x <- mirt(Science, 1)
x2 <- mirt(Science, 2)
anova(x, x2)
}
}

