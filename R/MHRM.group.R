MHRM.group <- function(pars, constrain, PrepList, list, debug)
{
    if(debug == 'MHRM.group') browser()    
    verbose <- list$verbose        
    nfact <- list$nfact
    NCYCLES <- list$NCYCLES
    BURNIN <- list$BURNIN
    SEMCYCLES <- list$SEMCYCLES
    KDRAWS <- list$KDRAWS
    TOL <- list$TOL    
    gain <- list$gain    
    itemloc <- list$itemloc
    ngroups <- length(pars)
    J <- length(itemloc) - 1
    prodlist <- PrepList[[1]]$prodlist            
    nfullpars <- 0
    estpars <- c()
    gfulldata <- gtheta0 <- gstructgrouppars <- vector('list', ngroups)
    for(g in 1:ngroups){
        gstructgrouppars[[g]] <- ExtractGroupPars(pars[[g]][[J+1]])
        gfulldata[[g]] <- PrepList[[g]]$fulldata
        gtheta0[[g]] <- matrix(0, nrow(gfulldata[[g]]), nfact)
        for(i in 1:(J+1)){        
            nfullpars <- nfullpars + length(pars[[g]][[i]]@par)                
            estpars <- c(estpars, pars[[g]][[i]]@est)
        }
    }
    index <- 1:nfullpars    
    #Burn in
    cand.t.var <- 1
    tmp <- .1
    for(g in 1:ngroups){             
        for(i in 1:30){			
            gtheta0[[g]] <- draw.thetas(theta0=gtheta0[[g]], pars=pars[[g]], fulldata=gfulldata[[g]], 
                                        itemloc=itemloc, cand.t.var=cand.t.var, 
                                        prior.t.var=gstructgrouppars[[g]]$gcov, 
                                        prior.mu=gstructgrouppars[[g]]$gmeans, prodlist=prodlist, 
                                        debug=debug)
            if(i > 5){		
                if(attr(gtheta0[[g]],"Proportion Accepted") > .35) cand.t.var <- cand.t.var + 2*tmp 
                else if(attr(gtheta0[[g]],"Proportion Accepted") > .25 && nfact > 3) 
                    cand.t.var <- cand.t.var + tmp
                else if(attr(gtheta0[[g]],"Proportion Accepted") < .2 && nfact < 4) 
                    cand.t.var <- cand.t.var - tmp
                else if(attr(gtheta0[[g]],"Proportion Accepted") < .1) 
                    cand.t.var <- cand.t.var - 2*tmp
                if (cand.t.var < 0){
                    cand.t.var <- tmp		
                    tmp <- tmp / 2
                }		
            }            
        }	        
    }
    m.thetas <- grouplist <- SEM.stores <- SEM.stores2 <- m.list <- list()	  
    conv <- 0
    k <- 1	
    gamma <- .25
    longpars <- rep(NA,nfullpars)
    ind1 <- 1
    for(g in 1:ngroups){
        for(i in 1:(J+1)){
            ind2 <- ind1 + length(pars[[g]][[i]]@par) - 1
            longpars[ind1:ind2] <- pars[[g]][[i]]@par
            ind1 <- ind2 + 1
        }                  
    }
    stagecycle <- 1	
    converge <- 1    
    noninvcount <- 0    
    L <- c()    
    for(g in 1:ngroups)
        for(i in 1:(J+1))
            L <- c(L, pars[[g]][[i]]@est)    
    estindex <- index[estpars]
    L <- diag(as.numeric(L))
    redun_constr <- rep(FALSE, length(estpars)) 
    if(length(constrain) > 0){
        for(i in 1:length(constrain)){            
            L[constrain[[i]], constrain[[i]]] <- 1/length(constrain[[i]]) 
            for(j in 2:length(constrain[[i]]))
                redun_constr[constrain[[i]][j]] <- TRUE
        }
    }
    estindex_unique <- index[estpars & !redun_constr]
    if(any(diag(L)[!estpars] > 0)){
        redindex <- index[!estpars]        
        stop('Constraint applied to fixed parameter(s) ', 
             paste(redindex[diag(L)[!estpars] > 0]), ' but should only be applied to 
                 estimated parameters. Please fix!')
    }          
    ####Big MHRM loop
    for(cycles in 1:(NCYCLES + BURNIN + SEMCYCLES))
    {     
        if(is.list(debug)) print(longpars[debug[[1]]])
        if(cycles == BURNIN + 1) stagecycle <- 2			
        if(stagecycle == 3)
            gamma <- (gain[1] / (cycles - SEMCYCLES - BURNIN - 1))^(gain[2]) - gain[3]
        if(cycles == (BURNIN + SEMCYCLES + 1)){ 
            stagecycle <- 3		
            longpars <- SEM.stores[[1]]
            Tau <- SEM.stores2[[1]]
            for(i in 2:SEMCYCLES){
                longpars <- longpars + SEM.stores[[i]]
                Tau <- Tau + SEM.stores2[[i]]
            }	
            longpars <- longpars/SEMCYCLES	
            Tau <- Tau/SEMCYCLES	
            k <- KDRAWS	
            gamma <- .25
        }  
        #Reload pars list
        if(list$USEEM) longpars <- list$startlongpars
        ind1 <- 1
        for(g in 1:ngroups){
            for(i in 1:(J+1)){
                ind2 <- ind1 + length(pars[[g]][[i]]@par) - 1
                pars[[g]][[i]]@par <- longpars[ind1:ind2]
                ind1 <- ind2 + 1       
                if(any(class(pars[[g]][[i]]) == c('dich', 'partcomp'))){
                    if(pars[[g]][[i]]@par[length(pars[[g]][[i]]@par)] > 1) 
                        pars[[g]][[i]]@par[length(pars[[g]][[i]]@par)] <- 1
                    if(pars[[g]][[i]]@par[length(pars[[g]][[i]]@par)-1] < 0) 
                        pars[[g]][[i]]@par[length(pars[[g]][[i]]@par)-1] <- 0
                }
            }
            #apply sum(t) == 1 constraint for mcm
            if(is(pars[[g]][[i]], 'mcm')){
                tmp <- pars[[g]][[i]]@par
                tmp[length(tmp) - pars[[g]][[i]]@ncat + 1] <- 1 - sum(tmp[length(tmp):(length(tmp) - 
                    pars[[g]][[i]]@ncat + 2)])
                pars[[g]][[i]]@par <- tmp
            }
        }        
        for(g in 1:ngroups)
            gstructgrouppars[[g]] <- ExtractGroupPars(pars[[g]][[J+1]])
        
        #Step 1. Generate m_k datasets of theta 
        LL <- 0
        for(g in 1:ngroups){            
            for(i in 1:5)    		
                gtheta0[[g]] <- draw.thetas(theta0=gtheta0[[g]], pars=pars[[g]], fulldata=gfulldata[[g]], 
                                      itemloc=itemloc, cand.t.var=cand.t.var, 
                                      prior.t.var=gstructgrouppars[[g]]$gcov, 
                                      prior.mu=gstructgrouppars[[g]]$gmeans, prodlist=prodlist, 
                                      debug=debug)            
            LL <- LL + attr(gtheta0[[g]], "log.lik")
        }
        
        #Step 2. Find average of simulated data gradients and hessian 		
        g.m <- h.m <- group.m <- list()
        longpars <- g <- rep(0, nfullpars)
        h <- matrix(0, nfullpars, nfullpars) 
        ind1 <- 1
        for(group in 1:ngroups){            
            thetatemp <- gtheta0[[group]]
            if(length(prodlist) > 0) thetatemp <- prodterms(thetatemp,prodlist)	
            for (i in 1:J){	
                deriv <- Deriv(x=pars[[group]][[i]], Theta=thetatemp)
                ind2 <- ind1 + length(deriv$grad) - 1
                longpars[ind1:ind2] <- pars[[group]][[i]]@par
                g[ind1:ind2] <- pars[[group]][[i]]@gradient <- deriv$grad
                h[ind1:ind2, ind1:ind2] <- pars[[group]][[i]]@hessian <- deriv$hess
                ind1 <- ind2 + 1 
            }          
            i <- i + 1
            deriv <- Deriv(x=pars[[group]][[i]], Theta=gtheta0[[group]])
            ind2 <- ind1 + length(deriv$grad) - 1
            longpars[ind1:ind2] <- pars[[group]][[i]]@par
            g[ind1:ind2] <- pars[[group]][[i]]@gradient <- deriv$grad
            h[ind1:ind2, ind1:ind2] <- pars[[group]][[i]]@hessian <- deriv$hess
            ind1 <- ind2 + 1
        }
        grad <- g %*% L 
        ave.h <- (-1)*L %*% h %*% L 			       
        grad <- grad[1, estpars & !redun_constr]		
        ave.h <- ave.h[estpars & !redun_constr, estpars & !redun_constr] 
        if(is.na(attr(gtheta0[[1]],"log.lik"))) stop('Estimation halted. Model did not converge.')		
        if(verbose){
            if((cycles + 1) %% 10 == 0){
                if(cycles < BURNIN)
                    cat("Stage 1: Cycle = ", cycles + 1, ", Log-Lik = ", 
                        sprintf("%.1f", LL), sep="")
                if(cycles > BURNIN && cycles < BURNIN + SEMCYCLES)
                    cat("Stage 2: Cycle = ", cycles-BURNIN+1, ", Log-Lik = ",
                        sprintf("%.1f", LL), sep="")
                if(cycles > BURNIN + SEMCYCLES)
                    cat("Stage 3: Cycle = ", cycles-BURNIN-SEMCYCLES+1, 
                        ", Log-Lik = ", sprintf("%.1f",LL), sep="")					
            }
        }			
        if(stagecycle < 3){	
            ave.h <- as(ave.h,'sparseMatrix')
            inv.ave.h <- try(solve(ave.h))			
            if(class(inv.ave.h) == 'try-error'){
                inv.ave.h <- try(qr.solve(ave.h + 2*diag(ncol(ave.h))))
                noninvcount <- noninvcount + 1
                if(noninvcount == 3) 
                    stop('\nEstimation halted during burn in stages, solution is unstable')
            }
            correction <- as.numeric(inv.ave.h %*% grad)
            correction[correction > .5] <- 1
            correction[correction < -.5] <- -1
            longpars[estindex_unique] <- longpars[estindex_unique] + gamma*correction           
            if(length(constrain) > 0)
                for(i in 1:length(constrain))
                    longpars[index %in% constrain[[i]][-1]] <- longpars[constrain[[i]][1]]           
            if(verbose && (cycles + 1) %% 10 == 0){ 
                cat(", Max Change =", sprintf("%.4f", max(abs(gamma*correction))), "\n")
                flush.console()
            }			            
            if(stagecycle == 2){
                SEM.stores[[cycles - BURNIN]] <- longpars
                SEM.stores2[[cycles - BURNIN]] <- ave.h
            }	
            next
        }	 
        
        #Step 3. Update R-M step		
        Tau <- Tau + gamma*(ave.h - Tau)
        Tau <- as(Tau,'sparseMatrix')	
        inv.Tau <- solve(Tau)
        if(class(inv.Tau) == 'try-error'){
            inv.Tau <- try(qr.solve(Tau + 2 * diag(ncol(Tau))))
            noninvcount <- noninvcount + 1
            if(noninvcount == 3) 
                stop('\nEstimation halted during stage 3, solution is unstable')
        }		
        correction <-  as.numeric(inv.Tau %*% grad)
        longpars[estindex_unique] <- longpars[estindex_unique] + gamma*correction           
        if(length(constrain) > 0)
            for(i in 1:length(constrain))
                longpars[index %in% constrain[[i]][-1]] <- longpars[constrain[[i]][1]]
        if(verbose && (cycles + 1) %% 10 == 0){ 
            cat(", gam = ",sprintf("%.3f",gamma),", Max Change = ", 
                sprintf("%.4f",max(abs(gamma*correction))), "\n", sep = '')
            flush.console()		
        }	
        if(all(abs(gamma*correction) < TOL)) conv <- conv + 1
        else conv <- 0		
        if(conv == 3) break        
        
        #Extra: Approximate information matrix.	sqrt(diag(solve(info))) == SE
        if(gamma == .25){
            gamma <- 1	
            phi <- rep(0, length(grad))            
            info <- matrix(0, length(grad), length(grad))
        }
        phi <- phi + gamma*(grad - phi)
        info <- info + gamma*(Tau - phi %*% t(phi) - info)		
    } ###END BIG LOOP       
    #Reload final pars list
    if(list$USEEM) longpars <- list$startlongpars
    ind1 <- 1
    for(g in 1:ngroups){
        for(i in 1:(J+1)){
            ind2 <- ind1 + length(pars[[g]][[i]]@par) - 1
            pars[[g]][[i]]@par <- longpars[ind1:ind2]
            ind1 <- ind2 + 1       
            if(any(class(pars[[g]][[i]]) == c('dich', 'partcomp'))){
                if(pars[[g]][[i]]@par[length(pars[[g]][[i]]@par)] > 1) 
                    pars[[g]][[i]]@par[length(pars[[g]][[i]]@par)] <- 1
                if(pars[[g]][[i]]@par[length(pars[[g]][[i]]@par)-1] < 0) 
                    pars[[g]][[i]]@par[length(pars[[g]][[i]]@par)-1] <- 0
            }
            #apply sum(t) == 1 constraint for mcm
            if(is(pars[[g]][[i]], 'mcm')){
                tmp <- pars[[g]][[i]]@par
                tmp[length(tmp) - pars[[g]][[i]]@ncat + 1] <- 1 - sum(tmp[length(tmp):(length(tmp) - 
                    pars[[g]][[i]]@ncat + 2)])
                pars[[g]][[i]]@par <- tmp
            }
        }        
    }    
    SEtmp <- diag(solve(info))        
    if(any(SEtmp < 0)){
        warning("Information matrix is not positive definite, negative SEs set to 0.\n")
        SEtmp <- rep(0, length(SEtmp))
    } else SEtmp <- sqrt(SEtmp)
    SE <- rep(NA, length(longpars))
    SE[estindex_unique] <- SEtmp
    if(length(constrain) > 0)
        for(i in 1:length(constrain))
            SE[index %in% constrain[[i]][-1]] <- SE[constrain[[i]][1]]
    ind1 <- 1
    for(g in 1:ngroups){
        for(i in 1:(J+1)){
            ind2 <- ind1 + length(pars[[g]][[i]]@par) - 1
            pars[[g]][[i]]@SEpar <- SE[ind1:ind2]
            ind1 <- ind2 + 1            
        }         
    }    
    ret <- list(pars=pars, cycles = cycles - BURNIN - SEMCYCLES, info=as.matrix(info), 
                longpars=longpars, converge=converge)
    ret    
}