
``` R
# -------------------------------------------------------------
# 1. 데이터 불러오기 및 준비
# -------------------------------------------------------------
file_path <- "D:/R_여름특강/데이터/R_Visual_and_DataAnal(B)/countries.csv"

# CSV 파일 읽기
# 첫 번째 열이 국가 이름이므로 row.names = 1 인수를 사용하여 행 이름으로 지정합니다.
countries <- read.csv(file_path, row.names = 1)

# 데이터 구조 및 앞부분 확인
str(countries)
head(countries)
```

결과는 아래처럼 나올겁니다.
```R
> str(countries)
'data.frame':	25 obs. of  4 variables:
 $ GDP         : num  1690 39599 2685 45555 1006 ...
 $ laborrate   : num  72.9 67.8 66.9 60.4 69.2 54.5 63 53.7 72.7 48.8 ...
 $ healthexp   : num  74.2 4379.8 186.1 5037.3 47.1 ...
 $ infmortality: num  27.8 5.2 25.9 3.6 71.5 11.1 41.1 3.5 74.7 20 ...
> head(countries)
                GDP laborrate  healthexp infmortality
Mongolia   1690.417      72.9   74.19826         27.8
Canada    39599.042      67.8 4379.76084          5.2
Guatemala  2684.966      66.9  186.12313         25.9
Austria   45555.435      60.4 5037.31089          3.6
Zambia     1006.388      69.2   47.05637         71.5
Bulgaria   6403.148      54.5  474.84637         11.1
```
---

## 파이차트 그리기

``` R
# -------------------------------------------------------------
# 2. 각 열별로 파이 차트 그리기 (요청하신 방법)
# -------------------------------------------------------------
# 이 데이터 유형에 파이 차트는 적합한 시각화 방법이 아닐 수 있습니다. 물론 데이터마다 파이차트가 맞는 그림들이 있습니다.
# 
# (이유는 아래 설명을 참고하세요)

# infmortality를 기준으로 일단 파이차트를 그려보겠습니다.
par(mfrow = c(1, 1))
pie(
  x = countries$infmortality,          # 사용할 데이터 열
  labels = rownames(countries),      # 각 조각의 라벨 (국가 이름)
  main = paste(col_name, "Pie Chart"), # 그래프 제목
  cex = 0.6                          # 라벨 폰트 크기 줄이기 (겹침 방지)
)
```

<img width="392" height="358" alt="image" src="https://github.com/user-attachments/assets/59d360e3-eda7-4c6f-b241-de08fce5b987" />

x에는 선생님들의 "데이터이름$분석하고자하는열이름" 을 넣어주세요

---

## 응용

A 클래스 첫날에 배운 for loop를 응용하면 각 열별로 그려볼 수 있습니다.

``` R
# 그래프를 2x2 그리드에 배열하여 한 번에 보기
par(mfrow = c(2, 2))

# 각 열의 이름을 반복하면서 파이 차트 생성
for (col_name in names(countries)) {
  pie(
    x = countries[[col_name]],          # 사용할 데이터 열
    labels = rownames(countries),      # 각 조각의 라벨 (국가 이름)
    main = paste(col_name, "Pie Chart"), # 그래프 제목
    cex = 0.6                          # 라벨 폰트 크기 줄이기 (겹침 방지)
  )
}

# 그래프 설정 초기화
par(mfrow = c(1, 1))
```

<img width="392" height="358" alt="image" src="https://github.com/user-attachments/assets/35505265-d0d9-4d20-9eca-a35e4b6eeb3a" />


## 3. 설명: 왜 이 데이터에 파이 차트는 부적합할까요?
* 위 코드를 실행해보면 아시겠지만, 파이 차트가 매우 복잡하고 정보를 파악하기 어렵습니다.

1. 파이 차트는 '전체에 대한 부분의 비율'을 보여줄 때 효과적입니다.
   (예: 전체 인구 중 대륙별 인구 비율)
   하지만 GDP, 노동률 등은 각 국가의 독립적인 측정값이며, 이 값들을 모두
   더한 '전체'는 큰 의미를 가지지 않습니다.

2. 항목(국가)이 너무 많습니다.
   수많은 국가들이 작은 조각으로 표시되어 구분이 불가능합니다.

3. 값의 크기를 비교하기 어렵습니다.
   사람의 눈은 각도나 면적을 비교하는 것보다 길이를 비교하는 데 훨씬 뛰어납니다.
   어느 나라의 GDP가 다른 나라보다 2배 높은지 파이 차트로는 알기 힘듭니다.

``` R
# -------------------------------------------------------------
# 4. 더 나은 시각화: 막대 그래프 (Bar Plot)
# -------------------------------------------------------------
# 각 국가의 값을 명확하게 비교하기 위해 막대 그래프를 사용하는 것이 훨씬 효과적입니다.

# 그래프를 2x2 그리드에 배열하고, 라벨 공간을 위해 왼쪽 여백(mar)을 늘립니다.
par(mfrow = c(2, 2), mar = c(4, 7, 3, 2))

for (col_name in names(countries)) {
  # 데이터를 정렬하면 그래프를 더 쉽게 읽을 수 있습니다.
  # order() 함수를 사용해 해당 열을 기준으로 데이터 프레임 전체를 정렬합니다.
  sorted_data <- countries[order(countries[[col_name]]), ]
  
  barplot(
    height = sorted_data[[col_name]],   # 막대의 높이 (정렬된 데이터)
    names.arg = rownames(sorted_data),  # 막대의 이름 (정렬된 국가 이름)
    horiz = TRUE,                       # 가로 막대 그래프로 변경
    las = 1,                            # y축 라벨을 가로로 표시 (항상 읽기 쉽게)
    main = paste(col_name, "Bar Plot"), # 그래프 제목
    xlab = col_name,                    # x축 이름
    cex.names = 0.7                     # 막대 이름 폰트 크기 조절
  )
}

# 그래프 및 여백 설정 초기화
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)
```


<img width="392" height="358" alt="image" src="https://github.com/user-attachments/assets/030d8642-b7cf-48c0-89d1-a64f35961326" />

물론 뭐가 더 좋다에 정해진 답은 없습니다.

---

# 난 그래도 파이차트로 끝장을 볼래

저는 보통 제 방법이 틀려도 끝장을 보는 편입니다.

최대한 더 발전을 시켜보면... 
예를 들어 "특정 열에서 특정 값 이상을 갖는 애들을 대상으로 파이차트를 그려보자!"를 해보겠습니다.

``` R
# -------------------------------------------------------------
# 데이터 필터링: infmortality > 20
# -------------------------------------------------------------
# 'infmortality' 열의 값이 20보다 큰 행(국가)만 선택하여 새로운 데이터 프레임 생성
high_mortality_countries <- countries[countries$infmortality > 20, ]

# 필터링된 데이터 확인
print("--- 유아 사망률이 20보다 큰 국가 목록 ---")
print(high_mortality_countries)
```

``` R
> print("--- 유아 사망률이 20보다 큰 국가 목록 ---")
[1] "--- 유아 사망률이 20보다 큰 국가 목록 ---"
> print(high_mortality_countries)
                   GDP laborrate healthexp infmortality
Mongolia     1690.4170      72.9  74.19826         27.8
Guatemala    2684.9664      66.9 186.12313         25.9
Zambia       1006.3882      69.2  47.05637         71.5
Azerbaijan   4808.1688      63.0 284.72528         41.1
Benin         771.7088      72.7  31.92885         74.7
Nepal         438.1784      71.5  25.34454         43.3
Kenya         744.4031      82.2  33.24912         56.3
Algeria      4022.1989      58.5 267.94653         32.0
Lesotho       800.4202      74.0  70.04993         67.0
Nigeria      1091.1344      56.2  69.29737         90.4
Liberia       229.2703      71.1  29.35613         77.6
Turkmenistan 3710.4536      68.0  77.06955         48.0
```

* 잘 필터링 되었네요, 계속 해보면

``` R
# -------------------------------------------------------------
# 필터링된 데이터로 파이 차트 그리기
# -------------------------------------------------------------
# 파이 차트를 그립니다.
pie(
  x = high_mortality_countries$infmortality,
  labels = rownames(high_mortality_countries),
  main = "유아 사망률(20 초과) 국가별 비율",
  #col = rainbow(nrow(high_mortality_countries)), # 각 조각에 다른 색상 적용
  cex = 0.8                                     # 라벨 폰트 크기 조절
)

```

<img width="392" height="358" alt="image" src="https://github.com/user-attachments/assets/a849e466-e8e8-467c-af67-9bd50fb61562" />

이렇게 응용하면 교수님한테 혼나더라도 원하는 그림을 그릴 수 있습니다.
