## 두 수면제의 효과 비교 (대응표본 T-검정)
    
**분석 목표**: R 내장 데이터인 `sleep` 데이터를 이용하여, 10명의 동일한 환자에게 투여된 두 종류의 수면제가 수면 시간 증가량에 미치는 효과에 통계적으로 유의미한 차이가 있는지 알아봅니다.

### 1. 데이터 확인 및 구조 파악
 
```R
# 1. 데이터 불러오기 및 구조 확인
# R 내장 데이터인 sleep을 불러옵니다.
utils::data(sleep)
# 데이터의 처음 6개 행을 확인하여 구조를 파악합니다.
utils::head(sleep)
#>   extra group ID
#> 1   0.7     1  1
#> 2  -1.6     1  2
#> 3  -0.2     1  3
#> 4  -1.2     1  4
#> 5  -0.1     1  5
#> 6   3.4     1  6
# 데이터의 변수 유형과 구조를 자세히 확인합니다.
utils::str(sleep)
#> 'data.frame':	20 obs. of  3 variables:
#>  $ extra: num  0.7 -1.6 -0.2 -1.2 -0.1 3.4 3.7 0.8 0 2 ...
#>  $ group: Factor w/ 2 levels "1","2": 1 1 1 1 1 1 1 1 1 1 ...
#>  $ ID   : Factor w/ 10 levels "1","2","3","4",..: 1 2 3 4 5 6 7 8 9 10 ...
# [결과 해석]: 데이터는 20개의 관측치와 3개의 변수로 구성되어 있습니다.
# - extra: 수면 시간 증가량 (수치형)
# - group: 수면제 종류 (1, 2) (범주형)
# - ID: 환자 식별 번호 (1-10) (범주형)
# 동일한 ID가 두 그룹(group 1, 2)에 모두 나타나므로, 이 데이터는 **대응표본(Paired Sample)** 데이터입니다.
# 따라서 두 그룹의 평균을 비교할 때 독립표본이 아닌 **대응표본 T-검정**을 사용해야 합니다.
```

### 2. 시각화를 통한 데이터 탐색

```R
# 2. 데이터 시각화
# 상자 그림(Boxplot)을 이용해 두 약물 그룹 간 수면 시간 증가량의 분포를 시각적으로 비교합니다.
ggplot2::ggplot(sleep, ggplot2::aes(x = group, y = extra, fill = group)) +
  ggplot2::geom_boxplot(show.legend = FALSE) + # 범례는 불필요하므로 숨깁니다.
  ggplot2::labs(title = "두 수면제 그룹별 수면 시간 증가량 비교",
                x = "수면제 그룹",
                y = "수면 시간 증가량 (시간)") +
  ggplot2::theme_minimal()
# [결과 해석]: 상자 그림을 통해 그룹 2의 수면 시간 증가량이 그룹 1보다 전반적으로 더 높은 경향을 보입니다.
```

<img width="373" height="380" alt="image" src="https://github.com/user-attachments/assets/5c03ee7f-203b-4dff-9313-47c49cbe782d" />



### 3. 대응표본 T-검정의 가정 확인

대응표본 T-검정의 핵심 가정은 **두 그룹 간의 차이값(differences)이 정규분포를 따른다**는 것입니다.

-   **H₀ (귀무가설)**: 두 그룹 간 차이값은 정규분포를 따른다.
-   **H₁ (대립가설)**: 두 그룹 간 차이값은 정규분포를 따르지 않는다.

```R
# 데이터를 'wide' 형태로 변환하여 개인별 차이를 계산하기 쉽게 만듭니다.
# tidyr 패키지의 pivot_wider 함수를 사용합니다.
sleep_wide <- tidyr::pivot_wider(sleep, 
                                 names_from = group, 
                                 values_from = extra, 
                                 names_prefix = "drug_")

# 각 개인의 두 약물 간 효과 차이를 계산하여 새로운 열(difference)을 만듭니다.
sleep_wide <- sleep_wide |>
  dplyr::mutate(difference = drug_2 - drug_1)

# Shapiro-Wilk 검정으로 차이값의 정규성을 확인합니다.
stats::shapiro.test(sleep_wide$difference)
#> Shapiro-Wilk normality test
#> data:  sleep_wide$difference
#> W = 0.82987, p-value = 0.03334
# [결과 해석]: 
# p-value(0.03334)가 유의수준 0.05보다 작기 때문에 귀무가설을 기각하며, 차이값이 정규분포를 따른다고 보기 어렵습니다.  
```

### 4. 대응표본 T-검정 (Paired T-test)

-   **H₀ (귀무가설)**: 두 수면제의 평균 수면 시간 증가량에는 차이가 없다 (평균 차이 = 0).
-   **H₁ (대립가설)**: 두 수면제의 평균 수면 시간 증가량에는 차이가 있다 (평균 차이 ≠ 0).
-   **유의수준**: 0.05

```R
# t.test 함수에 paired = TRUE 옵션을 주어 대응표본 T-검정을 수행합니다.
# 이 방법은 데이터를 변환할 필요 없이 원본 데이터(long format)를 바로 사용할 수 있어 편리합니다.
stats::t.test(extra ~ group, data = sleep, paired = TRUE)
#> Paired t-test
#> data:  extra by group
#> t = -4.0621, df = 9, p-value = 0.002833
#> alternative hypothesis: true mean difference is not equal to 0
#> 95 percent confidence interval:
#>  -2.4598858 -0.7001142
#> sample estimates:
#> mean difference 
#>           -1.58 
```

### 5. 최종 결론

1.  **통계적 결론**: p-value(0.002833)가 유의수준 0.05보다 매우 작으므로, 귀무가설("두 수면제의 효과는 차이가 없다")을 기각합니다.
2.  **결과 해석**: 두 수면제의 평균 수면 시간 증가량에는 **통계적으로 유의미한 차이가 존재합니다.**
3.  **구체적 내용**: `mean difference` 값이 **-1.58**로 나타났습니다. 이는 R이 `mean(group1) - mean(group2)`를 계산한 결과입니다. 즉, 그룹 2의 평균 수면 시간 증가량이 그룹 1보다 평균적으로 **1.58시간 더 많았다**는 것을 의미합니다. 또한 95% 신뢰구간 `[-2.46, -0.70]`에 0이 포함되지 않으므로, 두 그룹 간 효과 차이가 유의함을 다시 한번 확인할 수 있습니다.
