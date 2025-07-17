## 강의 실습 조교가 임의로 작성한 코드여서, 교수님 코드와 달라질 수 있습니다.


##### 연습 문제 3####################################
# 1. 패키지 로드 및 데이터 준비
# install.packages(c("ggplot2", "GGally", "mclust")) # 필요시 설치
library(ggplot2)
library(GGally)
library(mclust)

data(iris)
iris_data <- iris[, 1:4]     # 4개의 수치형 변수만 사용
iris_species <- iris$Species # 실제 품종 정보 (결과 비교용)


# 2. 사전 탐색: 변수 간 관계 시각화
# GGally 패키지를 사용해 변수별 분포와 산점도를 한 번에 확인
ggpairs(iris, aes(color = Species, alpha = 0.5), title="Iris Data Exploration")


# 3. 최적 군집 수(k) 결정 (엘보우 방법)
set.seed(123) # 결과 재현을 위한 시드 설정
wss <- (nrow(iris_data)-1)*sum(apply(iris_data,2,var))
for (i in 2:10) {
  wss[i] <- sum(kmeans(iris_data, centers=i, nstart=25)$withinss)
}

# 엘보우 플롯 시각화
plot(1:10, wss, type="b", 
     xlab="Number of Clusters (k)",
     ylab="Total within-cluster sum of squares",
     main="Elbow Method for Optimal k")
abline(v=3, col="red", lty=2) # k=3에서 꺾이는 것을 확인


# 4. 모델링 수행
# --- A. k-평균 군집분석 (k=3) ---
km_iris <- kmeans(iris_data, centers = 3, nstart = 25)
km_clusters <- km_iris$cluster

# --- B. 계층적 군집분석 (다양한 linkage 비교) ---
dist_iris <- dist(iris_data, method = "euclidean")

# 여러 linkage 방법으로 모델 생성
hc_complete <- hclust(dist_iris, method = "complete")
hc_single <- hclust(dist_iris, method = "single")
hc_average <- hclust(dist_iris, method = "average")
hc_ward <- hclust(dist_iris, method = "ward.D2")

# 덴드로그램 시각화 비교
par(mfrow = c(2, 2)) # 2x2 플롯 레이아웃
plot(hc_complete, main = "Complete Linkage", hang = -1, labels = FALSE)
plot(hc_single, main = "Single Linkage", hang = -1, labels = FALSE)
plot(hc_average, main = "Average Linkage", hang = -1, labels = FALSE)
plot(hc_ward, main = "Ward's Method", hang = -1, labels = FALSE)
par(mfrow = c(1, 1)) 

# 각 모델에서 3개 군집으로 자르기
hc_clusters_complete <- as.factor(cutree(hc_complete, k = 3))
hc_clusters_ward <- as.factor(cutree(hc_ward, k = 3)) # Ward 방법이 성능이 좋으므로 대표로 사용

# --- C. 혼합모형 군집분석 ---
mclust_iris <- Mclust(iris_data, G = 3)
mclust_clusters <- as.factor(mclust_iris$classification)

# 혼합모형 시각화 (모델이 찾은 최적의 군집 구조)
plot(mclust_iris, what = "classification", main="Mixture Model Classification")


# 5. 결과 비교
# --- A. 표(Table)로 비교 ---
cat("\n--- K-Means Clustering vs. Actual Species ---\n")
print(table(K_Means = km_clusters, Actual = iris_species))

cat("\n--- Hierarchical (Ward) vs. Actual Species ---\n")
print(table(Hierarchical_Ward = hc_clusters_ward, Actual = iris_species))

cat("\n--- Mixture Model vs. Actual Species ---\n")
print(table(Mixture_Model = mclust_clusters, Actual = iris_species))


# --- B. PCA를 이용한 시각적 비교 ---
# 주성분 분석으로 4차원 -> 2차원으로 차원 축소
pca_result <- prcomp(iris_data, scale. = TRUE)
pca_data <- as.data.frame(pca_result$x[, 1:2])

# 시각화를 위한 데이터 프레임 생성
comparison_df <- data.frame(
  PC1 = pca_data$PC1,
  PC2 = pca_data$PC2,
  Ground_Truth = iris_species,
  K_Means = as.factor(km_clusters),
  Hierarchical_Ward = hc_clusters_ward,
  Mixture_Model = mclust_clusters
)

# ggplot으로 각 군집화 방법의 결과를 시각화하여 비교
ggplot(comparison_df, aes(x = PC1, y = PC2)) +
  geom_point(aes(color = Ground_Truth), alpha = 0.7, size = 3) +
  labs(title = "Ground Truth", color = "Species") +
  theme_minimal()

ggplot(comparison_df, aes(x = PC1, y = PC2)) +
  geom_point(aes(color = K_Means), alpha = 0.7, size = 3) +
  labs(title = "K-Means Clustering Result", color = "Cluster") +
  theme_minimal()

ggplot(comparison_df, aes(x = PC1, y = PC2)) +
  geom_point(aes(color = Hierarchical_Ward), alpha = 0.7, size = 3) +
  labs(title = "Hierarchical Clustering (Ward) Result", color = "Cluster") +
  theme_minimal()

ggplot(comparison_df, aes(x = PC1, y = PC2)) +
  geom_point(aes(color = Mixture_Model), alpha = 0.7, size = 3) +
  labs(title = "Mixture Model Clustering Result", color = "Cluster") +
  theme_minimal()



#### 4 ######################
# 1. 패키지 및 데이터 준비
library(MASS)
library(caret)
library(rpart)
library(randomForest)
data(Boston)

# 2. 타겟 변수 생성 (medv > 25)
Boston$medv_cat <- as.factor(ifelse(Boston$medv > 25, "Over25", "Under25"))
# 원본 medv 변수 제거
boston_class_data <- Boston[, !(names(Boston) %in% "medv")]

# 3. 데이터 분할 (훈련 데이터 70%, 테스트 데이터 30%)
set.seed(123)
train_index <- createDataPartition(boston_class_data$medv_cat, p = 0.7, list = FALSE)
train_data <- boston_class_data[train_index, ]
test_data  <- boston_class_data[-train_index, ]

# 4. 모델링
# A. 로지스틱 회귀분석
logit_model <- glm(medv_cat ~ ., data = train_data, family = "binomial")

# B. 의사결정나무
tree_model <- rpart(medv_cat ~ ., data = train_data, method = "class")

# C. 랜덤포레스트
rf_model <- randomForest(medv_cat ~ ., data = train_data, ntree = 100)

# 5. 예측 및 평가
# A. 로지스틱 회귀분석 예측 및 평가
logit_probs <- predict(logit_model, newdata = test_data, type = "response")
logit_preds <- as.factor(ifelse(logit_probs > 0.5, "Over25", "Under25"))
cat("--- Logistic Regression Performance ---\n")
print(confusionMatrix(logit_preds, test_data$medv_cat, positive="Over25"))

# B. 의사결정나무 예측 및 평가
tree_preds <- predict(tree_model, newdata = test_data, type = "class")
cat("\n--- Decision Tree Performance ---\n")
print(confusionMatrix(tree_preds, test_data$medv_cat, positive="Over25"))

# C. 랜덤포레스트 예측 및 평가
rf_preds <- predict(rf_model, newdata = test_data)
cat("\n--- Random Forest Performance ---\n")
print(confusionMatrix(rf_preds, test_data$medv_cat, positive="Over25"))

