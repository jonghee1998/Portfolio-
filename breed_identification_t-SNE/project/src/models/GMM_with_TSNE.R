rm(list =ls())
library(data.table)
library(caret)
library(ClusterR)
library(Rtsne) 

breed <- fread("./project/volume/data/raw/data.csv")

# Save id and remove it for PCA
ID <- breed$id
breed$id <- NULL

pca <- prcomp(breed)
pca_dt <- data.table(unclass(pca)$x)


# Create tsne data table
tsne_dat <- Rtsne(pca_dt, 
                  pca = T, 
                  perplexity = 150,
                  check_duplicates = F)


tsne_data_table <- data.table(tsne_dat$Y)

# Since we have three levels of factor, optimal cluster is 3
opt_num_clus <- 3

gmm_data <- GMM(tsne_data_table[,.(V1,V2)],opt_num_clus)

clusterInfo <- predict_GMM(tsne_data_table[,.(V1,V2)],
                            gmm_data$centroids,
                            gmm_data$covariance_matrices,
                            gmm_data$weights)

# clusterInfo contains a lot of information which we can extract
clusterInfo$log_likelihood
clusterInfo$cluster_proba
clusterInfo$cluster_labels

tmp <- data.table(clusterInfo$cluster_labels)
tmp$id <- ID
tmp$Breed1 <- ifelse(tmp$V1 == '1',1,0)
tmp$Breed3 <- ifelse(tmp$V1 == '2',1,0)
tmp$Breed2 <- ifelse(tmp$V1 == '3',1,0)

submit <- tmp[,-1]
submit <- submit[,c(1,2,4,3)]
fwrite(submit,"./project/volume/data/processed/submit_with_TSNE.csv")

# t-SNE Visualization with Clusters
plot(tsne_dat$Y, col = as.numeric(clusterInfo$cluster_labels), 
     pch = 19, main = "t-SNE Visualization with Clusters")
legend("topright", legend = unique(clusterInfo$cluster_labels), col = unique(clusterInfo$cluster_labels), pch = 19)


