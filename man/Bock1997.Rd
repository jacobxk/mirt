\docType{data}
\name{Bock1997}
\alias{Bock1997}
\title{Description of Bock 1997 data}
\description{
A 3-item tabulated data set extracted from Table 3 in
Chapter Two.
}
\examples{
\dontrun{
dat <- expand.table(Bock1997)
head(dat)
mod <- mirt(dat, 1, 'nominal')

#reproduce table 3 in Bock (1997)
fs <- round(fscores(mod, verbose = FALSE)[,c('F1','SE_F1')],2)
fttd <- residuals(mod, type = 'exp')
table <- data.frame(fttd[,-ncol(fttd)], fs)
table

#using nominal.highlow matrix to specify lowest and highest categories
(nominal.highlow <- matrix(c(4,4,4,4,1,1,1,1), 2, byrow = TRUE))
mod <- mirt(dat, 1, 'nominal', nominal.highlow=nominal.highlow)
coef(mod)

 }
}
\author{
Phil Chalmers \email{rphilip.chalmers@gmail.com}
}
\references{
Bock, R. D. (1997). The Nominal Categories Model. In van
der Linden, W. J. & Hambleton, R. K. \emph{Handbook of
modern item response theory}. New York: Springer.
}
\keyword{data}

