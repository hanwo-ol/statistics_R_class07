## 연령 그룹별 수입 평균 비교 검정
    
**분석 목표**: Buy 데이터를 이용하여 연령 그룹('30대 미만', '30대 이상')에 따라 평균 수입(income)에 통계적으로 유의미한 차이가 있는지 확인합니다.

### 1. 데이터 준비 및 탐색

```R
# 1. 데이터 불러오기
# buy.csv 파일을 데이터프레임으로 읽어옵니다.
buy <- utils::read.csv("D:/2025여름 특강/R/B_data/buy.csv")

# 2. 분석에 필요한 연령 그룹 변수 생성
# dplyr::mutate()와 ifelse()를 사용하여 'age'가 3 미만이면 "30대 미만",
# 그렇지 않으면 "30대 이상"으로 분류하는 'age_group' 열을 추가합니다.
buy_new <- buy |>
  dplyr::mutate(age_group = ifelse(age < 3, "30대 미만", "30대 이상"))

# 3. 그룹별 데이터 수 확인
# table() 함수로 각 그룹에 몇 명의 데이터가 있는지 확인합니다.
table(buy_new$age_group)
#> 30대 미만 30대 이상 
#>       203       497 
# [결과 해석]: '30대 미만' 그룹은 203명, '30대 이상' 그룹은 497명의 데이터를 가지고 있음을 확인합니다.
```

### 2. 시각화를 통한 데이터 탐색

```R
# 1. 상자 그림(Boxplot)으로 분포 비교
# 그룹별 수입 분포의 중앙값, 사분위수, 이상치 등을 한눈에 비교할 수 있습니다.
ggplot2::ggplot(buy_new, ggplot2::aes(x = age_group, y = income, fill = age_group)) +
  ggplot2::geom_boxplot() +
  ggplot2::labs(title = "연령 그룹별 수입 분포",
                x = "연령 그룹",
                y = "수입(income)")
# [결과 해석]: 상자 그림을 통해 '30대 이상' 그룹의 수입 중앙값과 전체적인 분포가 '30대 미만' 그룹보다 시각적으로 더 높게 위치하는 것을 확인할 수 있습니다.

# 2. 히스토그램으로 분포 형태 확인
# 그룹별로 데이터가 어떤 모양으로 분포하는지 확인합니다.
ggplot2::ggplot(buy_new, ggplot2::aes(x = income)) +
  ggplot2::geom_histogram(ggplot2::aes(fill = age_group), bins = 30, alpha = 0.7, position = "identity") +
  ggplot2::facet_grid(age_group ~ .) +
  ggplot2::labs(title = "연령 그룹별 수입 히스토그램",
                x = "수입(income)",
                y = "빈도")
# [결과 해석]: 두 그룹 모두 데이터가 왼쪽으로 치우치고 오른쪽으로 꼬리가 긴(right-skewed) 분포를 보입니다. 이는 정규분포 가정에 위배될 수 있음을 시사합니다.
```

### 3. T-검정의 가정 확인

#### 가정 1: 정규성 검정 (Shapiro-Wilk Test)
-   **H₀ (귀무가설)**: 데이터는 정규분포를 따른다.
-   **H₁ (대립가설)**: 데이터는 정규분포를 따르지 않는다.

```R
# 30대 미만 그룹의 수입에 대한 정규성 검정
stats::shapiro.test(buy_new$income[buy_new$age_group == "30대 미만"])
#> Shapiro-Wilk normality test
#> data:  buy_new$income[buy_new$age_group == "30대 미만"]
#> W = 0.83577, p-value = 7.064e-14
# [결과 해석]: p-value가 유의수준 0.05보다 매우 작으므로, '30대 미만' 그룹의 수입 데이터는 정규분포를 따른다는 귀무가설을 기각합니다.

# 30대 이상 그룹의 수입에 대한 정규성 검정
stats::shapiro.test(buy_new$income[buy_new$age_group == "30대 이상"])
#> Shapiro-Wilk normality test
#> data:  buy_new$income[buy_new$age_group == "30대 이상"]
#> W = 0.73901, p-value < 2.2e-16
# [결과 해석]: p-value가 유의수준 0.05보다 매우 작으므로, '30대 이상' 그룹의 수입 데이터 역시 정규분포를 따른다는 귀무가설을 기각합니다.
# [종합]: 두 그룹 모두 정규성 가정을 만족하지 않습니다. 하지만 표본 크기가 각각 203, 497로 충분히 크므로 중심극한정리에 의해 T-검정을 진행할 수 있습니다.
```

#### 가정 2: 등분산성 검정 (F-test)
-   **H₀ (귀무가설)**: 두 그룹의 분산은 동일하다.
-   **H₁ (대립가설)**: 두 그룹의 분산은 동일하지 않다.

```R
# 두 그룹 간 분산 동일성 검정
stats::var.test(income ~ age_group, data = buy_new)
#> F test to compare two variances
#> data:  income by age_group
#> F = 0.082404, num df = 202, denom df = 496, p-value < 2.2e-16
#> alternative hypothesis: true ratio of variances is not equal to 1
#> 95 percent confidence interval:
#>  0.06572626 0.10450575
#> sample estimates:
#> ratio of variances 
#>         0.08240427 
# [결과 해석]: p-value가 유의수준 0.05보다 매우 작으므로, 두 그룹의 분산이 동일하다는 귀무가설을 기각합니다. 
# 즉, 두 그룹의 분산은 통계적으로 다릅니다. 따라서 T-검정 시 등분산을 가정하지 않는 Welch's T-test를 사용해야 합니다 (var.equal = FALSE 옵션).
```

### 4. 독립표본 T-검정 (Welch's T-test)

-   **H₀ (귀무가설)**: '30대 미만'과 '30대 이상' 그룹의 평균 수입은 같다.
-   **H₁ (대립가설)**: '30대 미만'과 '30대 이상' 그룹의 평균 수입은 같지 않다.
-   **유의수준**: 0.05

```R
# 독립표본 T-검정 (Welch's T-test)
stats::t.test(income ~ age_group, 
              data = buy_new,
              alternative = 'two.sided', # 평균이 다른지 검정 (양측검정)
              var.equal = FALSE,         # 등분산성 가정을 만족하지 않았으므로 FALSE
              conf.level = 0.95)         # 신뢰수준 95%
#> Welch Two Sample t-test
#> data:  income by age_group
#> t = -13.788, df = 651.24, p-value < 2.2e-16
#> alternative hypothesis: true difference in means between group 30대 미만 and group 30대 이상 is not equal to 0
#> 95 percent confidence interval:
#>  -3011.594 -2260.716
#> sample estimates:
#> mean in group 30대 미만 mean in group 30대 이상 
#>                2668.473                5304.628 
```

### 5. 최종 결론

1.  **통계적 결론**: p-value가 2.2e-16으로 유의수준 0.05보다 매우 작으므로, 귀무가설("두 그룹의 평균 수입은 같다")을 기각합니다.
2.  **결과 해석**: '30대 미만' 그룹과 '30대 이상' 그룹의 평균 수입에는 통계적으로 매우 유의미한 차이가 존재합니다.
3.  **구체적 내용**: 표본 평균을 보면 '30대 미만' 그룹의 평균 수입은 약 2668.5인 반면, '30대 이상' 그룹의 평균 수입은 약 5304.6으로, **'30대 이상' 그룹의 평균 수입이 유의하게 더 높다**고 결론 내릴 수 있습니다. 95% 신뢰구간 `[-3011.59, -2260.72]`에 0이 포함되지 않는다는 점도 두 그룹 간 평균에 차이가 있음을 뒷받침합니다.
