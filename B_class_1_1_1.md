## 1 R을 이용한 데이터 시각화

### 1.1 내장 함수의 활용

R은 별도의 패키지 설치 없이도 다양한 그래프를 그릴 수 있는 강력한 내장 그래픽 함수들을 제공합니다. `graphics` 패키지에 포함된 함수들이 주로 사용됩니다.
각 그래프를 보시면서, 어떤 특징이 있고, 어떤 데이터를 시각화할 때 좋을까? 고민하시면 좋습니다.

#### 1.1.1 기본 그래프

```R
# R에 내장된 VADeaths 데이터셋을 불러옵니다.
# 이 데이터는 1940년 버지니아의 연령대 및 거주지(시골/도시)별 사망률(1000명당)을 나타냅니다.
data(VADeaths)

barplot(VADeaths,
        beside = TRUE,
        legend = TRUE,
        ylim = c(0, 90),
        ylab = "Deaths per 1000",
        main = "Death rates in Virginia",
        args.legend = list(x = "topleft")) # 범례 위치를 '왼쪽 상단'으로 지정
```    
`arg.legend`는 범례(legend)의 위치를 설정해줍니다.
* x 값으로는 "topleft", "topright", "bottomleft", "bottomright" 등을 사용할 수 있습니다. 

<img width="853" height="498" alt="image" src="https://github.com/user-attachments/assets/5638b422-b40b-4bd5-b1f4-951a122f6272" />

---



```R
# 점 그래프(dot chart)를 그리는 코드
# dotchart()는 막대그래프보다 공간을 덜 차지하면서도 데이터를 명확하게 비교할 수 있는 장점이 있습니다.
dotchart(VADeaths,
         xlim = c(0, 75), # x축의 값 범위를 0에서 75로 설정합니다 (x-limit).
         xlab = "Deaths per 1000", # x축에 표시될 이름(label)을 설정합니다.
         main = "Death rates in Virginia") # 그래프의 전체 제목을 설정합니다.
```
<img width="1175" height="1074" alt="image" src="https://github.com/user-attachments/assets/c5d1415b-b07e-45c4-99ef-414fa4fe6b2d" />

---

```R
# 파이 차트에 사용할 데이터를 생성합니다.
groupsizes <- c(18, 30, 32, 10, 10) # 각 그룹의 크기를 벡터로 저장합니다.
labels <- c("A", "B", "C", "D", "F") # 각 그룹의 이름을 벡터로 저장합니다.

# 파이 차트를 생성합니다.
# pie() 함수는 전체에 대한 각 부분의 비율을 보여줄 때 사용됩니다.
pie(groupsizes, labels, col = c("grey40", "white", "grey", "black", "grey90"))
# 'col' 인자는 각 조각의 색상을 지정합니다.

# 참고: RColorBrewer 패키지를 사용하면 다양한 색상 팔레트를 쉽게 사용할 수 있습니다.
# 예: RColorBrewer::brewer.pal() 함수는 미리 정의된 아름다운 색상 조합을 제공합니다.
```

<img width="392" height="358" alt="image" src="https://github.com/user-attachments/assets/19bd41f0-c61a-4f38-a378-a1196e781e36" />   

미적 감각이 없는 저도 밋밋함을 알아차릴 수 있을 정도입니다. 조금 기교를 부려보면
``` R
# 0. 색상 팔레트 패키지 설치 (컴퓨터에 한번만 설치하면 됩니다)
# install.packages("RColorBrewer")

# 1. RColorBrewer 라이브러리를 불러옵니다.
library(RColorBrewer)

# 2. 데이터 준비
groupsizes <- c(18, 30, 32, 10, 10)
labels <- c("A", "B", "C", "D", "F")

# 3. 각 그룹의 백분율(%)을 계산합니다.
# round() 함수를 이용해 소수점 첫째 자리까지만 표시합니다.
percentages <- round(groupsizes / sum(groupsizes) * 100, 1)

# 4. 라벨에 백분율 정보를 결합합니다.
# sprintf() 함수를 사용하면 깔끔한 형식의 텍스트를 만들 수 있습니다.
# 결과: "A (18.0%)", "B (30.0%)" ...
pie_labels <- sprintf("%s (%.1f%%)", labels, percentages)

# 5. RColorBrewer에서 제공하는 색상 팔레트를 사용합니다.
# "Pastel1" 팔레트에서 5개의 색상을 자동으로 선택합니다.
# (다른 팔레트 이름: "Set1", "Set2", "Accent", "Paired" 등)
colors <- brewer.pal(length(groupsizes), "Pastel1")

# 6. 최종 파이 차트 생성 
pie(groupsizes,                          # 데이터
    labels = pie_labels,                 # 백분율이 포함된 라벨 사용
    col = colors,                        # RColorBrewer 색상 팔레트 적용
    main = "과목별 성적 분포",            # 그래프 전체 제목 추가
    border = "white",                    # 파이 조각 테두리를 흰색으로 설정하여 구분감 부여
    init.angle = 90,                     # 차트 시작 각도를 90도로 설정 (12시 방향부터 시작)
    radius = 0.95                        # 라벨이 잘리지 않도록 차트 크기를 살짝 줄임
   )

# 7. (선택 사항) 범례 추가하기
# 라벨 대신 범례로 정보를 표시하고 싶을 때 사용할 수 있습니다.
legend("topright",                       # 범례 위치 (오른쪽 상단)
       labels,                           # 범례에 표시할 텍스트
       fill = colors,                    # 각 텍스트에 해당하는 색상
       cex = 0.8)                        # 범례 폰트 크기 조정
```

<img width="392" height="358" alt="image" src="https://github.com/user-attachments/assets/c47e5fcd-2fd1-4daf-8d1f-61b91f500f82" />
제 눈엔 좀 이뻐졌네요

---

```R
# stats::rnorm() 함수를 사용하여 표준 정규 분포(평균 0, 표준편차 1)를 따르는 1000개의 난수를 생성합니다.
x <- stats::rnorm(1000)

# 히스토그램을 생성합니다.
# hist() 함수는 연속형 데이터의 분포를 구간별로 나누어 막대의 높이로 표현합니다.
hist(x,
     probability = TRUE, # y축을 빈도(frequency)가 아닌 확률 밀도(density)로 표시합니다. 이 옵션을 켜야 밀도 곡선을 추가할 수 있습니다.
     col = 'gray90')     # 막대의 색상을 'gray90'으로 지정합니다.
```
<img width="392" height="358" alt="image" src="https://github.com/user-attachments/assets/9bda6537-411e-414d-bc09-599478e42cfa" />

**막대 그래프와 히스토그램이 다르다는 것은 기억하고 있어주세요.**

---

```R
# iris 데이터셋을 사용하여 상자 그림(boxplot)을 생성합니다.
# boxplot()은 데이터의 분포(중앙값, 사분위수, 이상치 등)를 시각적으로 요약하여 보여줍니다.
boxplot(Sepal.Length ~ Species, # 물결(~) 기호는 '그룹별로'라는 의미입니다. 즉, Species(품종)별로 Sepal.Length(꽃받침 길이)의 분포를 비교합니다.
        data = iris,           # 사용할 데이터셋을 R 내장 데이터인 'iris'로 지정합니다.
        ylab = "Sepal length (cm)", # y축의 이름을 설정합니다.
        main = "Iris measurements", # 그래프의 제목을 설정합니다.
        boxwex = 0.5)          # 상자의 너비(width)를 기본값(0.8)보다 작은 0.5로 조정합니다.
```
<img width="392" height="358" alt="image" src="https://github.com/user-attachments/assets/b7d9a56e-2391-438e-b3c3-23771e88982d" />

---

```R
# Q-Q 플롯(Quantile-Quantile Plot)은 두 확률 분포의 분위수(quantile)를 비교하여
# 데이터가 특정 분포(예: 정규분포)를 따르는지 시각적으로 검토하는 그래프입니다.

# --- 두 분포가 같은 경우 ---
# stats::rnorm()으로 표준 정규 분포를 따르는 데이터 1000개를 생성합니다.
X <- stats::rnorm(1000) # 기준 데이터
A <- stats::rnorm(1000) # 비교 데이터 (X와 동일한 분포)

# 두 데이터셋(A, X)의 Q-Q 플롯을 생성합니다. 점들이 직선에 가깝게 분포하면 두 데이터는 같은 분포를 가집니다.
stats::qqplot(A, X, main = "A and X are the same")
# 기준선 추가: X가 정규분포를 따른다고 가정하고 이론적인 분위수 선을 그립니다.
# distribution 인자는 분위수 함수(quantile function, q-function)를 받습니다. qnorm은 정규분포의 분위수 함수입니다.
stats::qqline(X, distribution = function(p) stats::qnorm(p))
```
<img width="392" height="358" alt="image" src="https://github.com/user-attachments/assets/2c406db4-8a9f-4ed5-ae5f-46d606ca943e" />

아래와 비교해보시죠

``` R

# --- 두 분포가 다른 경우 (Heavy tails) ---
# 자유도(df)가 2인 t-분포를 따르는 데이터 1000개를 생성합니다. t-분포는 정규분포보다 "꼬리가 두꺼운" 특징이 있습니다.
B <- stats::rt(1000, df = 2)

# t-분포 데이터(B)와 정규분포 데이터(X)의 Q-Q 플롯을 생성합니다. 양 끝점이 선에서 벗어나는 것을 볼 수 있습니다.
stats::qqplot(B, X, main = "B has heavier tails")
# 기준선 추가: B가 t-분포(df=2)를 따른다고 가정하고 이론적인 분위수 선을 그립니다.
stats::qqline(B, distribution = function(p) stats::qt(p, df = 2))
```
<img width="392" height="358" alt="image" src="https://github.com/user-attachments/assets/b4b73263-9842-4feb-bdc4-51a6634b29f4" />

---



```R
# 산점도(Scatter plot)를 그리기 위한 데이터를 생성합니다.
x <- stats::rnorm(100)      # 표준 정규 분포를 따르는 난수 100개 생성
y <- stats::rpois(100, 30)  # 람다(lambda)가 30인 포아송 분포를 따르는 난수 100개 생성

# x와 y에 대한 산점도를 그립니다.
# plot() 함수는 두 연속형 변수 간의 관계를 파악하는 데 사용됩니다.
plot(x, y,
     type = 'p', # 그래프의 종류를 점(point)으로 지정합니다. 'l'은 선, 'b'는 점과 선 모두를 의미합니다.
     xlab = 'Standard Normal', # x축 이름
     ylab = 'Poisson (lambda = 30)', # y축 이름
     main = "Poisson versus Normal") # 그래프 제목
```

<img width="392" height="358" alt="image" src="https://github.com/user-attachments/assets/2266f2a2-9fcb-4256-ab15-2e68e8416a22" />

---

```R
# R에 내장된 stackloss 데이터셋을 불러옵니다.
# 이 데이터는 암모니아 산화 공장의 21일간 운영 데이터(풍량, 냉각수 온도, 산 농도, 암모니아 손실률)입니다.
utils::data(stackloss)

# pairs() 함수는 데이터프레임의 모든 변수 쌍에 대한 산점도 행렬(scatterplot matrix)을 그립니다.
# 데이터에 포함된 여러 변수 간의 관계를 한눈에 파악하는 데 유용합니다.
graphics::pairs(stackloss)
```
<img width="392" height="358" alt="image" src="https://github.com/user-attachments/assets/92b90813-2575-4ab4-836b-fe66cb9abd80" />

