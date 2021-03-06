#' Item fit statistics
#'
#' \code{itemfit} calculates the Zh values from Drasgow, Levine and Williams (1985),
#' \eqn{\chi^2} values for unidimensional models, and S-X2 statistics for unidimensional models
#' (Kang & Chen, 2007; Orlando & Thissen, 2000). For Rasch, partial credit, and rating scale models
#' infit and outfit statistics are also produced.
#'
#' @aliases itemfit
#' @param x a computed model object of class \code{ExploratoryClass}, \code{ConfirmatoryClass}, or
#'   \code{MultipleGroupClass}
#' @param Zh logical; calculate Zh and associated statistics (infit/outfit)? Disable this is you are only
#'   interested in computing the S-X2 quickly
#' @param X2 logical; calculate the X2 statistic for unidimensional models?
#' @param mincell the minimum expected cell size to be used in the S-X2 computations. Tables will be
#'   collapsed across items first if polytomous, and then across scores if necessary
#' @param S_X2.tables logical; return the tables in a list format used to compute the S-X2 stats?
#' @param group.size approximate size of each group to be used in calculating the \eqn{\chi^2} statistic
#' @param empirical.plot a single numeric value or character of the item name  indicating which item to plot
#'   (via \code{itemplot}) and overlay with the empirical \eqn{\theta} groupings. Only applicable
#'   when \code{type = 'X2'}. The default is \code{NULL}, therefore no plots are drawn
#' @param empirical.CI a numeric value indicating the width of the empirical confidence interval ranging 
#'   between 0 and 1 (default of 0 plots not interval). For example, a 95% confidence interval would be 
#'   plotted if \code{empirical.CI = .95}. Only applicable to dichotomous items
#' @param method type of factor score estimation method. See \code{\link{fscores}} for more detail
#' @param Theta a matrix of factor scores used for statistics that require emperical estimates. If 
#'   supplied, arguments typically passed to \code{fscores()} will be ignored and these values will
#'   be used instead
#' @param ... additional arguments to be passed to \code{fscores()}
#' @author Phil Chalmers \email{rphilip.chalmers@@gmail.com}
#' @keywords item fit
#' @export itemfit
#'
#' @seealso
#' \code{\link{personfit}}
#'
#' @references
#'
#' Drasgow, F., Levine, M. V., & Williams, E. A. (1985). Appropriateness measurement with
#' polychotomous item response models and standardized indices.
#' \emph{Journal of Mathematical and Statistical Psychology, 38}, 67-86.
#'
#' Kang, T. & Chen, Troy, T. (2007). An investigation of the performance of the generalized
#' S-X2 item-fit index for polytomous IRT models. ACT
#'
#' Orlando, M. & Thissen, D. (2000). Likelihood-based item fit indices for dichotomous item response theory
#' models. \emph{Applied Psychological Measurement, 24}, 50-64.
#'
#' Reise, S. P. (1990). A comparison of item- and person-fit methods of assessing model-data fit
#' in IRT. \emph{Applied Psychological Measurement, 14}, 127-137.
#'
#'
#'
#' @examples
#'
#' \dontrun{
#'
#' #make some data
#' set.seed(1234)
#' a <- matrix(rlnorm(20, meanlog=0, sdlog = .1),ncol=1)
#' d <- matrix(rnorm(20),ncol=1)
#' items <- rep('dich', 20)
#' data <- simdata(a,d, 2000, items)
#'
#' x <- mirt(data, 1)
#' raschfit <- mirt(data, 1, itemtype='Rasch')
#' fit <- itemfit(x)
#' fit
#'
#' itemfit(x, empirical.plot = 1) #empirical item plot
#' itemfit(x, empirical.plot = 1, empirical.CI = .99) #empirical item plot with 99% CI's
#' #method='ML' agrees better with eRm package
#' itemfit(raschfit, method = 'ML') #infit and outfit stats
#' #same as above, but inputting ML estimates instead
#' Theta <- fscores(raschfit, method = 'ML', full.scores=TRUE, scores.only=TRUE)
#' itemfit(raschfit, Theta=Theta)
#'
#' #similar example to Kang and Chen 2007
#' a <- matrix(c(.8,.4,.7, .8, .4, .7, 1, 1, 1, 1))
#' d <- matrix(rep(c(2.0,0.0,-1,-1.5),10), ncol=4, byrow=TRUE)
#' dat <- simdata(a,d,2000, itemtype = rep('graded', 10)) - 1
#' head(dat)
#'
#' mod <- mirt(dat, 1)
#' itemfit(mod)
#'
#' mod2 <- mirt(dat, 1, 'Rasch')
#' itemfit(mod2)
#'
#' #massive list of tables
#' tables <- itemfit(mod, S_X2.tables = TRUE)
#'
#' #observed and expected total score patterns for item 1 (post collapsing)
#' tables$O[[1]]
#' tables$E[[1]]
#'
#'
#'   }
#'
itemfit <- function(x, Zh = TRUE, X2 = FALSE, group.size = 150, mincell = 1, S_X2.tables = FALSE,
                    empirical.plot = NULL, empirical.CI = 0, method = 'EAP', Theta = NULL, ...){
    if(any(is.na(x@data)))
        stop('Fit statistics cannot be computed when there are missing data.')
    if(is(x, 'MultipleGroupClass')){
        ret <- list()
        for(g in 1L:length(x@cmods)){
            x@cmods[[g]]@itemtype <- x@itemtype
            ret[[g]] <- itemfit(x@cmods[[g]], group.size=group.size, mincell = 1,
                                S_X2.tables = FALSE, method=method, Theta=Theta, ...)
        }
        names(ret) <- x@groupNames
        return(ret)
    }
    if(S_X2.tables) Zh <- X2 <- FALSE
    ret <- data.frame(item=colnames(x@data))
    J <- ncol(x@data)
    itemloc <- x@itemloc
    pars <- x@pars
    if(Zh || X2){
        if(is.null(Theta))
            Theta <- fscores(x, verbose=FALSE, full.scores=TRUE, 
                             scores.only=TRUE, method=method, ...)
        prodlist <- attr(pars, 'prodlist')
        nfact <- x@nfact + length(prodlist)
        fulldata <- x@fulldata
        if(method %in% c('ML', 'WLE')){
            for(i in 1L:ncol(Theta)){
                tmp <- Theta[,i]
                tmp[tmp %in% c(-Inf, Inf)] <- NA
                Theta[Theta[,i] == Inf, i] <- max(tmp, na.rm=TRUE) + .1
                Theta[Theta[,i] == -Inf, i] <- min(tmp, na.rm=TRUE) - .1
            }
        }
        N <- nrow(Theta)
        itemtrace <- matrix(0, ncol=ncol(fulldata), nrow=N)
        for (i in 1L:J)
            itemtrace[ ,itemloc[i]:(itemloc[i+1L] - 1L)] <- ProbTrace(x=pars[[i]], Theta=Theta)
        LL <- itemtrace * fulldata
        LL[LL < .Machine$double.eps] <- 1
        Lmatrix <- matrix(log(LL[as.logical(fulldata)]), N, J)
        mu <- sigma2 <- rep(0, J)
        log_itemtrace <- log(itemtrace)
        for(item in 1L:J){
            P <- itemtrace[ ,itemloc[item]:(itemloc[item+1L]-1L)]
            log_P <- log_itemtrace[ ,itemloc[item]:(itemloc[item+1L]-1L)]
            mu[item] <- sum(P * log_P)
            for(i in 1L:ncol(P))
                for(j in 1L:ncol(P))
                    if(i != j)
                        sigma2[item] <- sigma2[item] + sum(P[,i] * P[,j] * log_P[,i] * log(P[,i]/P[,j]))
        }
        ret$Zh <- (colSums(Lmatrix) - mu) / sqrt(sigma2)
        #if all Rasch models, infit and outfit
        if(all(x@itemtype %in% c('Rasch', 'rsm', 'gpcm'))){
            oneslopes <- rep(FALSE, length(x@itemtype))
            for(i in 1L:length(x@itemtype))
                oneslopes[i] <- closeEnough(x@pars[[i]]@par[1L], 1-1e-10, 1+1e-10)
            if(all(oneslopes)){
                attr(x, 'inoutfitreturn') <- TRUE
                pf <- personfit(x, method=method, Theta=Theta)
                z2 <- pf$resid^2 / pf$W
                outfit <- colSums(z2) / N
                q.outfit <- sqrt(colSums((pf$C / pf$W^2) / N^2) - 1 / N)
                q.outfit[q.outfit > 1.4142] <- 1.4142
                z.outfit <- (outfit^(1/3) - 1) * (3/q.outfit) + (q.outfit/3)
                infit <- colSums(pf$W * z2) / colSums(pf$W)
                q.infit <- sqrt(colSums(pf$C - pf$W^2) / colSums(pf$W)^2)
                q.infit[q.infit > 1.4142] <- 1.4142
                z.infit <- (infit^(1/3) - 1) * (3/q.infit) + (q.infit/3)
                ret$outfit <- outfit
                ret$z.outfit <- z.outfit
                ret$infit <- infit
                ret$z.infit <- z.infit
            }
        }
    }
    if((X2 || !is.null(empirical.plot)) && nfact == 1L){
        ord <- order(Theta[,1L])
        fulldata <- fulldata[ord,]
        Theta <- Theta[ord, , drop = FALSE]
        den <- dnorm(Theta, 0, .5)
        den <- den / sum(den)
        cumTheta <- cumsum(den)
        Groups <- rep(20, length(ord))
        ngroups <- ceiling(nrow(fulldata) / group.size)
        weight <- 1/ngroups
        for(i in 1L:20L)
            Groups[round(cumTheta,2) >= weight*(i-1) & round(cumTheta,2) < weight*i] <- i
        n.uniqueGroups <- length(unique(Groups))
        X2 <- df <- RMSEA <- rep(0, J)
        if(!is.null(empirical.plot)){
            if(nfact > 1L) stop('Cannot make empirical plot for multidimensional models')
            theta <- seq(-4,4, length.out=40)
            ThetaFull <- thetaComb(theta, nfact)
            if(!is.numeric(empirical.plot)){
                inames <- colnames(x@data)
                ind <- 1L:length(inames)
                empirical.plot <- ind[inames == empirical.plot]
            }
            empirical.plot_P <- ProbTrace(pars[[empirical.plot]], ThetaFull)
            empirical.plot_points <- matrix(NA, length(unique(Groups)), x@K[empirical.plot] + 2L)
        }
        for (i in 1L:J){
            if(!is.null(empirical.plot) && i != empirical.plot) next
            for(j in unique(Groups)){
                dat <- fulldata[Groups == j, itemloc[i]:(itemloc[i+1] - 1), drop = FALSE]
                r <- colSums(dat)
                N <- nrow(dat)
                mtheta <- matrix(mean(Theta[Groups == j,]), nrow=1)
                if(!is.null(empirical.plot)){
                    tmp <- r/N
                    empirical.plot_points[j, ] <- c(mtheta, N, tmp)
                }
                P <- ProbTrace(x=pars[[i]], Theta=mtheta)
                if(any(N * P < 2)){
                    df[i] <- df[i] - 1
                    next
                }
                X2[i] <- X2[i] + sum((r - N*P)^2 / N*P)
            }
            df[i] <- df[i] + n.uniqueGroups*(length(r) - 1) - sum(pars[[i]]@est)
        }
        X2[X2 == 0] <- NA
        if(!is.null(empirical.plot)){
            K <- x@K[empirical.plot]
            EPCI.lower <- EPCI.upper <- NULL
            if(K == 2 && empirical.CI != 0){
                p.L <- function(x, alpha) if (x[1] == 0) 0 else qbeta(alpha, x[1], x[2] - x[1] + 1)
                p.U <- function(x, alpha) if (x[1] == x[2]) 1 else qbeta(1 - alpha, x[1] + 1, x[2] - x[1])
                N <- empirical.plot_points[,2]
                O <- empirical.plot_points[,ncol(empirical.plot_points)] * N
                EPCI.lower <- apply(cbind(O, N), 1, p.L, (1-empirical.CI)/2)
                EPCI.upper <- apply(cbind(O, N), 1, p.U, (1-empirical.CI)/2)
            }
            empirical.plot_points <- empirical.plot_points[,-2]
            colnames(empirical.plot_points) <- c('theta', paste0('p.', 1:K))
            while(nrow(empirical.plot_points) < nrow(empirical.plot_P))
                empirical.plot_points <- rbind(empirical.plot_points, 
                                               rep(NA, length(empirical.plot_points[1,])))
            plt.1 <- data.frame(id = 1:nrow(ThetaFull), Theta=ThetaFull, P=empirical.plot_P)
            plt.1 <- reshape(plt.1, varying = 3:ncol(plt.1), direction = 'long', timevar = 'cat')
            plt.2 <- data.frame(id = 1:nrow(empirical.plot_points), empirical.plot_points)
            plt.2 <- reshape(plt.2, varying = 3:ncol(plt.2), direction = 'long', timevar = 'cat')
            plt <- cbind(plt.1, plt.2)
            if(K == 2) plt <- plt[plt$cat != 1, ]
            return(xyplot(P ~ Theta, plt, group = cat, 
                          main = paste('Empirical plot for item', empirical.plot), ylim = c(-0.1,1.1),
                          xlab = expression(theta), ylab=expression(P(theta)), 
                          auto.key=ifelse(K==2, FALSE, TRUE), EPCI.lower=EPCI.lower,
                          EPCI.upper=EPCI.upper,
                          panel = function(x, y, groups, subscripts, EPCI.lower, EPCI.upper, ...){
                              panel.xyplot(x=x, y=y, groups=groups, type='l', subscripts=subscripts, ...)
                              panel.points(cbind(plt$theta, plt$p), col=groups, pch=groups, ...)     
                              if(!is.null(EPCI.lower)){
                                  theta <- na.omit(plt$theta)
                                  for(i in 1:length(theta))
                                      panel.lines(c(theta[i], theta[i]), c(EPCI.lower[i], EPCI.upper[i]),
                                                  lty = 2, col = 'red')
                              }
                          }))
        }
        ret$X2 <- X2
        ret$df <- df
        ret$p.X2 <- round(1 - pchisq(X2, df), 4)
    }
    makeObstables <- function(dat, K){
        ret <- vector('list', ncol(dat))
        sumscore <- rowSums(dat)
        for(i in 1L:length(ret)){
            ret[[i]] <- matrix(0, sum(K-1L)+1L, K[i])
            colnames(ret[[i]]) <- paste0(1L:K[i]-1L)
            rownames(ret[[i]]) <- paste0(1L:nrow(ret[[i]])-1L)
            split <- by(sumscore, dat[,i], table)
            for(j in 1L:K[i]){
                m <- match(names(split[[j]]), rownames(ret[[i]]))
                ret[[i]][m,j] <- split[[j]]
            }
            ret[[i]] <- ret[[i]][-c(1L, nrow(ret[[i]])), ]
        }
        ret
    }
    collapseCells <- function(O, E, mincell = 1){
        for(i in 1L:length(O)){
            On <- O[[i]]
            En <- E[[i]]
            drop <- which(rowSums(is.na(En)) > 0)
            En[is.na(En)] <- 0
            #collapse known upper and lower sparce cells
            if(length(drop) > 0L){
                up <- drop[1L]:drop[length(drop)/2]
                low <- drop[length(drop)/2 + 1L]:drop[length(drop)]
                En[max(up)+1, ] <- colSums(En[c(up, max(up)+1), , drop = FALSE])
                On[max(up)+1, ] <- colSums(On[c(up, max(up)+1), , drop = FALSE])
                En[min(low)-1, ] <- colSums(En[c(low, min(low)-1), , drop = FALSE])
                On[min(low)-1, ] <- colSums(On[c(low, min(low)-1), , drop = FALSE])
                En[c(up, low), ] <- On[c(up, low), ] <- NA
                En <- na.omit(En)
                On <- na.omit(On)
            }
            #collapse accross
            if(ncol(En) > 2L){
                for(j in 1L:(ncol(On)-1L)){
                    L <- En < mincell
                    sel <- L[,j]
                    if(!any(sel)) next
                    On[sel, j+1L]  <- On[sel, j] + On[sel, j+1L]
                    En[sel, j+1L]  <- En[sel, j] + En[sel, j+1L]
                    On[sel, j] <- En[sel, j] <- NA
                }
                sel <- L[,j+1L]
                sel[rowSums(is.na(En[, 1L:j])) == (ncol(En)-1L)] <- FALSE
                put <- apply(En[sel, 1L:j, drop=FALSE], 1, function(x) max(which(!is.na(x))))
                put2 <- which(sel)
                for(k in 1L:length(put)){
                    En[put2[k], put[k]] <- En[put2[k], put[k]] + En[put2[k], j+1L]
                    En[put2[k], j+1L] <- On[put2[k], j+1L] <- NA
                }
            }
            L <- En < mincell
            L[is.na(L)] <- FALSE
            while(any(L)){
                drop <- c()
                for(j in 1L:(nrow(On)-1L)){
                    if(any(L[j,])) {
                        On[j+1L, L[j,]] <- On[j+1L, L[j,]] + On[j, L[j,]]
                        En[j+1L, L[j,]] <- En[j+1L, L[j,]] + En[j, L[j,]]
                        drop <- c(drop, j)
                        break
                    }
                }
                for(j in nrow(On):2L){
                    if(any(L[j,])) {
                        On[j-1L, L[j,]] <- On[j-1L, L[j,]] + On[j, L[j,]]
                        En[j-1L, L[j,]] <- En[j-1L, L[j,]] + En[j, L[j,]]
                        drop <- c(drop, j)
                        break
                    }
                }
                if(nrow(On) > 4L){
                    for(j in 2L:(nrow(On)-1L)){
                        if(any(L[j,])){
                            On[j+1L, L[j,]] <- On[j+1L, L[j,]] + On[j, L[j,]]
                            En[j+1L, L[j,]] <- En[j+1L, L[j,]] + En[j, L[j,]]
                            drop <- c(drop, j)
                            break
                        }
                    }
                }
                #drop
                if(!is.null(drop)){
                    En <- En[-drop, ]
                    On <- On[-drop, ]
                }
                L <- En < mincell
                L[is.na(L)] <- FALSE
            }
            E[[i]] <- En
            O[[i]] <- On
        }
        return(list(O=O, E=E))
    }
    if(x@nfact == 1L){
        dat <- x@data
        adj <- apply(dat, 2, min)
        if(any(adj > 0))
            message('Data adjusted so that the lowest category score for every item is 0')
        dat <- t(t(dat) - adj)
        S_X2 <- df.S_X2 <- numeric(J)
        O <- makeObstables(dat, x@K)
        Nk <- rowSums(O[[1L]])
        E <- EAPsum(x, S_X2 = TRUE, gp = list(gmeans=0, gcov=matrix(1)), CUSTOM.IND=x@CUSTOM.IND)
        for(i in 1L:J)
            E[[i]] <- E[[i]] * Nk
        coll <- collapseCells(O, E, mincell=mincell)
        if(S_X2.tables) return(list(O.org=O, E.org=E, O=coll$O, E=coll$E))
        O <- coll$O
        E <- coll$E
        for(i in 1L:J){
            if (is.null(dim(O[[i]]))) next
            S_X2[i] <- sum((O[[i]] - E[[i]])^2 / E[[i]], na.rm = TRUE)
            df.S_X2[i] <- (ncol(O[[i]])-1L) * nrow(O[[i]]) - sum(pars[[i]]@est) - sum(is.na(E[[i]]))
        }
        S_X2[df.S_X2 <= 0] <- NaN
        ret$S_X2 <- S_X2
        ret$df.S_X2 <- df.S_X2
        ret$p.S_X2 <- round(1 - pchisq(S_X2, df.S_X2), 4)
    }
    return(ret)
}
