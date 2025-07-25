## 기업호감도가 제품호감도에 미치는 영향 (단순선형회귀분석)
   
**분석 목표**: Buy 데이터를 이용하여 **기업호감도(co, 독립변수)**가 **제품호감도(prod, 종속변수)** 에 미치는 영향을 단순선형회귀모형으로 분석하고, 그 관계를 통계적으로 설명합니다.
    
### 1. 데이터 준비 및 전처리

```R
# 1. 데이터 불러오기
# buy.csv 파일을 데이터프레임으로 읽어옵니다.
buy <- utils::read.csv("D:/2025여름 특강/R/B_data/buy.csv")   

# 2. 데이터 전처리: 결측치 확인 및 제거
# 회귀분석은 결측치(NA)가 있으면 오류가 발생하므로, 분석에 사용할 변수에 결측치가 있는지 확인합니다.
# summary() 함수는 변수의 기초 통계량과 함께 NA의 개수를 보여줍니다.
summary(buy$co)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>    0.40    5.00    8.60   10.26   14.12   41.30 
summary(buy$prod)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#>   0.050   1.045   1.980   3.060   3.935  27.030       1 
# [결과 해석]: 'prod' 변수에 결측치가 1개 있는 것을 확인했습니다.

# stats::na.omit() 함수를 사용하여 결측치가 포함된 행 전체를 제거합니다.
# 이렇게 하면 분석의 일관성을 유지할 수 있습니다.
buy <- stats::na.omit(buy)

# 결측치가 잘 제거되었는지 다시 한번 확인합니다.
summary(buy$prod)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>   0.050   1.045   1.980   3.060   3.935  27.030 
# [결과 해석]: 'prod' 변수의 NA's 항목이 사라져 결측치가 성공적으로 제거되었음을 확인합니다.
```

### 2. 데이터 시각화를 통한 관계 파악

```R
# 3. 데이터 시각화: 변수 간 관계 파악
# 분석에 앞서, 독립변수(기업호감도)와 종속변수(제품호감도) 간의 관계를 산점도(Scatter Plot)로 시각화합니다.
# 이를 통해 두 변수 간에 선형적인 관계가 있는지 미리 파악할 수 있습니다.
ggplot2::ggplot(buy, ggplot2::aes(x = co, y = prod)) +
  # ggplot2::geom_point()는 점을 찍어 산점도를 그립니다. alpha=0.5는 점을 반투명하게 만들어 겹치는 부분을 파악하기 쉽게 합니다.
  ggplot2::geom_point(alpha = 0.5) +
  # ggplot2::geom_smooth()는 추세선을 추가합니다. method = "lm"은 선형회귀(Linear Model) 추세선을 의미합니다.
  ggplot2::geom_smooth(method = "lm", col = "blue", se = FALSE) +
  # ggplot2::labs()를 사용하여 그래프의 제목과 축의 이름을 설정합니다.
  ggplot2::labs(title = "기업호감도와 제품호감도의 관계",
                x = "기업호감도 (co)",
                y = "제품호감도 (prod)")
#> `geom_smooth()` using formula = 'y ~ x'
# [결과 해석]: 산점도에서 점들이 전반적으로 우상향하는 패턴을 보입니다. 이는 기업호감도(co)가 증가할수록 제품호감도(prod)도 증가하는 **양의 선형 관계**가 있음을 시사합니다.
```

### 3. 단순선형회귀모형 적합 및 결과 해석

```R
# 4. 단순선형회귀모형 적합
# stats::lm() 함수를 사용하여 선형회귀모형(Linear Model)을 만듭니다.
# '종속변수 ~ 독립변수' 형식의 수식(formula)을 사용합니다.
# data 인자에는 사용할 데이터프레임을 지정합니다.
fit_model <- stats::lm(prod ~ co, data = buy)

# 5. 회귀모형 결과 확인
# summary() 함수는 적합된 회귀모형의 상세한 분석 결과를 출력합니다.
# 이 결과를 통해 회귀계수, 유의성, 모델의 설명력 등을 파악할 수 있습니다.
summary(fit_model)

#> Call:
#> stats::lm(formula = prod ~ co, data = buy)
#>
#> Residuals:
#>     Min      1Q  Median      3Q     Max 
#> -7.1614 -1.2609 -0.4511  0.4337 22.3540 
#>
#> Coefficients:
#>             Estimate Std. Error t value Pr(>|t|)    
#> (Intercept)  0.16952    0.18231    0.93    0.353    
#> co           0.28166    0.01479   19.04   <2e-16 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#>
#> Residual standard error: 2.67 on 697 degrees of freedom
#> Multiple R-squared:  0.3422,	Adjusted R-squared:  0.3412 
#> F-statistic: 362.5 on 1 and 697 DF,  p-value: < 2.2e-16
```

#### 결과 해석

1.  **회귀식 (Coefficients)**:
    -   `(Intercept)` (절편)의 Estimate(추정치)는 0.16952입니다. 이는 기업호감도(co)가 0일 때 예측되는 제품호감도(prod)의 값입니다. 하지만 p-value가 0.353으로 0.05보다 크므로 통계적으로 유의미하지 않습니다.
    -   `co` (기울기)의 Estimate(추정치)는 0.28166입니다. 이는 **기업호감도(co)가 1단위 증가할 때, 제품호감도(prod)는 평균적으로 0.28166만큼 증가한다**는 것을 의미합니다.
    -   `co` 변수의 `Pr(>|t|)` (p-value)는 `< 2e-16`으로 0.05보다 매우 작으므로, **기업호감도는 제품호감도에 통계적으로 매우 유의미한 양(+)의 영향을 미친다**고 할 수 있습니다.

2.  **모형의 설명력 (R-squared)**:
    -   `Multiple R-squared: 0.3422`는 이 회귀모형이 **제품호감도(prod)의 전체 변동 중 약 34.22%를 기업호감도(co) 변수로 설명한다**는 의미입니다.

3.  **모형의 유의성 (F-statistic)**:
    -   `F-statistic: 362.5`와 `p-value: < 2.2e-16`는 회귀모형 자체가 통계적으로 유의미한지를 나타냅니다.
    -   p-value가 0.05보다 매우 작으므로, 이 **회귀모형은 통계적으로 유의미하다**고 할 수 있습니다. 즉, 기업호감도는 제품호감도를 예측하는 데 유용한 변수입니다.

### 4. 최종 결론

단순선형회귀분석 결과, 기업호감도(`co`)는 제품호감도(`prod`)에 통계적으로 유의미한 양(+)의 영향을 미치는 것으로 나타났습니다. 구체적으로 **기업호감도가 1단위 증가하면 제품호감도는 평균 0.282만큼 증가**하며, 이 회귀모형은 제품호감도 변동의 약 **34.2%**를 설명합니다.

따라서, **기업의 호감도를 높이는 활동이 제품에 대한 소비자 호감도를 높이는 데 긍정적인 영향을 준다**고 결론 내릴 수 있습니다.


### 5. 그림으로 확인하기

``` R
# 6. 회귀모형 진단
# 회귀분석 후에는 모델이 통계적 가정을 잘 만족하는지 반드시 확인해야 합니다.
# plot() 함수를 lm 객체에 적용하면 4가지 주요 진단 그래프를 자동으로 생성해 줍니다.
# graphics::par(mfrow = c(2, 2))는 그래픽 창을 2행 2열로 분할하여 4개의 그래프를 한 화면에 보기 위함입니다.
graphics::par(mfrow = c(2, 2))
graphics::plot(fit_model)
graphics::par(mfrow = c(1, 1)) # 그래프 창 분할을 원래대로 되돌립니다.
```

<img width="1190" height="879" alt="image" src="https://github.com/user-attachments/assets/7d9f4a16-47fe-4d82-a1d2-9eee97e022df" />


## 로그-로그 모형을 이용한 기업호감도와 제품호감도 관계 분석

**분석 목표**: 두 변수(기업호감도, 제품호감도)에 로그 변환을 적용하여, 변환된 변수 간의 관계가 선형에 더 적합한지 확인하고, 이를 바탕으로 새로운 회귀모형을 만들어 해석합니다. 로그 변환은 변수의 분포를 정규분포에 가깝게 만들거나, 변수 간의 비선형 관계를 선형 관계로 만들어 모형의 설명력을 높이는 데 자주 사용됩니다.

### 1. 로그 변환 및 시각화

```R
# 1. 로그 변환 변수 생성
# 기존 buy 데이터프레임에 log() 함수를 적용하여
# 기업호감도(co)와 제품호감도(prod)를 각각 로그 변환한 새로운 열(log_co, log_prod)을 추가합니다.
buy_log <- buy |>
  dplyr::mutate(log_co = log(co),
                log_prod = log(prod))

# 2. 변환된 변수의 관계 시각화
# 로그 변환된 두 변수 간의 관계가 선형에 더 가까워졌는지 산점도를 통해 확인합니다.
ggplot2::ggplot(buy_log, ggplot2::aes(x = log_co, y = log_prod)) +
  ggplot2::geom_point(alpha = 0.5) +
  ggplot2::geom_smooth(method = "lm", col = "red", se = FALSE) +
  ggplot2::labs(title = "로그 변환된 기업호감도와 제품호감도의 관계",
                x = "log(기업호감도)",
                y = "log(제품호감도)")
#> `geom_smooth()` using formula = 'y ~ x'
# [결과 해석]: 변환 전 산점도보다 점들이 추세선 주위에 더 밀집하여 분포하는 것을 볼 수 있습니다. 이는 로그 변환을 통해 두 변수 간의 선형 관계가 더 뚜렷해졌음을 의미합니다.
```

### 2. 로그-로그(Log-Log) 회귀모형 적합 및 결과 해석

```R
# 3. 로그-로그 회귀모형 적합
# 로그 변환된 변수들을 이용하여 새로운 선형회귀모형을 적합합니다.
# 독립변수와 종속변수 모두 로그 변환되었으므로, 이러한 모형을 로그-로그 모형(log-log model)이라고 합니다.
fit_log_model <- stats::lm(log_prod ~ log_co, data = buy_log)

# 4. 회귀모형 결과 확인
# summary() 함수를 사용하여 로그-로그 모형의 상세 결과를 출력합니다.
summary(fit_log_model)

#> Call:
#> stats::lm(formula = log_prod ~ log_co, data = buy_log)
#>
#> Residuals:
#>      Min       1Q   Median       3Q      Max 
#> -2.09899 -0.41668 -0.05765  0.38928  2.10244 
#>
#> Coefficients:
#>             Estimate Std. Error t value Pr(>|t|)    
#> (Intercept) -1.38552    0.07018  -19.74   <2e-16 ***
#> log_co       0.98566    0.03167   31.13   <2e-16 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#>
#> Residual standard error: 0.6375 on 697 degrees of freedom
#> Multiple R-squared:  0.5816,	Adjusted R-squared:  0.581 
#> F-statistic: 968.8 on 1 and 697 DF,  p-value: < 2.2e-16
```

#### 결과 해석 (로그-로그 모형)

로그-로그 모형에서 회귀계수는 **탄력성(elasticity)**을 의미하며, "독립변수가 1% 변할 때 종속변수가 몇 % 변하는가"로 해석합니다.

1.  **회귀식 (Coefficients)**:
    -   `(Intercept)` (절편): -1.38552. 이는 log(co)가 0일 때 (즉, co=1일 때)의 log(prod) 예측값으로, 실용적인 해석에는 큰 의미가 없을 수 있습니다.
    -   `log_co` (기울기): 0.98566. 이는 **"기업호감도(co)가 1% 증가할 때, 제품호감도(prod)는 평균적으로 약 0.986% 증가한다"**는 것을 의미합니다.
    -   `log_co`의 p-value가 `< 2e-16`으로 매우 작으므로, 이 관계는 통계적으로 매우 유의미합니다.

2.  **모형의 설명력 (R-squared)**:
    -   `Multiple R-squared: 0.5816`. 이는 로그-로그 모형이 **로그 변환된 제품호감도 변동의 약 58.16%를 설명한다**는 의미입니다.
    -   이는 **로그 변환 전 모델의 설명력(34.22%)보다 크게 향상된 수치**로, 로그-로그 모형이 데이터를 더 잘 설명하고 있음을 의미합니다.

3.  **모형의 유의성 (F-statistic)**:
    -   `F-statistic: 968.8`과 `p-value: < 2.2e-16`은 로그-로그 회귀모형 자체가 통계적으로 매우 유의미함을 보여줍니다.

### 3. 최종 결론

로그-로그 회귀분석 결과, 두 변수를 로그 변환함으로써 모형의 설명력(R-squared)이 34.2%에서 58.2%로 크게 향상되어 데이터에 더 적합한 모형을 얻을 수 있었습니다.

분석 결과, **기업호감도가 1% 증가할 때 제품호감도는 약 0.986% 증가**하는, 통계적으로 매우 유의미한 관계가 있음을 확인했습니다. 이는 기업호감도를 높이는 마케팅이나 경영 전략이 제품에 대한 소비자 호감도 증가에 거의 1:1에 가까운 비율로 긍정적인 영향을 미친다는 것을 시사합니다.

## 로그-로그 모델 해석 조심해야 하는거 아냐?
네, 아주 훌륭하고 중요한 질문입니다. 로그-로그 모형의 해석은 일반 선형 모형과 달라서 특별히 주의해야 합니다.

### 핵심: "단위(Unit)"가 아닌 "퍼센트(%)"로 해석합니다

가장 중요한 차이점은 이것입니다.

*   **일반 선형 모형 (`Y ~ X`)**: 독립변수 X가 **1 단위** 증가할 때, 종속변수 Y가 몇 **단위** 변하는가?
*   **로그-로그 모형 (`log(Y) ~ log(X)`)**: 독립변수 X가 **1%** 증가할 때, 종속변수 Y가 몇 **%** 변하는가?

이 관계를 **탄력성(Elasticity)**이라고 부릅니다. 즉, 로그-로그 모형에서 회귀계수는 **독립변수의 변화율(%)에 대한 종속변수 변화율(%)의 민감도**를 나타냅니다.

### 해석하기

사용자님의 분석 결과를 다시 보면...

```R
Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) -1.38552    0.07018  -19.74   <2e-16 ***
log_co       0.98566    0.03167   31.13   <2e-16 ***
```

여기서 `log_co`의 계수(Estimate)는 **0.98566** 입니다.

#### 잘못된 해석 (주의해야 할 부분)

> (X) "기업호감도가 1점(단위) 오르면, 제품호감도가 0.986점(단위) 오른다."

이것은 일반 선형 모형의 해석 방식이며, 로그-로그 모형에서는 완전히 틀린 해석입니다.

#### 올바른 해석 (탄력성 개념 적용)

> **(O) "기업호감도(co)가 1% 증가할 때, 제품호감도(prod)는 평균적으로 약 0.986% 증가한다."**

이것이 정확한 해석입니다. 즉, 기업호감도에 대한 제품호감도의 **탄력성은 약 0.986**입니다.

*   **예시 1**: 기업호감도가 10점에서 10.1점으로 **1%** 증가했다면, 제품호감도는 약 **0.986%** 증가할 것으로 예측할 수 있습니다.
*   **예시 2**: 기업호감도를 2배(즉, **100%**) 증가시키는 캠페인을 벌였다면, 제품호감도는 약 **98.6%** (0.986 * 100%) 증가할 것으로 기대할 수 있습니다.

### 왜 이렇게 해석해야 할까요? (수학적 배경)

회귀식은 `log(prod) = -1.386 + 0.986 * log(co)` 입니다.

미분 개념을 이용하면, `d(log(Y)) / d(log(X))`는 Y의 변화율 / X의 변화율, 즉 탄력성을 의미하며, 이 값이 바로 회귀계수 `β₁`가 됩니다.

로그의 성질 `log(Y) - log(Y₀) ≈ (Y - Y₀) / Y₀` (Y의 변화율)을 생각하면 이 관계를 직관적으로 이해할 수 있습니다.

### 다른 로그 변환 모형과의 해석 비교

혼동을 피하기 위해 다른 로그 변환 모형들의 해석법을 표로 정리해 드립니다. 이것을 참고하면 앞으로 어떤 모형을 쓰더라도 정확하게 해석할 수 있습니다.

| 모형 종류 | 회귀식 | β₁ 해석 방법 | 예시 해석 (β₁=0.986 가정) |
| :--- | :--- | :--- | :--- |
| **선형** (Level-Level) | `Y = β₀ + β₁X` | X가 1 **단위** 증가할 때, Y는 β₁ **단위** 증가 | X가 1점 오르면 Y는 0.986점 오른다. |
| **로그-로그** (Log-Log) | `log(Y) = β₀ + β₁log(X)` | X가 1**%** 증가할 때, Y는 β₁**%** 증가 **(탄력성)** | X가 1% 오르면 Y는 0.986% 오른다. |
| **로그-선형** (Log-Level) | `log(Y) = β₀ + β₁X` | X가 1 **단위** 증가할 때, Y는 (100 × β₁)**%** 증가 | X가 1점 오르면 Y는 98.6% 오른다. |
| **선형-로그** (Level-Log) | `Y = β₀ + β₁log(X)` | X가 1**%** 증가할 때, Y는 (β₁ / 100) **단위** 증가 | X가 1% 오르면 Y는 0.00986점 오른다. |

**결론적으로,** 로그-로그 모형은 변수 간의 관계를 **"단위"가 아닌 "비율(%)"**로 설명해주기 때문에 매우 강력한 도구입니다. 해석할 때 이 점만 명확히 인지한다면 데이터를 훨씬 풍부하게 이해할 수 있습니다.
