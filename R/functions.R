SimOneRep <- function(phy, covariance=0.05, variance=0.1, nchar=4) {
	trait <- matrix(NA, 1,1)
	while(is.na(trait[1,1])) {
		try({
		s <- matrix(rexp(nchar^2, 1/covariance), nchar, nchar)
		s[lower.tri(s)] <- s[upper.tri(s)]
		diag(s) <- rexp(nchar, 1/variance)
		trait <- geiger::sim.char(phy, s, 1)[,,1]
		}, silent=TRUE) #to handle sims that aren't positive definite
	}
	return(list(trait=trait, s=s))
}


