
### 분석의 목표: 3가지 대표 군집분석 방법 비교 및 적용

이 연습 문제의 목표는 실제 데이터셋인 `iris`에 **k-평균 군집분석, 계층적 군집분석, 모형-기반 군집분석**이라는 3가지 대표적인 군집분석 방법을 모두 적용하고, 그 결과를 비교하며 각 방법론의 특징과 장단점을 이해하는 것입니다.

---

### 1. 패키지 로드 및 데이터 준비

#### 코드
```R
library(ggplot2)
library(GGally)
library(mclust)
data(iris)
str(iris)
iris_data <- iris[, 1:4]
iris_species <- iris$Species
```
#### 결과 + 설명
*   **코드 설명**:
    *   `library(...)`: 분석에 필요한 `ggplot2`, `GGally`, `mclust` 패키지를 불러옵니다.
    *   `data(iris)`: R에 내장된 `iris` 데이터를 불러옵니다.
    *   `str(iris)`: `iris` 데이터의 구조를 확인합니다.
    *   `iris_data <- iris[, 1:4]`: `iris` 데이터에서 군집분석에 사용할 4개의 수치형 변수(꽃받침/꽃잎의 길이/너비)만 선택하여 `iris_data`에 저장합니다.
    *   `iris_species <- iris$Species`: 실제 품종 정보(`Species`)를 `iris_species`에 따로 저장합니다. 이는 나중에 군집분석 결과가 실제 품종을 얼마나 잘 맞췄는지 비교(평가)하는 데 사용됩니다.
*   **`str(iris)` 출력 결과**:
    ```
    'data.frame':	150 obs. of  5 variables:
     $ Sepal.Length: num  5.1 4.9 ...
     $ Sepal.Width : num  3.5 3.0 ...
     $ Petal.Length: num  1.4 1.4 ...
     $ Petal.Width : num  0.2 0.2 ...
     $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 ...
    ```
    *   **결과 해석**: `iris` 데이터는 150개의 관측치(obs.)와 5개의 변수(variables)로 구성되어 있습니다. 4개의 숫자형(num) 변수와 1개의 3개 수준(levels)을 가진 범주형(Factor) 변수 `Species`가 있음을 확인할 수 있습니다.

---

### 2. 사전 탐색: 변수 간 관계 시각화

#### 코드
```R
ggpairs(iris, aes(color = Species, alpha = 0.5), title="Iris Data Exploration")
```
#### 결과 + 설명
*   **코드 설명**: `GGally` 패키지의 `ggpairs()` 함수는 여러 변수 간의 관계를 한 번에 보여주는 강력한 시각화 도구입니다.
    *   대각선: 각 변수의 분포를 품종(`Species`)별로 색을 다르게 하여 밀도 그래프로 보여줍니다.
    *   대각선 아래: 두 변수 간의 관계를 품종별로 색을 다르게 하여 산점도로 보여줍니다.
    *   대각선 위: 두 변수 간의 상관계수를 품종별로 보여줍니다.
*   **그래프 해석**: 이 그래프를 통해 `setosa` 품종(빨간색)은 다른 두 품종과 명확하게 구분되는 반면, `versicolor`(초록색)와 `virginica`(파란색)는 일부 변수에서 서로 겹치는 영역이 있음을 시각적으로 파악할 수 있습니다. 이는 군집분석 시 `setosa`는 쉽게 분류되겠지만, 나머지 두 품종은 분류가 다소 어려울 수 있음을 예측하게 합니다.

---

### 3. 최적 군집 수(k) 결정 (엘보우 방법)

#### 코드
```R
set.seed(123)
wss <- (nrow(iris_data)-1)*sum(apply(iris_data,2,var))
for (i in 2:10) {
  wss[i] <- sum(kmeans(iris_data, centers=i, nstart=25)$withinss)
}
wss
plot(1:10, wss, type="b", ...)
abline(v=3, col="red", lty=2)
```
#### 결과 + 설명
*   **코드 설명**: k-평균 군집분석에 가장 적합한 군집 수(k)를 찾기 위해 엘보우 방법을 사용합니다. k를 1부터 10까지 변화시키면서 각 k에 대한 **군집 내 총 제곱합(Total within-cluster sum of squares, WSS)**을 계산합니다. WSS는 군집 내 데이터들이 얼마나 잘 뭉쳐있는지를 나타내는 지표로, 작을수록 좋습니다.
*   **`wss` 출력 결과**:
    ```
     [1] 681.37... 152.34...  78.85...  57.22...  ...
    ```
    *   **결과 해석**: k가 1일 때 WSS는 681.37, 2일 때 152.34, 3일 때 78.85로 급격히 감소하는 것을 볼 수 있습니다.
*   **`plot` 그래프 해석**: 생성된 꺾은선 그래프에서 WSS 값이 급격히 감소하다가 완만해지는 "팔꿈치(elbow)" 지점을 찾습니다. `iris` 데이터에서는 **k=3** 지점에서 기울기가 눈에 띄게 꺾이는 것을 명확히 확인할 수 있습니다. `abline()` 함수로 k=3 위치에 빨간 점선을 그어 이를 시각적으로 강조했습니다. 따라서 최적의 군집 수는 3개라고 판단할 수 있습니다.

---

### 4. 모델링 수행

#### A. k-평균 군집분석 (k=3)

#### 코드
```R
km_iris <- kmeans(iris_data, centers = 3, nstart = 25)
km_clusters <- km_iris$cluster
km_clusters
```
#### 결과 + 설명
*   **코드 설명**: 엘보우 방법으로 찾은 최적의 k=3을 적용하여 k-평균 군집분석을 수행합니다. `nstart=25` 옵션을 주어 안정적인 결과를 얻도록 합니다. `$cluster`를 통해 각 데이터가 몇 번 군집에 할당되었는지 확인합니다.
*   **`km_clusters` 출력 결과**:
    ```
      [1] 1 1 1 ... 2 2 3 2 2 2 ... 3 2 3 3 3 3 ...
    ```
    *   **결과 해석**: 150개의 `iris` 데이터 각각에 대해 1, 2, 3번 중 어떤 군집으로 분류되었는지를 보여주는 벡터입니다. 예를 들어 첫 번째 데이터는 1번 군집, 51번째 데이터는 2번 군집, 101번째 데이터는 3번 군집으로 분류되었습니다.

#### B. 계층적 군집분석 (다양한 linkage 비교)

#### 코드
```R
dist_iris <- dist(iris_data, method = "euclidean")
hc_complete <- hclust(dist_iris, method = "complete")
hc_ward <- hclust(dist_iris, method = "ward.D2")
par(mfrow = c(2, 2))
plot(hc_complete, ...)
hc_clusters_ward <- as.factor(cutree(hc_ward, k = 3))
hc_clusters_ward
```
#### 결과 + 설명
*   **코드 설명**:
    *   `dist()`: 150개 데이터 간의 유클리드 거리를 계산하여 거리 행렬을 만듭니다.
    *   `hclust()`: 생성된 거리 행렬을 기반으로 여러 연결법(`complete`, `single`, `average`, `ward.D2`)을 사용하여 계층적 군집분석을 수행합니다. **Ward's method (`ward.D2`)**는 군집 내 분산을 최소화하는 방향으로 군집을 병합하여, 크기가 비슷한 구형의 군집을 만드는 데 효과적인 방법으로 알려져 있습니다.
    *   `plot()`: 각 연결법으로 생성된 덴드로그램을 2x2 그리드에 시각화하여 비교합니다.
    *   `cutree(hc_ward, k = 3)`: 여러 덴드로그램 중 Ward's method로 생성된 덴드로그램(`hc_ward`)을 k=3, 즉 3개의 군집으로 자릅니다.
*   **`hc_clusters_ward` 출력 결과**:
    ```
      [1] 1 1 1 ... 2 2 2 ... 3 2 3 3 3 3 ...
      Levels: 1 2 3
    ```
    *   **결과 해석**: k-평균 군집분석과 마찬가지로, 150개 데이터 각각이 Ward's method에 의해 1, 2, 3번 중 어떤 군집으로 분류되었는지를 보여주는 벡터입니다. 이 결과는 `km_clusters`의 결과와 비교하여 두 방법의 유사성 및 차이점을 파악하는 데 사용될 수 있습니다.

#### C. 혼합모형 군집분석

#### 코드
```R
mclust_iris <- Mclust(iris_data, G = 3)
mclust_clusters <- as.factor(mclust_iris$classification)
plot(mclust_iris, what = "classification", main="Mixture Model Classification")
```
#### 결과 + 설명
*   **코드 설명**:
    *   `Mclust(iris_data, G = 3)`: `iris` 데이터를 3개의 군집(`G=3`)으로 나누는 모형-기반 군집분석을 수행합니다. `Mclust`는 내부적으로 다양한 공분산 구조 모델을 테스트하고, BIC(베이즈 정보 기준)를 기반으로 데이터에 가장 적합한 모델을 자동으로 선택합니다.
    *   `mclust_iris$classification`: `Mclust`가 최종적으로 각 데이터를 몇 번 군집으로 분류했는지에 대한 정보를 담고 있습니다.
    *   `plot(mclust_iris, what = "classification")`: `Mclust`의 분류 결과를 시각화합니다. 이 플롯은 데이터를 2차원으로 축소(주성분분석 등 이용)하여 산점도를 그리고, 각 점을 분류된 군집에 따라 다른 색과 모양으로 표시하며, 각 군집의 확률적 경계(타원)를 함께 보여줍니다.

---

파트 2
---

### 분석의 목표: 어떤 군집분석 방법이 가장 뛰어난가?

이 단계의 목표는 **정답(`iris_species`)**과 3가지 군집분석 방법의 결과를 비교하여, **어떤 방법이 `iris` 데이터의 실제 품종 구조를 가장 잘 찾아냈는지**를 객관적으로 평가하고 시각적으로 확인하는 것입니다.

---

### 5. 결과 비교

#### A. 표(Table)로 비교

##### 코드
```R
cat("\n--- K-Means Clustering vs. Actual Species ---\n")
print(table(K_Means = km_clusters, Actual = iris_species))

cat("\n--- Hierarchical (Ward) vs. Actual Species ---\n")
print(table(Hierarchical_Ward = hc_clusters_ward, Actual = iris_species))

cat("\n--- Mixture Model vs. Actual Species ---\n")
print(table(Mixture_Model = mclust_clusters, Actual = iris_species))
```
##### 결과 + 설명
*   **코드 설명**: `table()` 함수는 두 범주형 변수 간의 **분할표(contingency table) 또는 교차표(cross-tabulation)**를 생성합니다. 여기서는 각 군집분석 방법의 분류 결과(행)와 실제 품종 정보(열)를 교차하여, 어떤 품종이 어떤 군집으로 분류되었는지를 한눈에 보여줍니다.
*   **`K-Means` vs. `Actual` 결과**:
    ```
           Actual
    K_Means setosa versicolor virginica
          1     50          0         0  <-- (1)
          2      0         48        14  <-- (2)
          3      0          2        36  <-- (3)
    ```
    *   **(1) 완벽한 분류**: K-평균 군집분석의 1번 군집은 실제 `setosa` 품종 50개를 완벽하게 모두 찾아냈습니다.
    *   **(2) 일부 오분류**: 2번 군집은 `versicolor` 48개와 `virginica` 14개를 포함하고 있습니다.
    *   **(3) 일부 오분류**: 3번 군집은 `versicolor` 2개와 `virginica` 36개를 포함하고 있습니다.
    *   **해석**: `setosa`는 완벽히 구분했지만, `versicolor`와 `virginica`는 총 16개(14+2)가 잘못 분류되었습니다.

*   **`Hierarchical (Ward)` vs. `Actual` 결과**:
    ```
                     Actual
    Hierarchical_Ward setosa versicolor virginica
                    1     50          0         0  <-- (1)
                    2      0         49        15  <-- (2)
                    3      0          1        35  <-- (3)
    ```
    *   **해석**: `setosa`는 완벽히 구분했고, `versicolor`와 `virginica`는 총 16개(15+1)가 잘못 분류되었습니다. K-평균 군집분석과 거의 유사한 성능을 보입니다.

*   **`Mixture Model` vs. `Actual` 결과**:
    ```
                 Actual
    Mixture_Model setosa versicolor virginica
                1     50          0         0  <-- (1)
                2      0         45         0  <-- (2)
                3      0          5        50  <-- (3)
    ```
    *   **(1) 완벽한 분류**: 혼합모형 군집분석의 1번 군집 역시 `setosa` 50개를 완벽하게 찾아냈습니다.
    *   **(2) 향상된 분류**: 2번 군집은 `versicolor` 45개만 포함하고 있습니다.
    *   **(3) 거의 완벽한 분류**: 3번 군집은 `versicolor` 5개와 `virginica` 50개를 포함하고 있습니다.
    *   **해석**: `versicolor` 5개만 잘못 분류되었을 뿐, 나머지 145개는 모두 정확하게 분류했습니다. 세 가지 방법 중 **가장 뛰어난 성능**을 보여줍니다.

---

#### B. PCA를 이용한 시각적 비교

##### 코드
```R
pca_result <- prcomp(iris_data, scale. = TRUE)
pca_data <- as.data.frame(pca_result$x[, 1:2])

comparison_df <- data.frame(...)

g1 <- ggplot(comparison_df, aes(x = PC1, y = PC2)) + ...
g2 <- ...
g3 <- ...
g4 <- ...
g1 + g2 + g3 + g4
```
##### 결과 + 설명
*   **코드 설명**:
    *   `prcomp(..., scale. = TRUE)`: 4개의 변수(4차원)를 가진 `iris_data`를 **주성분 분석(PCA)**하여 2개의 주성분(2차원)으로 **차원 축소**합니다. `scale. = TRUE`는 변수들의 스케일을 표준화하는 중요한 옵션입니다.
    *   `as.data.frame(pca_result$x[, 1:2])`: PCA 결과에서 첫 번째(PC1)와 두 번째(PC2) 주성분 점수만 추출하여 데이터프레임으로 만듭니다.
    *   `comparison_df <- data.frame(...)`: 시각화를 위해 PCA 결과와 실제 품종 정보, 그리고 3가지 군집분석 결과를 하나의 데이터프레임으로 통합합니다.
    *   `ggplot(...)`: `ggplot2`를 이용해 4개의 산점도를 그립니다. 모든 그래프의 x, y축은 PC1, PC2로 동일하며, 각 점의 색상만 다르게 지정합니다.
        *   `g1`: 실제 품종(`Ground_Truth`)에 따라 색상 지정
        *   `g2`: K-평균 군집 결과(`K_Means`)에 따라 색상 지정
        *   `g3`: 계층적 군집 결과(`Hierarchical_Ward`)에 따라 색상 지정
        *   `g4`: 혼합모형 군집 결과(`Mixture_Model`)에 따라 색상 지정
    *   `g1 + g2 + g3 + g4`: `patchwork` 패키지의 기능으로 4개의 그래프를 나란히 배열하여 비교합니다.
*   **그래프 해석**: 4개의 그래프를 나란히 비교함으로써, 각 군집분석 방법이 실제 품종(Ground Truth)의 분포를 얼마나 유사하게 재현했는지 시각적으로 한눈에 파악할 수 있습니다. 앞서 표에서 확인했듯이, K-평균과 계층적 군집분석은 `versicolor`와 `virginica`의 경계에서 오분류가 꽤 있는 반면, 혼합모형 군집분석은 실제 품종 분포와 거의 유사한 패턴을 보여줌을 확인할 수 있습니다.

<img width="2561" height="1494" alt="image" src="https://github.com/user-attachments/assets/1096d444-4202-4a35-9d91-1d5c9af050cb" />



---

#### C. 통계 지표를 이용한 정량적 평가

##### 코드
```R
library(fpc)
# K-means 평가
cluster.stats(d = dist(iris_data), as.numeric(iris_species), km_clusters)$corrected.rand
# Hierarchical (Ward)
cluster.stats(d = dist(iris_data), as.numeric(iris_species), as.numeric(hc_clusters_ward))$corrected.rand
# Model-based (Mclust)
cluster.stats(d = dist(iris_data), as.numeric(iris_species), as.numeric(mclust_clusters))$corrected.rand
```
##### 결과 + 설명
*   **코드 설명**: `fpc` 패키지의 `cluster.stats()` 함수는 군집분석 결과를 평가하는 다양한 통계 지표를 제공합니다. 여기서는 그 중 **Adjusted Rand Index(수정된 랜드 지수)**를 사용합니다.
    *   **Adjusted Rand Index**: 두 개의 군집화 결과(여기서는 '정답'과 '분석 결과')가 얼마나 유사한지를 측정하는 지표입니다.
        *   **1**: 두 군집화 결과가 완벽하게 일치함.
        *   **0**: 두 군집화 결과가 무작위(랜덤) 수준으로 일치함 (관련성 없음).
        *   **음수값**: 무작위 수준보다도 일치하지 않음.
*   **결과**:
    *   K-means: `0.7302383`
    *   Hierarchical (Ward): `0.7311986`
    *   Model-based (Mclust): `0.9038742`
*   **결과 해석**:
    *   K-평균과 계층적 군집분석은 약 0.73의 Adjusted Rand Index 값을 보여, 정답과 꽤 높은 유사성을 보입니다.
    *   **혼합모형 군집분석은 0.904라는 매우 높은 값**을 보여, 정답과 거의 일치하는 수준의 군집화 결과를 만들어냈음을 객관적인 수치로 증명합니다.
    *   이는 앞서 분할표와 시각화로 확인했던 **"혼합모형이 가장 뛰어난 성능을 보였다"**는 결론을 통계적으로 강력하게 뒷받침합니다.

### 최종 종합 결론

`iris` 데이터에 대한 세 가지 군집분석 방법을 비교한 결과, **모형-기반 군집분석(혼합모형)**이 K-평균이나 계층적 군집분석에 비해 월등히 뛰어난 성능을 보였습니다. 이는 분할표 비교, PCA를 이용한 시각적 비교, 그리고 Adjusted Rand Index라는 정량적 평가 지표를 통해 일관되게 확인되었습니다. 이는 `iris` 데이터의 각 품종이 서로 다른 평균과 공분산 구조를 가진 정규분포를 따를 것이라는 모형-기반 군집분석의 가정이 데이터의 실제 특성과 가장 잘 부합했기 때문으로 해석할 수 있습니다.
