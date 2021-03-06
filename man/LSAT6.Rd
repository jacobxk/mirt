\docType{data}
\name{LSAT6}
\alias{LSAT6}
\title{Description of LSAT6 data}
\description{
Data from Thissen (1982); contains 5 dichotomously scored
items obtained from the Law School Admissions Test, section
6.
}
\examples{
\dontrun{
dat <- expand.table(LSAT6)
head(dat)
model <- mirt.model('F = 1-5
                     CONSTRAIN = (1-5, a1)')
(mod <- mirt(dat, model))
coef(mod)


}
}
\author{
Phil Chalmers \email{rphilip.chalmers@gmail.com}
}
\references{
Thissen, D. (1982). Marginal maximum likelihood estimation
for the one-parameter logistic model. \emph{Psychometrika,
47}, 175-186.
}
\keyword{data}

