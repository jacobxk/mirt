#' Translate mirt parameters for plink package
#'
#' This function exports item parameters from the \code{mirt} package to the
#' \code{plink} package.
#'
#'
#' @aliases read.mirt
#' @param x an object returned from \code{mirt, bfactor}, or \code{multipleGroup}
#' @param as.irt.pars if \code{TRUE}, the parameters will be output as an \code{irt.pars} object
#' @param ... additional arguments to be passed to \code{coef()}
#' @author Phil Chalmers \email{rphilip.chalmers@@gmail.com}
#' @keywords plink
#' @export read.mirt
#' @examples
#'
#' \dontrun{
#'
#' ## unidimensional
#'
#' data <- expand.table(LSAT7)
#' (mod1 <- mirt(data, 1))
#' plinkpars <- read.mirt(mod1)
#' plot(plinkpars)
#' itemplot(mod1, 1)
#'
#' #graded
#' mod2 <- mirt(Science, 1)
#' plinkpars <- read.mirt(mod2)
#' plot(plinkpars)
#' itemplot(mod2, 1)
#'
#' #gpcm
#' mod3 <- mirt(Science, 1, itemtype = 'gpcm')
#' plinkpars <- read.mirt(mod3)
#' plot(plinkpars)
#' itemplot(mod3, 1)
#'
#' #nominal
#' mod4 <- mirt(Science, 1, itemtype = 'nominal')
#' plinkpars <- read.mirt(mod4)
#' plot(plinkpars)
#' itemplot(mod4, 1)
#'
#' ## multidimensional
#'
#' data <- expand.table(LSAT7)
#' (mod1 <- mirt(data, 2))
#' plinkpars <- read.mirt(mod1)
#' plot(plinkpars)
#' itemplot(mod1, 1)
#'
#' cmod <- mirt.model('
#'    F1 = 1,4,5
#'    F2 = 2-4')
#' model <- mirt(data, cmod)
#' plot(read.mirt(model))
#' itemplot(model, 1)
#'
#' #graded
#' mod2 <- mirt(Science, 2)
#' plinkpars <- read.mirt(mod2)
#' plot(plinkpars)
#' itemplot(mod2, 1)
#'
#' ### multiple group
#' set.seed(1234)
#' dat <- expand.table(LSAT7)
#' group <- sample(c('g1', 'g2'), nrow(dat), TRUE)
#' mod <- multipleGroup(dat, 1, group)
#' 
#' # convert, and combine pars
#' plinkMG <- read.mirt(mod)
#' combine <- matrix(1:5, 5, 2)
#' comb <- combine.pars(plinkMG, combine, grp.names=unique(group))
#' out <- plink(comb, rescale="SL")
#' equate(out)
#' equate(out, method = 'OSE')
#'
# #gpcm
# mod3 <- mirt(Science, 2, itemtype = 'gpcm')
# plinkpars <- read.mirt(mod3)
# plot(plinkpars)
# itemplot(mod3, 1)
#
# #nominal
# mod4 <- mirt(Science, 2, itemtype = 'nominal')
# plinkpars <- read.mirt(mod4)
# plot(plinkpars)
# itemplot(mod4, 1)
#' }
read.mirt <- function (x, as.irt.pars = TRUE, ...)
{
    if(!require(plink))
        stop('You must install the plink package.')
    cls <- class(x)
    if(class(x) == 'MultipleGroupClass'){
        pars <- vector('list', length(x@cmods))
        for(i in 1:length(pars))
            pars[[i]] <- read.mirt(x@cmods[[i]], as.irt.pars=as.irt.pars, ...)
        names(pars) <- x@groupNames
        return(pars)
    }
    if(class(x) == 'MixedClass')
        stop('Mixed effect models not supported.')
    if(length(x@prodlist))
        stop('Polynomial factor models not supported in plink')
    #converts unidimensional parameters to classic IRT (if possible)
    nfact <- x@pars[[1]]@nfact
    listpars <- coef(x, IRTpars=ifelse(nfact == 1, TRUE, FALSE), rotate='none', verbose=FALSE, ...)
    nitems <- length(listpars) - 1
    if(!is(listpars[[1]], 'matrix'))
        for(i in 1:nitems)
            listpars[[i]] <- t(matrix(listpars[[i]]))
    mirt.items <- as.character(lapply(x@pars, class))
    mirt.items <- plink.items <- mirt.items[-(nitems+1)]
    cat <- numeric(nitems)
    pars <- matrix(NA, nitems, 40)
    theta <- -4:4
    Theta <- thetaComb(theta, nfact)
    for(i in 1:nitems){

        if(mirt.items[i] == 'dich'){
            plink.items[i] <- 'drm'
            cat[i] <- 2
            abc <- listpars[[i]][1, 1:(nfact+2)]
            pars[i, 1:length(abc)] <- abc
            next
        }

        if(mirt.items[i] == 'graded'){
            plink.items[i] <- 'grm'
            ab <- listpars[[i]][1, ]
            cat[i] <- x@pars[[i]]@ncat
            pars[i, 1:length(ab)] <- ab
            next
        }

        if(mirt.items[i] == 'rsm'){
            stop('Rasch rating scale models not supported for now')
        }

        if(mirt.items[i] == 'nestlogit'){
            stop('nestlogit models not supported in plink')
        }

        if(mirt.items[i] == 'rating'){
            stop('rating model not supported for now')

            #not converted to classic IRT form for now
            plink.items[i] <- 'grm'
            ab <- listpars[[i]][1, ]
            adj <- ab[length(ab)]
            ab <- ab[-length(ab)]
            cat[i] <- x@pars[[i]]@ncat
            for(j in 1:(cat[i] - 1))
                ab[j + nfact] <- ab[j+1] + adj
            pars[i, 1:length(ab)] <- ab
            next
        }

        if(mirt.items[i] == 'gpcm'){
            ab <- listpars[[i]][1, ]
            a <- ab[1:nfact]
            ab <- ab[-(1:nfact)]
            cat[i] <- x@pars[[i]]@ncat
            if(nfact == 1L){
                pars[i, 1:length(ab)] <- ab
            } else {
                stop('Multidimensional gpcm not yet supported')
            }
            next
        }

        if(mirt.items[i] == 'nominal'){
            plink.items[i] <- 'nrm'
            ab <- listpars[[i]][1, ]
            cat[i] <- x@pars[[i]]@ncat
            if(nfact == 1L){
                pars[i, 1:length(ab)] <- ab
            } else {
                stop('Multidimensional nrm not yet supported')
            }
            next
        }

        if(mirt.items[i] == 'partcomp'){
            stop('Partially compensatory models not supported in plink')
        }

        if(mirt.items[i] == 'custom'){
            stop('User defined models not supported in plink')
        }

    }
    model <- unique(plink.items)
    items <- vector('list', length(model))
    index <- 1:nitems
    for(i in 1:length(model))
        items[[i]] <- index[model[i] == plink.items]
    pm <- as.poly.mod(nitems, model=model, items=items)
    pars <- pars[ , colSums(is.na(pars)) != nitems]
    if(as.irt.pars)
        pars <- as.irt.pars(pars, cat=cat, poly.mod=pm, dimensions=nfact, ability=Theta)
    return(pars)
}

