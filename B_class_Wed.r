# 특정 함수에 대한 도움말(documentation)을 보고 싶을 때 '?'를 함수 이름 앞에 붙여 실행합니다.    
# prop.test 함수에 대한 설명, 사용법, 인자 등을 보여줍니다.
?stats::prop.test

# prop.test 함수를 이용한 비율 검정 예시입니다.
# 20번의 시도(n=20) 중 11번 성공(x=11)한 경우, 이 비율이 0.5보다 크다고 할 수 있는지 검정합니다.
# H0(귀무가설): 실제 성공 비율은 0.5이다.
# H1(대립가설): 실제 성공 비율은 0.5보다 크다. (alternative = 'greater')
stats::prop.test(x=11, n=20, p=0.5, alternative = 'greater')

# 'buy.csv' 파일을 읽어와서 'buy'라는 이름의 데이터 프레임으로 저장합니다.
# 파일 경로는 R 환경에 맞게 수정해야 합니다. 역슬래시(\) 대신 슬래시(/) 사용에 유의하세요.
buy <- utils::read.csv('D:/2025여름 특강/R/B_data/buy.csv')
# 데이터 프레임의 첫 6개 행을 출력하여 데이터 구조를 간략하게 확인합니다.
utils::head(buy)
# 데이터 프레임의 구조(structure)를 자세히 보여줍니다. 각 열의 이름, 데이터 타입, 미리보기 값 등을 확인할 수 있습니다.
utils::str(buy)

# 'buy' 데이터를 'dplyr' 패키지의 파이프 연산자(|>)를 이용하여 처리합니다.
buy_summary = buy |>
  # 'year'(연도) 열을 기준으로 데이터를 그룹화합니다.
  dplyr::group_by(year) |>
  # 각 그룹별로 요약 통계량을 계산합니다.
  dplyr::summarise(num_n = dplyr::n(),      # dplyr::n()은 각 그룹의 전체 관측치(행) 수를 계산합니다.
                   num_buy = sum(buy))    # sum(buy)는 각 그룹에서 'buy' 열의 값이 1인 경우(구매한 경우)의 합계를 계산합니다.

# 'buy' 데이터셋을 시각화합니다.
buy|>
  # dplyr::mutate() 함수를 이용해 새로운 열 'buy2'를 추가합니다.
  # ifelse() 함수를 사용해 'buy'열의 값이 1이면 'Yes', 아니면 'No'를 할당합니다.
  dplyr::mutate(buy2 = ifelse(buy==1,'Yes', 'No'))|>
  # ggplot2를 이용한 시각화를 시작합니다. aes()는 데이터의 변수를 그래프의 시각적 요소(x축, y축, 색상 등)에 매핑합니다.
  ggplot2::ggplot(ggplot2::aes(x=buy2))+
  # geom_bar()는 막대 그래프를 그립니다. aes()를 통해 'year'별로 막대의 채우기 색상(fill)을 다르게 지정합니다.
  # as.factor(year)는 숫자형인 year를 범주형으로 취급하여 각각 다른 색을 할당하도록 합니다.
  ggplot2::geom_bar(ggplot2::aes(fill = as.factor(year)))

#--- 여러 집단 간 비율 검정 (연도별 구매 비율) ---
# H0(귀무가설): 연도별 구매 비율은 모두 동일하다.
# H1(대립가설): 적어도 한 해의 구매 비율은 다르다.
# 유의수준: 0.05

# prop.test 함수 도움말을 다시 확인합니다.
?stats::prop.test

# 위에서 생성한 요약 데이터를 확인합니다.
buy_summary
# 여러 집단(3개 연도) 간의 비율을 비교하기 위해 prop.test를 실행합니다.
# x 인자에는 각 그룹의 성공 횟수(구매 건수) 벡터를, n 인자에는 각 그룹의 전체 시도 횟수(전체 고객 수) 벡터를 전달합니다.
stats::prop.test(x = buy_summary$num_buy,
          n = buy_summary$num_n)
# 결과의 p-value가 0.05보다 작으면 귀무가설을 기각하고, 연도별 구매 비율에 차이가 있다고 결론 내릴 수 있습니다.


### 연령대별 구매비율의 차이가 있는가?
## H0(귀무가설): 연령대별 구매비율이 동일하다.
## H1(대립가설): 연령대별 구매비율이 다르다.
## 유의수준: 0.05

# 'age' 열에 어떤 값들이 있는지 확인합니다.
unique(buy$age)

# 연령대별로 데이터를 요약합니다.
buy_summary2 = buy |>
  # dplyr::mutate와 dplyr::case_when을 사용해 'age' 코드를 실제 연령대 문자열로 변환하여 'age2' 열을 생성합니다.
  dplyr::mutate(age2 = dplyr::case_when(
    age == 2 ~ '20대',
    age == 3 ~ '30대',
    age == 4 ~ '40대',
    age == 5 ~ '50대'))|>
  # 새로 만든 'age2' 열을 기준으로 그룹화합니다.
  dplyr::group_by(age2)|>
  # 각 연령대별로 전체 인원수(n_time)와 구매 인원수(n_buy)를 요약합니다.
  dplyr::summarise(n_time = dplyr::n(),
                   n_buy = sum(buy))

# 연령대별 구매 비율 차이를 검정합니다.
stats::prop.test(x = buy_summary2$n_buy,
          n = buy_summary2$n_time)
# p-value를 보고 귀무가설 기각 여부를 판단합니다.


## 교차분석 (Chi-squared Test)

# 2x3 형태의 행렬(matrix) 데이터를 생성합니다.
score<- matrix(c(73, 98, 79, 82, 58, 110),
       ncol=3, nrow=2, byrow=TRUE) # byrow=TRUE는 데이터를 행 우선으로 채웁니다.
score
# 행렬의 열 이름과 행 이름을 지정합니다.
colnames(score) <- c('Korean', 'Math', 'Eng')
rownames(score) <- c('Male', 'Female')

# 행렬을 교차분석에 사용하기 쉬운 table 형태로 변환합니다.
score <- as.table(score)

# ggplot2를 이용해 교차표를 시각화합니다.
# as.data.frame(score)를 통해 테이블을 데이터 프레임으로 변환해야 ggplot에서 사용할 수 있습니다.
ggplot2::ggplot(as.data.frame(score),
                # Var1(성별)을 x축, Freq(빈도)를 y축, Var2(과목)를 채우기 색상으로 매핑합니다.
                ggplot2::aes(x = Var1, y = Freq, fill = Var2)) + 
  # stat='identity'는 y축의 값을 데이터 값 그대로 사용하라는 의미입니다. (기본값은 빈도를 세는 'count')
  ggplot2::geom_bar(stat = 'identity')+
  # 그래프의 각 축과 범례의 제목을 설정합니다.
  ggplot2::labs(x = 'Gender',
                y = 'Frequency',
                fill = 'Subject')

# 카이제곱 검정(chi-squared test) 함수의 도움말을 봅니다.
?stats::chisq.test
# 생성한 교차표 'score'에 대해 카이제곱 검정을 수행합니다.
# H0: 성별과 선호 과목은 서로 관련이 없다(독립이다).
# H1: 성별과 선호 과목은 서로 관련이 있다(독립이 아니다).
stats::chisq.test(score)
# p-value가 유의수준(0.05)보다 작으면 두 변수 간에 통계적으로 유의한 관련성이 있다고 해석합니다.


# 연령과 특정 상품의 구매여부가 관련이 있는지?
# 먼저 분석에 용이하도록 'age'와 'buy' 변수를 변환합니다.
buy_new = buy |>
  dplyr::mutate(
    age2 = dplyr::case_when(
      age == 2 ~ '20대',
      age == 3 ~ '30대',
      age == 4 ~ '40대',
      age == 5 ~ '50대'),
    buy2 = ifelse(buy==1,'Yes', 'No'))

# table() 함수를 이용해 연령대('age2')와 구매여부('buy2')에 대한 교차표(분할표)를 생성합니다.
table_buy = table(buy_new$age2, buy_new$buy2)

# vcd::mosaic() 함수를 이용해 모자이크 플롯을 그립니다. 모자이크 플롯은 교차표를 시각화하는 좋은 방법입니다.
# 각 사각형의 넓이는 해당 범주의 빈도에 비례합니다.
# highlighting 옵션으로 특정 변수를 강조하고, highlighting_fill로 색상을 지정할 수 있습니다.
vcd::mosaic(~ age2 + buy2, data = buy_new,
            highlighting = 'age2',
            highlighting_fill = c('lightblue', 'pink', 'lightgreen', 'tan')) # 색상 4개 지정

# 교차표에 대해 카이제곱 검정을 수행합니다.
# H0: 연령대와 구매여부는 관련이 없다.
# H1: 연령대와 구매여부는 관련이 있다.
stats::chisq.test(table_buy)


### 연령대(age)와 교육수준(edu) 사이에 관련성이 있는지?
# 1. dplyr::mutate로 두 변수를 의미있는 문자열로 변환하여 새로운 데이터셋 만들기
buy_new2 = buy |>
  dplyr::mutate(
    age2 = dplyr::case_when(
      age == 2 ~ '20대',
      age == 3 ~ '30대',
      age == 4 ~ '40대',
      age == 5 ~ '50대'),
    edu2 = dplyr::case_when(
      edu == 1 ~ '초졸',
      edu == 2 ~ '중졸',
      edu == 3 ~ '고졸',
      edu == 4 ~ '대졸',
      edu == 5 ~ '대학원졸'))
# 2. 교차표를 만들어서 table2_buy로 저장하기
table2_buy = table(buy_new2$age2, buy_new2$edu2)
table2_buy
# 3. 모자이크 플롯 그려보기
vcd::mosaic(~ age2 + edu2, data = buy_new2,
            highlighting = 'age2')
# 4. 가설을 세우고 검정해보기
# H0(귀무가설): 연령대와 교육수준은 관련이 없다 (독립이다).
# H1(대립가설): 연령대와 교육수준은 관련이 있다.
stats::chisq.test(table2_buy)


### T-검정 (T-test)
# 제품호감도(prod)를 두 그룹(30대 미만 vs 30대 이상)으로 나누어 비교
# 'buy' 데이터셋에서 'age'가 3 미만이면 '30대 미만', 아니면 '30대 이상'으로 분류하는 'age_30' 열 생성
buy_new3 = buy |>
  dplyr::mutate(age_30 = ifelse(age<3, '30대 미만', '30대 이상'))

# table() 함수로 각 그룹의 샘플 크기를 확인합니다.
table(buy_new3$age_30)

# 상자 그림(boxplot)으로 두 그룹의 제품 호감도 분포를 시각적으로 비교합니다.
ggplot2::ggplot(buy_new3, ggplot2::aes(x = age_30, y = prod)) +
  ggplot2::geom_boxplot()

# 히스토그램으로 각 그룹의 제품 호감도 분포 형태를 확인합니다.
# facet_grid()는 그룹별로 그래프를 따로 그려줍니다.
ggplot2::ggplot(buy_new3, ggplot2::aes(x = prod)) +
  ggplot2::geom_histogram()+
  ggplot2::facet_grid(age_30 ~ .)

# --- T-검정의 가정 확인 ---
# 가정 1: 정규성 (Normality)
# Shapiro-Wilk 검정을 사용하여 데이터가 정규분포를 따르는지 확인합니다.
# H0(귀무가설): 데이터는 정규분포를 따른다.
# H1(대립가설): 데이터는 정규분포를 따르지 않는다.
# p-value가 0.05보다 작으면 정규성 가정을 만족하지 못한다고 봅니다.
stats::shapiro.test(buy_new3$prod[buy_new3$age_30 == '30대 미만'])  
stats::shapiro.test(buy_new3$prod[buy_new3$age_30 == '30대 이상']) 

# 가정 2: 등분산성 (Equality of variances)
# F-검정(var.test)을 사용하여 두 그룹의 분산이 같은지 확인합니다.
# H0(귀무가설): 두 그룹의 분산은 같다.
# H1(대립가설): 두 그룹의 분산은 다르다.
# p-value가 0.05보다 작으면 등분산성 가정을 만족하지 못한다고 봅니다.
stats::var.test(prod ~ age_30, data = buy_new3)

# --- T-검정 수행 ---
# H0(귀무가설): 30대 미만의 제품선호도 평균과 30대 이상의 제품선호도 평균은 같다.
# H1(대립가설): 30대 미만의 제품선호도 평균과 30대 이상의 제품선호도 평균은 다르다.
# 유의 수준 = 0.05

# t.test() 함수로 독립표본 t-검정을 수행합니다.
# var.equal = FALSE는 등분산성 가정이 만족되지 않았을 때 사용하는 Welch's t-test를 수행합니다. (기본값)
# alternative = 'two.sided'는 양측검정을 의미합니다. (평균이 같지 않다)
# conf.level은 신뢰수준을 의미합니다. (1 - 유의수준)
stats::t.test(prod ~ age_30, data = buy_new3,
       alternative = 'two.sided',
       var.equal = FALSE,
       conf.level = 0.95)

# 만약 등분산성 가정이 만족되었다면 var.equal = TRUE로 설정하여 Student's t-test를 수행합니다.
stats::t.test(prod ~ age_30, data = buy_new3,
       alternative = 'two.sided',
       var.equal = TRUE,
       conf.level = 0.95)


## 수입 비교 (30대 이상 vs 30대 미만)
# 'income'과 'age' 변수를 사용하여 위와 동일한 분석 과정을 반복합니다.
# 1. 데이터 시각화 (히스토그램, 박스플롯)
table(buy_new3$age_30)
ggplot2::ggplot(buy_new3, ggplot2::aes(x=income))+
  ggplot2::geom_histogram()+
  ggplot2::facet_grid(age_30 ~ .)
ggplot2::ggplot(buy_new3, ggplot2::aes(x=age_30, y=income))+
  ggplot2::geom_boxplot()

# 2. 정규성 검정
stats::shapiro.test(buy_new3$income[buy_new3$age_30 == '30대 이상'])
stats::shapiro.test(buy_new3$income[buy_new3$age_30 == '30대 미만'])
# p-value가 매우 작으므로 두 그룹 모두 정규분포를 따르지 않습니다.
# 원칙적으로는 비모수적 방법(예: Wilcoxon rank-sum test)을 사용해야 하지만,
# 샘플 크기가 충분히 크면 중심극한정리에 의해 t-검정을 사용하기도 합니다.

# 3. 등분산성 검정
stats::var.test(income ~ age_30, data = buy_new3)
# p-value가 0.05보다 작으므로 등분산성 가정을 만족하지 않습니다.

# 4. T-검정
# H0: 30대 미만의 수입 평균과 30대 이상의 수입 평균은 같다.
# H1: 30대 미만의 수입 평균과 30대 이상의 수입 평균은 다르다.
# 유의수준: 0.05
stats::t.test(income ~ age_30, data = buy_new3,
       alternative = 'two.sided',
       var.equal = FALSE, # 등분산 가정이 깨졌으므로 FALSE
       conf.level = 0.95)

# 대응표본 T-검정 (Paired T-test)

# R 내장 데이터셋 'sleep'을 불러옵니다.
sleep
# 데이터 구조를 확인합니다. 10명의 환자에게 두 종류의 수면제(group 1, 2)를 투여하고 수면 시간 증가량(extra)을 측정한 데이터입니다.
utils::str(sleep)
?sleep

# 동일한 사람에게서 반복 측정한 데이터이므로 대응표본 T-검정을 사용합니다.
# 데이터를 그룹과 ID 순으로 정렬하여 구조를 명확히 합니다.
sleep1 = sleep[order(sleep$group, sleep$ID),]

# H0: 두 수면제(group 1, group 2)의 평균 수면 증가 효과는 동일하다.
# H1: 두 수면제(group 1, group 2)의 평균 수면 증가 효과는 다르다.
# 유의수준 0.05
# paired=TRUE 옵션을 주어 대응표본 T-검정을 수행합니다.
stats::t.test(extra ~ group, data = sleep1, paired=TRUE)

# 데이터를 'wide' 형태로 변환하여 T-검정을 수행할 수도 있습니다.
sleep2 = data.frame(ID = 1:10,
           group1 = sleep$extra[1:10], # 첫 10개 행 (group 1)
           group2 = sleep$extra[11:20]) # 다음 10개 행 (group 2)

# 두 변수를 직접 t.test에 넣어 대응표본 검정을 수행합니다.
stats::t.test(sleep2$group1, sleep2$group2, paired=TRUE)


### 분산분석 (ANOVA, Analysis of Variance)
# 세 개 이상의 집단 간의 평균을 비교할 때 사용합니다.
# H0(귀무가설): 모든 연령 그룹의 제품 호감도 평균은 같다.
# H1(대립가설): 적어도 하나의 연령 그룹은 다른 제품 호감도 평균을 가진다.

# 각 연령 그룹의 샘플 크기를 확인합니다.
table(buy_new2$age2)

# 상자 그림으로 네 그룹의 제품 호감도 분포를 시각적으로 비교합니다.
ggplot2::ggplot(buy_new2, ggplot2::aes(x = age2, y = prod))+
  ggplot2::geom_boxplot()

# 히스토그램으로 각 그룹의 분포 형태를 확인합니다.
ggplot2::ggplot(buy_new2, ggplot2::aes(x=prod))+
  ggplot2::geom_histogram()+
  ggplot2::facet_grid(age2 ~.)

# --- ANOVA의 가정 확인 ---
# 가정: 등분산성 (Levene's test 사용)
?lawstat::levene.test
# H0: 모든 그룹의 분산은 같다.
# H1: 적어도 한 그룹의 분산은 다르다.
# levene.test(종속변수, 그룹변수) 형식으로 사용합니다.
lawstat::levene.test(buy_new2$prod, buy_new2$age2)
# p-value가 0.05보다 크므로 등분산성 가정을 만족합니다.

# --- 분산분석 수행 ---
# H0: 연령대별 제품선호도의 평균이 같다.
# H1: H0이 아니다 (적어도 한 그룹의 평균은 다르다).
# 유의수준 0.05

# aov() 함수를 이용해 분산분석 모델을 생성합니다.
aov_res<-stats::aov(prod ~ age2, data = buy_new2)
# summary() 함수로 분산분석표(ANOVA table)를 확인합니다.
summary(aov_res)
# Pr(>F) 값이 p-value입니다. 0.05보다 작으므로 연령대별 제품선호도 평균에 유의한 차이가 있다고 결론내립니다.

# --- 사후분석 (Post-hoc Analysis) ---
# ANOVA 결과가 유의할 때, 구체적으로 '어떤' 그룹들 간에 차이가 있는지 알아보기 위해 수행합니다.
# Tukey's Honest Significant Difference (HSD) test
stats::TukeyHSD(aov_res, conf.level = 0.95)
# 결과표에서 'p adj' (조정된 p-value)가 0.05보다 작은 쌍들이 통계적으로 유의한 평균 차이를 보입니다.

# Scheffe's test (Scheffe 검정)
# agricolae 패키지의 scheffe.test 함수를 사용합니다.
agricolae::scheffe.test(aov_res,
                        'age2', # 비교할 그룹 변수명
                        alpha = 0.05, # 유의수준
                        console = TRUE) # 결과를 콘솔에 출력
# 결과에서 같은 문자(a, b, c...)를 공유하는 그룹들은 평균 차이가 없음을 의미합니다.

# 만약 등분산성 가정이 만족되지 않을 경우 Welch's ANOVA를 사용합니다.
# oneway.test() 함수를 사용하며, var.equal = FALSE로 설정합니다.
lawstat::levene.test(buy_new2$income, buy_new2$edu2) # 교육수준별 수입의 등분산성 검정
stats::oneway.test(income ~ edu2, data = buy_new2, var.equal = FALSE)

# 교육수준별 수입 평균 차이에 대한 일반적인 ANOVA (참고용)
aov_res2<-stats::aov(income ~ edu2, data = buy_new2)
summary(aov_res2)
stats::TukeyHSD(aov_res2, conf.level = 0.95)


### 회귀분석 (Regression Analysis)
# 기업호감도(독립변수, x, co)가 제품호감도(종속변수, y, prod)에 미치는 영향을 분석합니다.
# 먼저 각 변수의 요약 통계를 확인합니다. NA(결측치)가 있는지 확인합니다.
summary(buy$co)
summary(buy$prod)
# na.omit() 함수로 결측치가 있는 행을 모두 제거합니다.
buy<-stats::na.omit(buy)
# 결측치 제거 후 다시 확인합니다.
summary(buy$co)
summary(buy$prod)

# 산점도를 그려 두 변수 간의 관계를 시각적으로 확인합니다.
ggplot2::ggplot(buy, ggplot2::aes(x=co, y=prod))+
  ggplot2::geom_point()

# lm() 함수(linear model)로 단순 선형 회귀 모델을 적합(fit)시킵니다.
fit <- stats::lm(prod ~ co, data = buy)
# summary()로 회귀분석 결과를 확인합니다. (계수, p-value, R-squared 등)
summary(fit)

# 회귀 진단(Regression Diagnostics)을 위한 4개의 플롯을 그립니다.
# 이 플롯들은 선형성, 등분산성, 정규성, 이상치 존재 여부를 시각적으로 검토하는 데 도움을 줍니다.
graphics::par(mfrow=c(2,2)) # 2x2로 화면 분할
graphics::plot(fit)

# 진단 플롯 결과, 잔차의 패턴이 보이고 정규성을 만족하지 못하는 것으로 보입니다.
# 변수 변환(log transformation)을 시도합니다.
buy$lprod  = log(buy$prod)
buy$lco  = log(buy$co)

# 변환된 변수로 다시 산점도를 그립니다.
ggplot2::ggplot(buy, ggplot2::aes(x=lco, y=lprod))+
  ggplot2::geom_point()

# 변환된 변수로 다시 회귀 모델을 적합합니다.
fit2 <- stats::lm(lprod ~ lco, data = buy)
summary(fit2) # R-squared가 크게 개선되었음을 확인합니다.

# 변환된 모델에 대한 진단 플롯을 다시 확인합니다.
graphics::par(mfrow=c(2,2))
plot(fit2) # 이전보다 가정을 더 잘 만족하는 것으로 보입니다.

# coef()는 회귀 계수(coefficients)만 추출합니다.
stats::coef(fit2)
# confint()는 각 회귀 계수에 대한 신뢰구간을 계산합니다.
stats::confint(fit2)

# 'age' 변수의 클래스(타입)를 확인합니다.
class(buy$age)

### 다중 회귀분석 (Multiple Regression)
# 여러 개의 독립변수를 사용하여 종속변수를 예측합니다.
fit2 <- stats::lm(lprod ~ lco, data = buy) # 기존 모델
# 'age' 변수를 범주형(factor)으로 추가하여 새로운 모델을 만듭니다.
fit3 <- stats::lm(lprod ~ lco + factor(age), data = buy)
# anova() 함수로 두 모델(fit2, fit3)을 비교합니다.
# 이는 'age' 변수가 모델의 설명력을 유의하게 향상시키는지를 검정합니다.
# p-value가 작으면 더 복잡한 모델(fit3)이 유의하게 더 낫다고 해석합니다.
stats::anova(fit2, fit3)

# fit3 모델의 상세 결과를 봅니다.
summary(fit3)

#--- 변수 선택법 (Variable Selection) ---
# 모든 변수를 포함한 전체 모델(full model)을 만듭니다.
fit4 <- stats::lm(lprod ~ lco + factor(buy) +factor(age) + 
             factor(edu) + income + exp + ad, data = buy)
# MASS::stepAIC() 함수를 이용해 단계적 선택법(stepwise selection)으로 최적의 변수 조합을 찾습니다.
# direction='both'는 전진선택법과 후진제거법을 모두 사용합니다.
step <- MASS::stepAIC(fit4, direction ='both')
# 최종적으로 선택된 모델의 변수 제거/추가 과정을 보여줍니다.
step$anova
# 최종 선택된 모델은 step 객체 자체에 저장되어 있습니다. summary(step)으로 확인 가능합니다.
summary(step)
