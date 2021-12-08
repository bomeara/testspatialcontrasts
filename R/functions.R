SimOneRep <- function(phy, covariance=0.05, variance=0.1, nchar=4, mean_points_per_cluster=20) {
	trait <- matrix(NA, 1,1)
	while(is.na(trait[1,1])) {
		try({
		s <- matrix(rexp(nchar^2, 1/covariance), nchar, nchar)
		s[lower.tri(s)] <- s[upper.tri(s)]
		diag(s) <- rexp(nchar, 1/variance)
		trait <- geiger::sim.char(phy, s, 1)[,,1]
		}, silent=TRUE) #to handle sims that aren't positive definite
	}
	colnames(trait) <- c("lon", "lat", "focal_trait", paste0("other_", sequence(nchar-3)))
	trait_final <- cbind(data.frame(taxon=rownames(trait)), trait)
	trait_final$lon <- scales::rescale(trait_final$lon, c(-180, 180))
	trait_final$lat <- scales::rescale(trait_final$lat, c(-90, 90))
	clusters <- spatialcontrast::cluster_latlon(trait_final, mean_points_per_cluster=mean_points_per_cluster)	

	return(list(trait=clusters, s=s))
}

TestOneRep <- function(simrep, phy) {
	clusters_compared <- spatialcontrast::compare_clusters(phy, latlon=simrep$trait, tiprates=simrep$trait, rates="focal_trait")
	return(clusters_compared)
}

SimTree <- function(ntip=1000) {
	return(geiger::drop.extinct(geiger::sim.bdtree(b=1, d=0.9, stop="taxa", n=ntip, extinct=FALSE)))
}

PlotResult <- function(runrep_summary, simrep) {
	pdf(file=paste0("~/Downloads/cluster_test_biomes.pdf"))
	for(individual_cluster in sequence(length(unique(simrep$trait$cluster)))) {
		plot_map(latlon=simrep$trait, summaries=runrep_summary, focal_rate="focal_trait", focal_cluster=individual_cluster)
	}
	dev.off()	
}

