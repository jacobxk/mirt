#' Wald test for mirt models
#'
#' Compute a Wald test given an \code{L} vector or matrix of numeric contrasts. Requires that the
#' model information matrix be computed (including \code{SE = TRUE} when using the EM method). Use
#' \code{wald(model)} to observe how the information matrix columns are named, especially if
#' the estimated model contains constrained parameters (e.g., 1PL). The information matrix names
#' are labelled according to which parameter number(s) they correspond to (to check the
#' numbering use \code{\link{mod2values}} on the estimated object).
#'
#'
#' @aliases wald
#' @param L a coefficient matrix with dimensions nconstrasts x npars, or a vector if only one
#'   set of contrasts is being tested. Omitting this value will return the column names of the
#'   information matrix used to identify the (potentially constrained) parameters
#' @param object estimated object from \code{mirt}, \code{bfactor},
#' \code{multipleGroup}, or \code{mixedmirt}
#' @param C a constant vector/matrix to be compared along side L
#' @keywords wald
#' @export wald
#' @examples
#' \dontrun{
#' #View parnumber index
#' data(LSAT7)
#' data <- expand.table(LSAT7)
#' mod <- mirt(data, 1, SE = TRUE)
#' coef(mod)
#'
#' #see how the information matrix relates to estimated parameters, and how it lines up with the index
#' (infonames <- wald(mod))
#' index <- mod2values(mod)
#' index[index$est, ]
#'
#' #second item slope equal to 0?
#' L <- rep(0, 10)
#' names(L) <- infonames #labelling is optional
#' L[3] <- 1
#' wald(mod, L)
#'
#' #simultaneously test equal factor slopes for item 1 and 2, and 4 and 5
#' L <- matrix(0, 2, 10)
#' colnames(L) <- infonames #again, labelling not required
#' L[1,1] <- L[2, 7] <- 1
#' L[1,3] <- L[2, 9] <- -1
#' L
#' wald(mod, L)
#'
#' #logLiklihood tests (requires estimating a new model)
#' cmodel <- mirt.model('theta = 1-5
#'                       CONSTRAIN = (1,2, a1), (4,5, a1)')
#' mod2 <- mirt(data, cmodel) 
#' #or, eqivalently                     
#' #mod2 <- mirt(data, 1, constrain = list(c(1,5), c(13,17)))
#' anova(mod2, mod)
#' 
#' }
wald <- function(object, L, C = 0){
    if(all(dim(object@information) == c(1,1)))
        if(object@information[1,1] == 0L)
            stop('No information matrix has been calculated for the model')
    Names <- colnames(object@information)
    if(missing(L)){
        names(Names) <- 1:length(Names)
        return(Names)
    }
    if(!is.matrix(L))
        L <- matrix(L, 1)
    pars <- object@pars
    if(is(object, 'MultipleGroupClass'))
        pars <- object@cmods
    covB <- solve(object@information)
    B <- parnum <- c()
    if(is(object, 'MultipleGroupClass')){
        for(g in 1L:length(pars)){
            for(i in 1L:length(pars[[g]]@pars)){
                B <- c(B, pars[[g]]@pars[[i]]@par)
                parnum <- c(parnum, pars[[g]]@pars[[i]]@parnum)
            }
        }
    } else {
        for(i in 1L:length(pars)){
            B <- c(B, pars[[i]]@par)
            parnum <- c(parnum, pars[[i]]@parnum)
        }
    }
    if(is(object, 'MixedClass')){
        if(length(object@random)){
            for(i in 1L:length(object@random)){
                B <- c(B, object@random[[i]]@par)
                tmp <- object@random[[i]]@parnum
                names(tmp) <- names(object@random[[i]]@est)
                parnum <- c(parnum, tmp)
            }
        }
    }
    keep <- c()
    for(i in 1L:length(Names))
        keep <- c(keep, as.numeric(strsplit(Names[i], '.', fixed = TRUE)[[1]][2]))
    B <- B[keep]
    W <- t(L %*% B - C) %*% solve(L %*% covB %*% t(L)) %*% (L %*% B - C)
    W <- ifelse(W < 0, 0, W)
    ret <- list(W=W, df = nrow(L))
    p <- 1 - pchisq(ret$W, ret$df)
    ret$p <- p
    class(ret) <- 'wald'
    ret
}

#' @S3method print wald
#' @rdname wald
#' @method print wald
#' @param x an object of class 'wald'
#' @param ... additional arguments to be passed
print.wald <- function(x, ...){
    cat('\nWald test: \nW = ', round(x$W, 3), ', df = ', x$df, ', p = ',
        round(x$p, 3), '\n', sep='')
}

