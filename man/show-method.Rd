\docType{methods}
\name{show-method}
\alias{show,ConfirmatoryClass-method}
\alias{show,ExploratoryClass-method}
\alias{show,MixedClass-method}
\alias{show,MultipleGroupClass-method}
\alias{show-method}
\title{Show model object}
\usage{
\S4method{show}{ExploratoryClass}(object)
}
\arguments{
  \item{object}{an object of class \code{ExploratoryClass},
  \code{ConfirmatoryClass}, \code{MultipleGroupClass}, or
  \code{MixedClass}}
}
\description{
Print model object summaries to the console.
}
\examples{
\dontrun{
x <- mirt(Science, 1)
show(x)
}
}

