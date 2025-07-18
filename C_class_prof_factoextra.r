######## 교수님이 공유해주라고 하신 코드 #######    

library(factoextra)
p1 <- fviz_nbclust(xdata, kmeans, 
                   method = "silhouette") + 
  labs(title = "Silhouette Method (K-means)")
p2 <- fviz_nbclust(xdata, kmeans, method = "wss") + 
  labs(title = "WSS (Elbow) Method (K-means)")
library(cluster)
gap_stat <- clusGap(xdata, FUN = kmeans, 
                    K.max = 10, B = 100)
p3 <- fviz_gap_stat(gap_stat) + 
  labs(title = "Gap Statistic (K-means)")

library(patchwork)
(p1 + p2 + p3) + 
  plot_annotation(title = "Optimal Number of Clusters: K-means",
                  theme = theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5)))

