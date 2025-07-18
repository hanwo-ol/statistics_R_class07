
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
*   **그래프 해석**: 생성된 그래프는 3개의 군집이 서로 다른 색과 모양으로 명확하게 구분되어 있음을 보여줍니다. 각 군집을 감싸는 타원은 해당 군집의 확률적 분포(평균, 공분산 구조)를 시각적으로 나타냅니다. 이 결과를 다른 군집분석 방법의 시각화 결과와 비교하여 어떤 방법이 `iris` 데이터의 구조를 가장 잘 표현하는지 평가할 수 있습니다.
