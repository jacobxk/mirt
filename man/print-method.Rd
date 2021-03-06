\docType{methods}
\name{print-method}
\alias{print,ConfirmatoryClass-method}
\alias{print,ExploratoryClass-method}
\alias{print,MixedClass-method}
\alias{print,MultipleGroupClass-method}
\alias{print-method}
\title{Print the model objects}
\usage{
\S4method{print}{ExploratoryClass}(x)
}
\arguments{
  \item{x}{an object of class \code{ExploratoryClass},
  \code{ConfirmatoryClass}, \code{MultipleGroupClass}, or
  \code{MixedClass}}
}
\description{
Print model object summaries to the console.
}
\examples{
\dontrun{
x <- mirt(Science, 1)
print(x)
}
}

