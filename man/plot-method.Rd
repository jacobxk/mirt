\docType{methods}
\name{plot-method}
\alias{plot,ConfirmatoryClass-method}
\alias{plot,ExploratoryClass,missing-method}
\alias{plot,ExploratoryClass-method}
\alias{plot,MultipleGroupClass-method}
\alias{plot-method}
\title{Plot various test implied functions from models}
\usage{
\S4method{plot}{ExploratoryClass,missing}(x, y, type = "info", npts = 50,
  theta_angle = 45, theta_lim = c(-4, 4), which.items = 1:ncol(x@data),
  rot = list(xaxis = -70, yaxis = 30, zaxis = 10), facet_items = TRUE,
  auto.key = TRUE, main = NULL, drape = TRUE, colorkey = TRUE,
  ehist.cut = 1e-10, add.ylab2 = TRUE, ...)
}
\arguments{
  \item{x}{an object of class \code{ExploratoryClass},
  \code{ConfirmatoryClass} or \code{MultipleGroupClass}}

  \item{y}{an arbitrary missing argument required for
  \code{R CMD check}}

  \item{type}{type of plot to view; can be \code{'info'} to
  show the test information function, \code{'infocontour'}
  for the test information contours, \code{'SE'} for the
  test standard error function, \code{'trace'} and
  \code{'infotrace'} for all item probability information
  or trace lines (only available when all items are
  dichotomous), \code{'infoSE'} for a combined test
  information and standard error plot, and \code{'score'}
  and \code{'scorecontour'} for the expected total score
  surface and contour plots.  If \code{empiricalhist =
  TRUE} was used in estimation then the type
  \code{'empiricalhist'} also will be available to generate
  the empirical histogram plot}

  \item{theta_angle}{numeric values ranging from 0 to 90
  used in \code{plot}.  If a vector is used then a bubble
  plot is created with the summed information across the
  angles specified (e.g., \code{theta_angle = seq(0, 90,
  by=10)})}

  \item{theta_lim}{lower and upper limits of the latent
  trait (theta) to be evaluated, and is used in conjunction
  with \code{npts}}

  \item{npts}{number of quadrature points to be used for
  plotting features.  Larger values make plots look
  smoother}

  \item{rot}{allows rotation of the 3D graphics}

  \item{which.items}{numeric vector indicating which items
  to be used when plotting. Default is to use all available
  items}

  \item{facet_items}{logical; apply grid of plots across
  items? If \code{FALSE}, items will be placed in one plot
  for each group}

  \item{auto.key}{logical parameter passed to the
  \code{lattice} package}

  \item{ehist.cut}{a probability value indicating a
  threshold for excluding cases in empirical histogram
  plots. Values larger than the default will include more
  points in the tails of the plot, potentially squishing
  the 'meat' of the plot to take up less area than visually
  desired}

  \item{main}{argument passed to lattice. Default generated
  automatically}

  \item{drape}{logical argument passed to lattice. Default
  generated automatically}

  \item{colorkey}{logical argument passed to lattice.
  Default generated automatically}

  \item{add.ylab2}{logical argument passed to lattice.
  Default generated automatically}

  \item{...}{additional arguments to be passed to lattice}
}
\description{
Plot various test implied response functions from models
estimated in the mirt package.
}
\examples{
\dontrun{
x <- mirt(Science, 1)
plot(x)
plot(x, type = 'trace')
plot(x, type = 'infotrace')
plot(x, type = 'infotrace', facet_items = FALSE)
plot(x, type = 'infoSE')

set.seed(1234)
group <- sample(c('g1','g2'), nrow(Science), TRUE)
x2 <- multipleGroup(Science, 1, group)
plot(x2)
plot(x2, type = 'trace')
plot(x2, type = 'trace', which.items = 1:2)
plot(x2, type = 'trace', which.items = 1, facet_items = FALSE) #facet by group
plot(x2, type = 'score')

x3 <- mirt(Science, 2)
plot(x3)
plot(x3, type = 'SE')

}
}

