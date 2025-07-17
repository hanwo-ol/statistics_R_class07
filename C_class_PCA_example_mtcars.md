~~예시는 국력이다.~~

## 스크리 플롯 그리기(최적의 주성분 개수는?)
<details> <summary> 펼치기 </summary> 
  
``` R
# 1. 데이터 준비
# R 내장 mtcars 데이터셋을 로드하고 구조를 확인합니다.
data(mtcars)
head(mtcars)
```

실행결과 

``` R
> head(mtcars)
                   mpg cyl disp  hp drat    wt  qsec vs am gear carb
Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

---

``` R
# mtcars의 모든 변수는 수치형이므로 그대로 사용합니다.
# 각 변수는 측정 단위(scale)가 다르므로 표준화 과정이 필수적입니다.


# 2. 주성분분석(PCA) 수행
# prcomp 함수를 사용하고, scale. = TRUE 옵션으로 데이터를 표준화합니다.
pca_mtcars <- prcomp(mtcars, scale. = TRUE)
pca_mtcars
```

실행결과
``` R
> pca_mtcars
Standard deviations (1, .., p=11):
 [1] 2.5706809 1.6280258 0.7919579 0.5192277 0.4727061 0.4599958 0.3677798
 [8] 0.3505730 0.2775728 0.2281128 0.1484736

Rotation (n x k) = (11 x 11):
            PC1         PC2         PC3          PC4         PC5         PC6
mpg  -0.3625305  0.01612440 -0.22574419 -0.022540255 -0.10284468 -0.10879743
cyl   0.3739160  0.04374371 -0.17531118 -0.002591838 -0.05848381  0.16855369
disp  0.3681852 -0.04932413 -0.06148414  0.256607885 -0.39399530 -0.33616451
hp    0.3300569  0.24878402  0.14001476 -0.067676157 -0.54004744  0.07143563
drat -0.2941514  0.27469408  0.16118879  0.854828743 -0.07732727  0.24449705
wt    0.3461033 -0.14303825  0.34181851  0.245899314  0.07502912 -0.46493964
qsec -0.2004563 -0.46337482  0.40316904  0.068076532  0.16466591 -0.33048032
vs   -0.3065113 -0.23164699  0.42881517 -0.214848616 -0.59953955  0.19401702
am   -0.2349429  0.42941765 -0.20576657 -0.030462908 -0.08978128 -0.57081745
gear -0.2069162  0.46234863  0.28977993 -0.264690521 -0.04832960 -0.24356284
carb  0.2140177  0.41357106  0.52854459 -0.126789179  0.36131875  0.18352168
              PC7          PC8          PC9        PC10         PC11
mpg   0.367723810  0.754091423 -0.235701617 -0.13928524 -0.124895628
cyl   0.057277736  0.230824925 -0.054035270  0.84641949 -0.140695441
disp  0.214303077 -0.001142134 -0.198427848 -0.04937979  0.660606481
hp   -0.001495989  0.222358441  0.575830072 -0.24782351 -0.256492062
drat  0.021119857 -0.032193501  0.046901228  0.10149369 -0.039530246
wt   -0.020668302  0.008571929 -0.359498251 -0.09439426 -0.567448697
qsec  0.050010522  0.231840021  0.528377185  0.27067295  0.181361780
vs   -0.265780836 -0.025935128 -0.358582624  0.15903909  0.008414634
am   -0.587305101  0.059746952  0.047403982  0.17778541  0.029823537
gear  0.605097617 -0.336150240  0.001735039  0.21382515 -0.053507085
carb -0.174603192  0.395629107 -0.170640677 -0.07225950  0.319594676
```

---


``` R
# 3. 주성분 개수 선택을 위한 실험

## 방법 1: 요약 통계량 확인 (누적 기여율 확인)
# summary() 함수는 각 주성분의 표준편차, 분산 기여율, 누적 분산 기여율을 보여줍니다.
# 'Cumulative Proportion' 값을 통해 몇 개의 주성분이 전체 분산의 80~90%를 설명하는지 확인할 수 있습니다.
summary(pca_mtcars)
```

실행결과

```R
> summary(pca_mtcars)
Importance of components:
                          PC1    PC2     PC3     PC4     PC5     PC6    PC7
Standard deviation     2.5707 1.6280 0.79196 0.51923 0.47271 0.46000 0.3678
Proportion of Variance 0.6008 0.2409 0.05702 0.02451 0.02031 0.01924 0.0123
Cumulative Proportion  0.6008 0.8417 0.89873 0.92324 0.94356 0.96279 0.9751
                           PC8    PC9    PC10   PC11
Standard deviation     0.35057 0.2776 0.22811 0.1485
Proportion of Variance 0.01117 0.0070 0.00473 0.0020
Cumulative Proportion  0.98626 0.9933 0.99800 1.0000

```

---

``` R

## 방법 2: 스크리 플롯 (Scree Plot) 시각화
# 스크리 플롯은 각 주성분의 분산(고유값)을 시각적으로 보여줍니다.
# 그래프가 급격히 꺾이는 '엘보우(elbow)' 지점 이전까지의 주성분을 선택하는 것이 일반적입니다.

# R 기본 함수로 스크리 플롯 그리기
screeplot(pca_mtcars, type = "lines", main = "Scree Plot for mtcars (Base R)")
```

실행 결과

<img width="1308" height="1164" alt="image" src="https://github.com/user-attachments/assets/19cf666d-ee69-4a2a-8bdc-305157bbf097" />

---

``` R

## 방법 3: 누적 분산 기여율(PVE) 플롯 시각화
# 주성분 개수에 따른 누적 분산 기여율(Proportion of Variance Explained)을 그래프로 그려
# 원하는 설명력(예: 80% 또는 90%)을 만족하는 최소한의 주성분 개수를 찾습니다.

library(ggplot2)

# 시각화를 위한 데이터 프레임 생성
variance_data <- data.frame(
  Component = 1:length(pca_mtcars$sdev),
  # 각 주성분이 설명하는 분산 비율
  Proportion_of_Variance = (pca_mtcars$sdev^2) / sum(pca_mtcars$sdev^2),
  # 누적 분산 비율
  Cumulative_Proportion = cumsum((pca_mtcars$sdev^2) / sum(pca_mtcars$sdev^2))
)

# 누적 분산 기여율 플롯 그리기
ggplot(variance_data, aes(x = Component, y = Cumulative_Proportion, group = 1)) +
  geom_line(color = "blue", size = 1) +
  geom_point(color = "red", size = 3) +
  # 80%, 90% 기준선 추가
  geom_hline(yintercept = 0.8, linetype = "dashed", color = "gray50") +
  geom_hline(yintercept = 0.9, linetype = "dashed", color = "gray50") +
  # 기준선 텍스트 추가
  annotate("text", x = 1.5, y = 0.83, label = "80% Threshold", color = "gray50") +
  annotate("text", x = 1.5, y = 0.93, label = "90% Threshold", color = "gray50") +
  # y축을 퍼센트 형식으로 표시
  scale_y_continuous(labels = scales::percent_format()) +
  labs(
    title = "Cumulative Proportion of Variance Explained (PVE)",
    x = "Number of Principal Components",
    y = "Cumulative Variance Explained"
  ) +
  theme_minimal()
```

실행결과

<img width="1308" height="1164" alt="image" src="https://github.com/user-attachments/assets/ea47bac1-644b-45fe-9432-d81d672f8400" />

</details>

---


## 주성분분석(PCA) 그림 그려보기

<details> <summary> 펼치기 </summary> 


``` R
# 1. 패키지 설치 및 로드
# factoextra 패키지가 설치되어 있지 않다면 설치합니다.
# 이 패키지는 PCA, 군집분석 등 다변량 분석 결과를 ggplot2 기반으로 시각화해 줍니다.
# install.packages("factoextra")
library(factoextra)
library(ggplot2) # factoextra는 ggplot2 기반으로 동작합니다.
```

---

``` R
# 2. PCA 재실행 (이전 코드와 연결)
# 이전 단계에서 생성한 pca_mtcars 객체를 그대로 사용하거나,
# 코드의 독립성을 위해 여기서 다시 실행합니다.
pca_mtcars <- prcomp(mtcars, scale. = TRUE)
```

---


``` R
# 3. R 기본 함수를 이용한 Biplot 시각화
# biplot() 함수는 제1주성분과 제2주성분 공간에
# 관측치(행 이름)와 변수(화살표)를 함께 시각화합니다.
# cex 인자를 사용하여 관측치와 변수 라벨의 글자 크기를 조절할 수 있습니다.
biplot(pca_mtcars, 
       scale = 0, # 관측치와 변수 간의 상대적 크기 조절
       cex = c(0.6, 0.8), # cex = c(관측치 글자크기, 변수 글자크기)
       main = "Biplot of mtcars data (Base R)")
```

실행결과

<img width="2561" height="1494" alt="image" src="https://github.com/user-attachments/assets/6c951ecd-af5c-4f99-a513-04ade9ff2b39" />



---
``` R 
# 4. factoextra 패키지를 이용한 고급 시각화
# factoextra는 더 미려하고 정보량이 많은 그래프를 쉽게 만들 수 있습니다.

# 4.1. 관측치(Individuals) 플롯
# 각 자동차 모델(관측치)이 주성분 공간에 어떻게 분포하는지 보여줍니다.
# - col.ind = "cos2": 각 점의 시각화 품질(representation quality)에 따라 색을 입힙니다.
#   (색이 진할수록 해당 2차원 평면에서 잘 표현됨)
# - repel = TRUE: 텍스트가 겹치지 않도록 자동으로 위치를 조정합니다.
fviz_pca_ind(pca_mtcars,
             col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE,     
             ggtheme = theme_minimal(),
             title = "PCA Individuals Plot (factoextra)")
```

실행결과

<img width="2561" height="1494" alt="image" src="https://github.com/user-attachments/assets/68e64702-5e0a-4da4-aa04-a3daace88c62" />


---

``` R
# 4.2. 변수(Variables) 플롯 - 상관관계 원(Correlation Circle)
# 각 변수(화살표)가 주성분에 얼마나 기여하는지 보여줍니다.
# - 화살표가 길고 특정 축(Dim1, Dim2)에 가까울수록 해당 주성분과의 상관관계가 높습니다.
# - col.var = "contrib": 각 변수가 주성분 생성에 기여한 정도에 따라 색을 입힙니다.
fviz_pca_var(pca_mtcars,
             col.var = "contrib", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE,
             ggtheme = theme_minimal(),
             title = "PCA Variables Plot (factoextra)")
```

실행결과

<img width="2561" height="1494" alt="image" src="https://github.com/user-attachments/assets/bf5a1c4f-0ae2-4002-b20d-123fdb4eab61" />


---

``` R
# 4.3. Biplot (관측치와 변수 동시 시각화)
# factoextra의 biplot은 가독성이 더 높고 사용자 정의가 용이합니다.
# - geom.ind = "point": 관측치는 점으로만 표시하여 변수 화살표에 집중할 수 있게 합니다.
fviz_pca_biplot(pca_mtcars,
                repel = TRUE,
                geom.ind = "point",   # 관측치는 점으로 표시
                col.var = "#E7B800",  # 변수 화살표 색상
                col.ind = "#696969",  # 관측치 점 색상
                ggtheme = theme_minimal(),
                title = "PCA Biplot (factoextra)")
```

실행결과

<img width="2561" height="1494" alt="image" src="https://github.com/user-attachments/assets/59b88dc4-37f5-4f2b-a1c4-383cef6bbcf7" />




</details>

---

## 예상 질문: 표준화와 중심화가 같은 내용인가?

<details> 

<summary> 답변 펼치기 </summary>

결론부터 말씀드리면, **`scale`은 '표준화(standardization)'를 의미하며, '중심화(centering)'는 표준화 과정에 포함되는 한 단계**입니다.

두 개념을 나누어 설명해 드리겠습니다.

### 1. 중심화 (Centering)

-   **무엇인가요?** 데이터의 각 값에서 해당 변수의 **평균(mean)을 빼는** 과정입니다.
-   **목적:** 데이터의 평균을 **0**으로 만듭니다. 데이터의 분포 형태나 변동성은 그대로 유지한 채, 전체 데이터셋을 원점(0,0) 중심으로 이동시키는 효과가 있습니다.
-   **수식:** `x_centered = x - mean(x)`

### 2. 척도조정 (Scaling)

-   **무엇인가요?** 데이터의 각 값을 해당 변수의 **표준편차(standard deviation)로 나누는** 과정입니다.
-   **목적:** 데이터의 표준편차를 **1**로 만듭니다. 이를 통해 서로 다른 단위나 범위를 가진 변수들을 동등한 척도(scale)로 비교할 수 있게 됩니다.
-   **수식:** `x_scaled = x / sd(x)`

---

### 표준화 (Standardization) = 중심화 + 척도조정

**표준화**는 위 두 과정을 모두 수행하는 것을 의미합니다. 즉, 데이터에서 평균을 뺀 후, 그 결과를 표준편차로 나누어 **평균이 0이고 표준편차가 1인 분포**로 변환하는 것입니다. 통계학에서 말하는 Z-점수(Z-score)를 구하는 과정과 동일합니다.

### `prcomp(..., scale. = TRUE)`의 의미

R의 `prcomp` 함수에서 `scale. = TRUE` 옵션을 사용하는 것은 **표준화(Standardization)를 하겠다**는 의미입니다.

-   `prcomp` 함수는 기본적으로 `center = TRUE` 옵션이 설정되어 있어 **중심화**를 먼저 수행합니다.
-   여기에 `scale. = TRUE`를 추가하면, 중심화된 데이터에 대해 **척도조정**까지 수행하게 됩니다.

따라서 `scale. = TRUE`는 '중심화'만 의미하는 것이 아니라, **'중심화 후 척도조정까지 모두 수행'**하는 것을 뜻합니다.

| 과정 (Process) | 목적 (Purpose) | 결과 (Result) | `prcomp` 옵션 |
| :--- | :--- | :--- | :--- |
| **중심화** (Centering) | 평균을 0으로 만듦 | `평균 = 0` | `center = TRUE` (기본값) |
| **척도조정** (Scaling) | 표준편차를 1로 만듦 | `표준편차 = 1` | `scale. = TRUE` |
| **표준화** (Standardization) | **중심화 + 척도조정** | **`평균=0, 표준편차=1`** | **`scale. = TRUE`** (중심화 자동 포함) |

주성분분석에서 `mtcars` 데이터처럼 변수들의 단위(마력, 무게, 연비 등)가 제각각일 때 `scale. = TRUE`를 사용하지 않으면, 분산이 큰 변수(예: `hp`나 `disp`)가 분석 결과를 과도하게 지배하게 되므로, **표준화는 매우 중요한 전처리 과정**입니다.

</details>
