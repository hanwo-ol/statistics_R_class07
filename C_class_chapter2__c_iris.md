### 분석의 목표: 실제 데이터에 계층적 군집분석 적용 및 결과 해석

이번 분석의 목표는 다음과 같습니다.
1.  실제 데이터셋인 `iris` 데이터를 사용하여 계층적 군집분석을 수행합니다.
2.  분석 결과를 덴드로그램으로 시각화하고, 원하는 개수의 군집으로 자르는 방법을 익힙니다.
3.  잘라낸 군집 결과를 원래 데이터와 비교하고 시각화하여 군집의 특성을 파악합니다.

---

### 단계별 코드 및 결과 상세 해설

#### 1. 데이터 준비 및 계층적 군집분석 수행

```R
> data("iris");
> str(iris)
> xdata = iris[, c(2,4)]  # clustering with 2 variables
> # 계층적 군집 분석 수행 (complete linkage)
> hc.res = hclust(dist(xdata), method = "complete")
> hc.res  # 결과 확인
```

##### **함수 기능 설명**

*   `xdata = iris[, c(2,4)]`: `iris` 데이터에서 2번째 열(`Sepal.Width`)과 4번째 열(`Petal.Width`)만 선택하여 분석용 데이터 `xdata`를 생성합니다.
*   `dist(xdata)`: `xdata`에 포함된 150개 데이터 포인트 간의 **유클리드 거리(Euclidean distance)**를 계산하여 거리 행렬(`dist` 객체)을 생성합니다.
*   `hclust(..., method = "complete")`: 생성된 거리 행렬을 기반으로 **완전 연결법(complete linkage)**을 사용하여 계층적 군집분석을 수행합니다. 그 결과를 `hc.res` 객체에 저장합니다.
*   **`hc.res` 출력 결과**:
    *   `Cluster method`: 사용된 연결법이 `complete`임을 보여줍니다.
    *   `Distance`: 거리 계산 방법이 `euclidean`이었음을 알려줍니다.
    *   `Number of objects`: 분석된 객체의 수가 150개임을 나타냅니다.

#### 2. 덴드로그램 시각화

```R
> # 덴드로그램 그리기
> par(mfrow = c(1,2))
> plot(hc.res, labels = FALSE)
> plot(hc.res, labels = FALSE, hang=-1)
> fviz_dend(hc.res, show_labels = FALSE, main = "Complete Linkage")
```

##### **함수 기능 설명**

*   `par(mfrow = c(1,2))`: 그래픽 창을 1행 2열로 분할하여 두 개의 그래프를 나란히 그립니다.
*   `plot(hc.res, labels = FALSE)`: `hclust` 객체(`hc.res`)를 이용해 덴드로그램을 그립니다. `labels = FALSE` 옵션은 데이터가 150개로 너무 많아 지저분해 보일 수 있는 하단의 객체 라벨을 생략합니다.
*   `plot(hc.res, labels = FALSE, hang=-1)`: `hang = -1` 옵션은 모든 객체 라벨(잎, leaf)이 그래프의 맨 아래(y=0)에 정렬되도록 하여 덴드로그램의 높이 구조를 더 명확하게 보여줍니다.
*   `factoextra::fviz_dend(...)`: `factoextra` 패키지를 이용해 더 미려한 덴드로그램을 그립니다. `show_labels = FALSE`는 `plot` 함수의 `labels=FALSE`와 같은 역할을 합니다.

#### 3. 덴드로그램 자르기 (군집 할당)

```R
> # 2~3개 클러스터로 cut
> ct = cutree(hc.res, k = 2:3)  # 2 to 3 clusters
> head(ct)
```

##### **함수 기능 설명**

*   `cutree(hc.res, k = ...)`: `hclust`로 생성된 덴드로그램을 특정 개수의 군집으로 **자르는(cut)** 역할을 하는 매우 중요한 함수입니다.
    *   `hc.res`: 자를 대상이 되는 덴드로그램(`hclust` 객체)입니다.
    *   `k = 2:3`: **k(군집의 개수)가 2일 때와 3일 때**의 두 가지 경우에 대해 각각 덴드로그램을 잘라달라는 의미입니다.
*   **`head(ct)` 출력 결과**:
    *   `cutree` 함수의 결과로 `ct`라는 행렬이 생성되었습니다.
    *   첫 번째 열(`2`)은 **k=2로 잘랐을 때** 각 데이터(1번부터 6번까지)가 몇 번 군집에 속하는지를 보여줍니다. (모두 1번 군집)
    *   두 번째 열(`3`)은 **k=3으로 잘랐을 때** 각 데이터가 몇 번 군집에 속하는지를 보여줍니다. (모두 1번 군집)

#### 4. 군집화 결과 요약 및 시각화

```R
> # 클러스터 결과 요약
> table(k2 = ct[, "2"], k3 = ct[, "3"])
> # 2개와 3개 클러스터 시각화
> par(mfrow = c(1, 2))
> plot(xdata, pch = 20, cex = 2, col = ct[, "2"], ...)
> plot(xdata, pch = 20, cex = 2, col = ct[, "3"], ...)
```

##### **함수 기능 설명**

*   `table(k2 = ct[, "2"], k3 = ct[, "3"])`: `cutree`로 얻은 두 가지 군집화 결과(`k=2`일 때와 `k=3`일 때)를 비교하는 **분할표(contingency table)**를 생성합니다.
    *   `ct[, "2"]`: k=2일 때의 군집 할당 결과 벡터입니다.
    *   `ct[, "3"]`: k=3일 때의 군집 할당 결과 벡터입니다.
*   **`table` 출력 결과**:
    *   k=2일 때 1번 군집이었던 112개의 데이터는, k=3으로 나누자 49개(1번 군집)와 63개(2번 군집)로 나뉘었음을 보여줍니다.
    *   k=2일 때 2번 군집이었던 38개의 데이터는, k=3일 때도 변함없이 3번 군집으로 유지되었음을 보여줍니다.
*   `plot(..., col = ct[, "2"])`: 산점도를 그리되, 각 점의 색상(`col`)을 k=2일 때의 군집 번호에 따라 다르게 지정하여 시각화합니다.
*   `plot(..., col = ct[, "3"])`: 각 점의 색상을 k=3일 때의 군집 번호에 따라 다르게 지정하여 시각화합니다.

#### 5. `factoextra`를 이용한 고급 시각화

```R
> p1 = fviz_cluster(list(data = xdata, cluster = ct[,1]), ...)
> p2 = fviz_cluster(list(data = xdata, cluster = ct[,2]), ...)
> p1+p2
> d1 = fviz_dend(hc.res, k = 2, ...)
> d2 = fviz_dend(hc.res, k = 3, ...)
> d1+d2
```

##### p1 + p2

<img width="2561" height="1494" alt="image" src="https://github.com/user-attachments/assets/c08257cd-80c2-4e65-8e34-f17ede05f58b" />

##### d1 + d2

<img width="2561" height="1494" alt="image" src="https://github.com/user-attachments/assets/b7ea9d11-1c46-4f19-9d07-4fb61d6715df" />


##### **함수 기능 설명**
*   `factoextra::fviz_cluster()`: 군집화 결과를 산점도 위에 시각적으로 표현해주는 함수입니다. 자동으로 각 군집을 타원으로 감싸주는 등 고급 시각화 기능을 제공합니다.
    *   `list(data = xdata, cluster = ct[,1])`: 분석에 사용된 원본 데이터(`xdata`)와 군집 할당 결과(`ct[,1]`)를 리스트 형태로 묶어서 전달합니다. `ct[,1]`은 k=2일 때의 결과입니다.
    *   `repel = TRUE`: 점들의 라벨이 겹치지 않도록 서로 밀어내는 효과를 줍니다. (이 예제에서는 라벨이 없으므로 큰 의미는 없습니다.)
    *   `ggtheme = theme_minimal()`: 그래프의 전반적인 테마(배경, 격자 등)를 `ggplot2`의 `theme_minimal` 스타일로 지정합니다.
*   `fviz_dend(hc.res, k = 2, ...)`: 앞서 설명한 덴드로그램 시각화 함수입니다.
    *   `k = 2`: 덴드로그램을 2개의 군집으로 자른 결과를 시각화합니다.
    *   `rect = TRUE`: 2개로 나뉜 군집의 영역을 사각형으로 표시합니다.
    *   `k_colors = "jco"`: 군집의 색상을 "Journal of Clinical Oncology" 학술지 스타일의 색상 팔레트로 지정합니다.
    *   `k_colors = "lancet"`: "The Lancet" 학술지 스타일의 색상 팔레트를 사용합니다.
*   `p1+p2`, `d1+d2`: `patchwork` 패키지의 기능을 이용하여 `ggplot2` 기반의 그래프 객체들을 나란히 조합하여 하나의 그림으로 출력합니다.
