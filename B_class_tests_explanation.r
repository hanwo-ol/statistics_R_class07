# 수업 시간에 실습한 각종 검정들의 해석 방법을 써뒀습니다.
# 추가 설명 요청: 11015khw@gmail.com

######R을 이용한 자료분석#######


##2.1 비율검정 ####
# 기본 틀 
prop.test(x,          # 성공횟수
          n,          # 시행횟수
          p = NULL,   # 모집단의 비율
          alternative = c("two.sided"), # 양측검정
          conf.level = 0.95,            # 95% 신뢰구간
          correct = TRUE)               # 연속성 수정

# 예제 1 미국 메이저 리그의 특정 팀이 올해 경기의 절반 이상을 이길 수 있을까?
n = 20
x = 11 # 절반보다 많이, 관심있는 애가 대립가설로 들어가는 것...
prop.test(x, n, p = 0.5,
          alternative = 'greater')
?prop.test
# n = 20: 전체 경기 수를 20으로 설정합니다.
# x = 11: 이긴 경기 수를 11로 설정합니다. 이는 전체 경기의 절반(10)보다 많습니다.
# prop.test(x, n, p = 0.5, alternative = 'greater'): prop.test() 함수를 사용하여 가설 검정을 수행합니다.
# x: 이긴 경기 수 (11)
# n: 전체 경기 수 (20)
# p = 0.5: 귀무 가설에서 가정하는 승률 (50%)
# alternative = 'greater': 대립 가설의 방향. 여기서는 'greater'로 설정되어 팀이 경기의 절반 이상을 이길 것이라는 가설을 검정합니다.
# 즉, 이 코드는 다음과 같은 가설을 검정합니다.

## 귀무 가설 (H0): 팀의 승률은 50%이다.
## 대립 가설 (H1): 팀의 승률은 50%보다 높다.

## 결과 해석

## X-squared = 0.05, df = 1, p-value = 0.4115:
  
## X-squared는 카이제곱 검정 통계량입니다.
## df = 1은 자유도를 나타냅니다.

## p-value = 0.4115는 p-값으로, 귀무 가설이 참일 때 관찰된 결과 또는 더 극단적인 결과가 나타날 확률을 의미합니다. 
## 여기서 p-값이 0.4115로 유의 수준 0.05보다 크므로 귀무 가설을 기각할 수 없습니다. 
## 즉, 이 데이터만으로는 팀의 승률이 50%보다 높다고 주장할 충분한 증거가 없습니다.

## alternative hypothesis: true p is greater than 0.5:
### 위는 대립 가설을 나타냅니다. 즉, 검정은 팀의 실제 승률(p)이 0.5(50%)보다 큰지 확인하고 있습니다.

## 95 percent confidence interval: 0.349615 1.000000:
### 팀의 실제 승률에 대한 95% 신뢰 구간은 34.96%에서 100% 사이입니다. 
### 즉, 이 구간에 실제 승률이 포함될 확률이 95%라는 의미입니다.

## sample estimates: p = 0.55:
### 표본에서 추정된 승률은 55%입니다.


# 예제 2 BuyData를 이용하여 년도에 따라 특정 상품의 구매 비율이 다른지 알아보자
#자료 읽기 및 전처리
df <-read.csv("buy.csv",header= TRUE)
df <-na.omit(df) #결측치제거
str(df)

# 연도별 총 데이터 갯수
# tapply() 함수를 사용하여 연도별(df$year) 데이터 개수를 계산하고 nyears에 저장 
nyears <-tapply(df$year,df$year,length) 
nyears

# 연도별 구매 횟수
# tapply() 함수를 사용하여 연도별(df$year) 구매 횟수(df$buy)의 합계를 계산하고 ntimes에 저장
ntimes <-tapply(df$buy, df$year, sum)
ntimes


# 예제 2-1 EDA
library(ggplot2)
# 년도별 구매 횟수 막대그래프
ggplot(df, aes(buy)) + 
  geom_bar(position= position_dodge(), aes(fill = as.factor(year)))+ 
  labs(fill = 'Year')

# 예제 2-2 비율의 동일성 검정
prop.test(ntimes, nyears)
# 3-sample test for equality of proportions without continuity correction: 
# data: ntimes out of nyears
## nyears 중 ntimes를 사용하여 검정을 수행했음을 나타냅니다.

# X-squared = 2.5498, df = 2, p-value = 0.2795
## 카이제곱 검정 통계량은 2.5498, 자유도는 2, p-값은 0.2795
## p-값이 0.05보다 크므로 귀무 가설을 기각할 수 없습니다. 
## 즉, 연도별 구매 비율에 유의미한 차이가 있다고 보기 어렵습니다.

# alternative hypothesis: two.sided
## 양측 검정을 수행했음을 나타냅니다. 즉, 구매 비율이 증가했는지 감소했는지에 대한 특정 방향을 가정하지 않았습니다.

# sample estimates: prop 1 = 0.2284483, prop 2 = 0.2926829, prop 3 = 0.2624434:
## 각 연도별 구매 비율의 추정값입니다.

# 교수님 방식(이지만 코드는 다를 수 있습니다.)
library(dplyr)

# 자료 읽기 및 전처리
df <- read.csv("buy.csv", header = TRUE) |> 
  na.omit() # 결측치 제거

# 연도별 총 데이터 개수 및 구매 횟수 계산
df_summary <- df |> 
  group_by(year) |> 
  summarise(nyears = n(), 
            ntimes = sum(buy))

# 연도별 구매 횟수 막대그래프
library(ggplot2)
ggplot(df, aes(buy)) +
  geom_bar(position = position_dodge(), aes(fill = as.factor(year))) +
  labs(fill = 'Year')

# 비율의 동일성 검정
prop.test(df_summary$ntimes, df_summary$nyears)
  

# 실습: 연령대별 구매
# 데이터 셋이 어떻게 생겨먹었는지 확인
# 자료 읽기 및 전처리
df <- read.csv("buy.csv",header= TRUE)
df <- na.omit(df) #결측치제거
str(df)
str(df)
# 연령별 총 데이터 개수 계산
n_age <- tapply(df$age, df$age, length)
n_age

# 연령별 구매 횟수 계산
n_buy_age <- tapply(df$buy, df$age, sum)
n_buy_age

# 비율의 동일성 검정 수행 
prop.test(n_buy_age, n_age)


# 연령대의 구매 비율이 같을까?
stats::prop.test(x = buy_summary2$n_buy,
                 n = buy_summary2$n_time)

# [결과 해석]
#
# 4-sample test for equality of proportions without continuity correction
# -> 4개 표본(샘플)에 대한 비율 동일성 검정을 의미합니다. 
#    여기서는 4개의 연령대(20대, 30대, 40대, 50대)의 구매 비율이 같은지를 검정합니다.
#    'without continuity correction'은 연속성 보정 없이 검정을 수행했다는 기술적인 정보입니다.

# data:  buy_summary2$n_buy out of buy_summary2$n_time
# -> 검정에 사용된 데이터가 'buy_summary2' 데이터프레임의 'n_time'(전체 인원) 중 'n_buy'(구매 인원)임을 명시합니다.

# X-squared = 24.092, df = 3, p-value = 2.39e-05
# -> X-squared: 카이제곱 검정 통계량으로, 관측된 값과 기대값의 차이를 나타냅니다. 클수록 차이가 크다는 의미입니다.
# -> df: 자유도(degrees of freedom)로, (그룹의 수 - 1) 입니다. 여기서는 (4개 연령대 - 1) = 3 입니다.
# -> p-value: 검정 결과의 핵심으로, "만약 모든 연령대의 실제 구매 비율이 같다면(귀무가설이 맞다면), 
#    지금과 같은 큰 차이가 우연히 나타날 확률"을 의미합니다.
#    2.39e-05는 0.0000239로, 일반적인 유의수준 0.05보다 매우 작습니다.

# alternative hypothesis: two.sided
# -> 대립가설은 'two.sided'(양측검정)로, "적어도 하나의 연령대 구매 비율은 다르다"는 것을 의미합니다.

# sample estimates:
#    prop 1    prop 2    prop 3    prop 4 
# 0.3842365 0.2105263 0.1878788 0.2727273 
# -> 각 그룹(표본)별 실제 구매 비율을 보여줍니다.
#    - prop 1 (20대): 약 38.4%
#    - prop 2 (30대): 약 21.1%
#    - prop 3 (40대): 약 18.8%
#    - prop 4 (50대): 약 27.3%

# [최종 결론]
# p-value(0.0000239)가 유의수준(0.05)보다 매우 작으므로, 귀무가설("연령대별 구매 비율이 동일하다")을 기각합니다.
# 따라서 "연령대별 구매 비율에는 통계적으로 유의미한 차이가 있다"고 결론 내릴 수 있습니다.




# 연령별 구매 비율 점 그래프 생성
ggplot(data.frame(age = as.numeric(names(n_buy_age)), 
                  prop = n_buy_age / n_age), 
       aes(x = age, y = prop)) +
  geom_line() + # 더 적절한 시각화 방안을 찾을수도 있을 듯 합니다.
  labs(title = "연령별 구매 비율",
       x = "연령",
       y = "구매 비율")

# dplyr 이용한 실습 방식: 교수님과 코드가 다를 수 있습니다. 
library(dplyr)
library(ggplot2)

# 데이터 읽기 및 전처리
df <- read.csv("buy.csv", header = TRUE) |>
  na.omit() # 결측치 제거

# 연령별 구매 비율 계산
df_summary <- df |>
  group_by(age) |> 
  summarise(
    total = n(),
    buy_count = sum(buy),
    prop = buy_count / total
  )

# 비율의 동일성 검정 수행
prop.test(df_summary$buy_count, df_summary$total)

# 연령별 구매 비율 점 그래프 생성
ggplot(df_summary, aes(x = age, y = prop)) +
  geom_line() +
  labs(title = "연령별 구매 비율",
       x = "연령",
       y = "구매 비율")






##2.2 교차분석 ####
# 기본 틀
chisq.test(x,              # 분할표
           correct = TRUE) # 연속성 수정

# 예제 1: 남학생과 여학생의 성별에 따라 과목에 대한 선호도가 다른가?
## 각 행은 남학생과 여학생을 나타내고, 각 열은 국어, 수학, 영어 과목에 대한 선호도를 나타내는 데이터를 생성
x <-matrix(c(73, 98, 79, 82, 58, 110),
           nrow = 2, ncol= 3, byrow = TRUE)

## 열, 행 이름 지정해주기
colnames(x) <-c("Korean","Math","Eng")
rownames(x) <-c('Male', 'Female')

## 테이블 화
x <-as.table(x)
x

# 1-1: EDA
ggplot(as.data.frame(x), aes(x = Var1, y= Freq, fill = Var2)) + 
  geom_bar(stat = 'identity', position = position_dodge()) + 
  xlab("Gender") + labs(fill = "Subject")

# 1-2: 두 특성의 독립성 검정
# H0 :남학생과 여학생의 과목 선호도는 동일하다.
# H1 :남학생과 여학생의 과목 선호도는 다르다.
chisq.test(x)

## 결과 해석
# Pearson's Chi-squared test: 
## 피어슨 카이제곱 검정을 수행했음을 나타냅니다.

# data: x
## 테이블 x를 사용하여 검정을 수행했음을 나타냅니다.

# X-squared = 15.864, df = 2, p-value = 0.0003591
## 카이제곱 검정 통계량은 15.864, 자유도는 2, p-값은 0.0003591
## p-값이 0.05보다 작으므로 귀무 가설을 기각
## 남학생과 여학생의 과목 선호도는 통계적으로 유의미한 차이가 있다고 결론 내릴 수 있습니다.

# 예제 2  BuyData를 이용하여 연령과 특정 상품의 구매 여부가 관계가 있는지 알아보자.
# 2-0 자료읽기
df <-read.csv("buy.csv",header= TRUE)
df <-na.omit(df) #결측치생략

# 연령별 구매 횟수에 대한 분할표
x <-table(df$age, df$buy)
x

# 2-1 EDA
# 연령대와 구매 여부에 따른 모자이크 플랏
vcd::mosaic(~ age + buy, data =df,
            highlighting = 'age', highlighting_fill= c("lightblue", "pink"))
## vcd 패키지의 mosaic() 함수를 사용하여 모자이크 플롯을 생성합니다.
## ~ age + buy: age와 buy 변수 간의 관계를 분석합니다.
## highlighting = 'age': age 변수를 강조 표시합니다.


# 2-2 독립성 검정
# H0 : 연령과 특정 상품의 구매 여부 사이에는 관계가 없다.
# H1 : 남학생과 여학생의 과목 선호도는 다르다.
chisq.test(x)

# 결과 해석
# X-squared = 23.9, df = 3, p-value = 2.621e-05
## 카이제곱 검정 통계량은 23.9, 자유도는 3, p-값은 2.621e-05 (0.00002621)
## p-값이 0.05보다 작으므로 귀무 가설을 기각
## 연령과 특정 상품의 구매 여부 사이에는 통계적으로 유의미한 관계가 있다고 결론 내릴 수 있음

# 번외: chisq.test와 prop.test 둘 다 카이제곱 머시기 아니야?
## 1. 검정 대상:
  
##  prop.test: 비율의 차이를 검정합니다. 
## 주로 두 집단의 비율을 비교하거나, 한 집단의 비율이 특정 값과 같은지 검정할 때 사용합니다. 
## 예를 들어, 남녀 간의 특정 질병 발병률 차이, 신약 투여 후 치료율 변화 등을 분석할 수 있습니다.

## chisq.test: "범주형 변수 간"의 연관성을 검정합니다. 
## 두 개 이상의 집단에서 두 개 이상의 범주를 가지는 변수들을 비교할 때 사용합니다. 
## 예를 들어, 성별과 선호하는 정당, 혈액형과 특정 질병의 관계 등을 분석할 수 있습니다.

## 2. 입력 데이터 형식:
  
##  prop.test: 성공 횟수와 시행 횟수를 입력합니다. 
 ## 예를 들어, prop.test(x = c(20, 30), n = c(100, 100))은 각각 100명 중 20명, 30명이 성공한 경우를 비교합니다.
## chisq.test: 범주형 변수의 빈도를 나타내는 분할표 (contingency table) 또는 행렬 형태로 입력합니다. 
 ## 예를 들어, chisq.test(matrix(c(20, 80, 30, 70), nrow = 2))는 2x2 분할표를 입력하는 것입니다.

# 실습 
library(dplyr)
library(ggplot2)
library(tibble)
library(tidyr)

# 데이터 불러오기 및 결측치 제거
df <- read.csv("buy.csv") |>
  na.omit()

# 나이와 교육 수준 변수를 factor로 변환 (필요한 경우)
df <- df |>
  mutate(age = factor(age), edu = factor(edu))

# 교차 분석표 생성
crosstab <- df |>
  count(age, edu) |>
  pivot_wider(names_from = edu, values_from = n, values_fill = 0)

# ggplot2를 사용한 시각화
ggplot(crosstab |> pivot_longer(-age, names_to = "edu", values_to = "count"), 
       aes(x = age, y = count, fill = edu)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "나이와 교육 수준에 따른 분포", x = "나이", y = "빈도", fill = "교육 수준") +
  theme_bw()

# 카이제곱 검정 수행
## 카이제곱 검정은 나이와 교육 수준 간의 연관성이 있는지 통계적으로 검정하는 방법
chisq_test <- chisq.test(df$age, df$edu)
# X-squared = 14.794: 카이제곱 통계량 값입니다. 
## 이 값이 클수록 두 변수 간의 관측 빈도와 기대 빈도의 차이가 크다는 것을 의미

# df = 12: 자유도입니다. 
## (나이 그룹 수 - 1) * (교육 수준 수 - 1) 로 계산됩니다. (4-1) * (5-1) = 3 * 4 =12

# p-value (0.2529)가 유의 수준 0.05보다 크므로, 
## 나이와 교육 수준 간에 통계적으로 유의미한 연관성이 있다는 증거가 충분하지 않습니다. 
## 즉, 이 데이터셋에서는 나이가 교육 수준에 영향을 미치지 않는다고 볼 수 있습니다.

print(crosstab)
print(chisq_test)

df




##2.3 T검정####
# 기본틀
t.test(formula, data = ...,
       paired = FALSE,            # 대응표본
       alternative = "two.sided", # 양측검정
       var.equal = FALSE,         # 분산 동질성
       conf.level = 0.95)         # 95% 신뢰구간

# formula 작성법

## 독립표본, y : 수치형, x : 범주형
# y ~ x

## 대응표본 y : 수치형, x : 범주형
# y ~ x, paired = T

## 대응표본, y1, y2 : 수치형
# y1, y2, paired = T

# 단일표본, y : 수치형, H0 : mu = 3
# y, mu = 3

# 예제 1 Buy Data를 이용하여 연령 그룹(30대 미만/30대 이상)에 따라 제품호감도의 평균이 다른지 알아보자.
# 독립변수: yage 연령그룹(Young, Old)
# 종속변수: prod 제품호감도

# 자료 읽기
df <- read.csv("buy.csv", header = TRUE)
df <- na.omit(df) # 결측치 생략
# 변수 age를 범주화(Young, Old)
df$yage <-ifelse(df$age < 4, 1, 0)
df$yage <-factor(df$yage,levels= c(1, 0), labels = c("Young", "Old"))
head(df)

# 1-1 EDA
# 도수분포표
table(df$yage)
# yage수준별로 prod변수 summary
with(df, tapply(prod,yage,summary))
# 상자도표
ggplot(df, aes(yage,prod)) + 
  geom_boxplot() + 
  xlab("age")

# 히스토그램
ggplot(df, aes(x = prod))  + 
  geom_histogram(binwidth =1.5)+ 
  facet_grid(yage ~ .) + 
  ggtitle("Histogramof Prod by Age")

# 각 연령그룹의 크기가 30보다 커서, 정규성 검정 필요 X
# 그래도 시행하고 싶으면 아래와 같이 시행
## H0 :정규분포를 따른다
## H1 :정규분포를 따르지 않는다

# yage 수준별로 prod 변수 정규성 검정
shapiro.test(df$prod[df$yage == "Young"])
shapiro.test(df$prod[df$yage == 'Old'])
with(df, tapply(prod, yage, shapiro.test))
##  p-value가 매우 작으므로 정규분포를 따른다고 할 수 없음.

# 1-2 분산 동일성 검정
# H0 : 30대 미만의 제품 선호도와 30대 이상의 제품 선호도의 분산이 동일하다?
var.test(prod ~ yage, data = df)

# dplyr 이용 코드
# 필요한 패키지 설치 (필요한 경우)
if(!require(purrr)) install.packages("purrr")

# 패키지 불러오기
library(purrr)
library(dplyr)
library(tibble)
library(ggplot2)

# 자료 읽기 및 결측치 제거
df <- read.csv("buy.csv") |> 
  na.omit()

# 변수 age 범주화 (Young, Old)
df <- df |> 
  mutate(yage = if_else(age < 4, "Young", "Old")) |> 
  mutate(yage = factor(yage, levels = c("Young", "Old")))


# 1-1 EDA

# 도수분포표
df |> count(yage)

# yage 수준별로 prod 변수 summary
df |> 
  group_by(yage) |> 
  summarize(across(prod, list(min = min, q1 = ~quantile(.x, 0.25), median = median, 
                              mean = mean, q3 = ~quantile(.x, 0.75), max = max, sd=sd)))


# 상자 도표
ggplot(df, aes(x = yage, y = prod)) +
  geom_boxplot() +
  xlab("Age")

# 히스토그램
ggplot(df, aes(x = prod)) +
  geom_histogram(binwidth = 1.5) +
  facet_wrap(~ yage) +  # facet_grid(yage ~ .) 보다 facet_wrap(~yage) 선호
  ggtitle("Histogram of Prod by Age")


# yage 수준별로 prod 변수 정규성 검정 (Shapiro-Wilk test)
df |> 
  group_by(yage) |> 
  summarize(shapiro_result = list(shapiro.test(prod))) |> 
  mutate(p_value = map_dbl(shapiro_result, "p.value"))
# Shapiro-Wilk 검정은 데이터가 정규 분포를 따르는지 검정하는 데 사용됩니다. 결과를 해석하는 핵심은 p-value입니다.

## 귀무 가설 (H0): 데이터는 정규 분포를 따른다.
## 대립 가설 (H1): 데이터는 정규 분포를 따르지 않는다.

# 결과를 보면 두 연령 그룹 (Young, Old) 모두 p-value가 매우 작습니다 (Young: 7.61e-27, Old: 3.42e-16). 
# 일반적으로 p-value가 유의 수준 (alpha, 보통 0.05)보다 작으면 귀무 가설을 기각합니다.

# 따라서, 이 결과는 두 연령 그룹 (Young, Old) 모두 prod 변수가 정규 분포를 따르지 않는다는 강력한 증거를 제시합니다. 
# 즉, 데이터가 정규 분포에서 예상되는 것보다 더 치우쳐 있거나 극단값이 많을 가능성이 높습니다.

# 1-2 분산 동일성 검정 (F-test)
var.test(prod ~ yage, data = df)
## var.test() 함수는 두 그룹의 분산이 같은지 검정하는 F-검정을 수행합니다. 결과를 보시죵.

## 귀무가설 (H0): 두 그룹 (Young, Old)의 prod 변수 분산은 같다.
## 대립가설 (H1): 두 그룹의 prod 변수 분산은 같지 않다.
### 여러번 들으셨겠지만, 
### 결과에서 p-value < 2.2e-16은 p-value가 2.2 x 10^-16보다 작다는 것을 의미하며, 이는 매우 작은 값입니다. 
### 일반적으로 p-value가 유의 수준 (alpha, 보통 0.05)보다 작으면 귀무가설을 기각

# F = 0.29019는 Young 그룹 분산 대비 Old 그룹 분산의 비율입니다. 
## 이 값이 1에서 멀어질수록 두 그룹의 분산 차이가 크다는 것을 나타냅니다.

# 95% 신뢰구간 (0.2309479, 0.3614616)은 이 구간 안에 실제 분산 비율이 있을 확률이 95%라는 것을 의미합니다. 
## 이 구간에 1이 포함되지 않으므로, 두 그룹의 분산이 다르다는 결론을 뒷받침합니다.

# sample estimates: ratio of variances = 0.2901883는 표본에서 계산된 분산 비율

# 1-3 독립표본 T 검정
# H0 : 30대 미만의 제품 선호도와 30대 이상의 제품 선호도의 평균이 동일하다

t.test(prod ~ yage,
       data = df,
       alternative = "two.sided",
       var.equal = FALSE,
       conf.level = 0.95)
## 결과 해석
#  data: prod by yage: yage 변수에 따라 prod 변수를 비교했음을 나타냅니다.

#  t = -7.021: t-통계량 값입니다. 이 값이 클수록 (절대값 기준) 두 그룹의 평균 차이가 크다는 것을 의미합니다.

# df = 295.88: 자유도입니다. Welch t-test는 두 그룹의 샘플 크기와 분산이 다를 때 자유도를 조정합니다.

# p-value = 1.513e-11: p-value는 매우 작습니다. 
## 이는 두 그룹의 평균이 같다는 가정 하에, 관측된 결과보다 더 극단적인 결과가 나타날 확률이 매우 낮다는 것을 의미합니다.

# alternative hypothesis: 
## true difference in means between group Young and group Old is not equal to 0: 
## 대립 가설은 두 그룹의 평균이 같지 않다는 것입니다. (양측 검정)

# 95 percent confidence interval: -2.744051 -1.542508: 두 그룹 평균 차이에 대한 95% 신뢰 구간입니다. 
## 이 구간은 0을 포함하지 않으므로, 두 그룹의 평균이 다르다는 결론을 뒷받침합니다.

# sample estimates: mean in group Young 2.354286, mean in group Old 4.497565: 
## 각 그룹의 prod 변수 표본 평균입니다.

# 결론:
##  p-value가 0.05보다 훨씬 작으므로, 
## 유의 수준 0.05에서 두 연령 그룹 (Young, Old) 간의 prod 변수 평균은 통계적으로 유의미하게 다르다고 결론지을 수 있습니다. Old 그룹의 prod 평균 (4.497565)이 Young 그룹의 prod 평균 (2.354286)보다 유의미하게 높습니다. 즉, 이 데이터셋에서는 나이가 많은 그룹(Old)이 젊은 그룹(Young)보다 prod 값이 더 높다고 할 수 있습니다.


# 예제 2 sleep data: 두 수면제의 효과의 차이가 있는지 알아보자.
data(sleep)
?sleep
# A data frame with 20 observations on 3 variables.
## [, 1]	extra	numeric	increase in hours of sleep
## [, 2]	group	factor	drug given
## [, 3]	ID	factor	patient ID
sleep

# 수면제 종류대로 정렬한 후 ID순서대로 정렬
sleep <- sleep[order(sleep$group, sleep$ID), ]
t.test(extra ~ group, sleep, paired = TRUE)

# sleep 자료를 변환
sleep_wide <- data.frame(ID = 1:10,
                         group1 = sleep$extra[1:10],
                         group2 = sleep$extra[11:20])
sleep_wide
# 두 가지 방법으로 검정 가능
# 1.
t.test(sleep_wide$group1, sleep_wide$group2, paired = TRUE)

# 2.
t.test(sleep_wide$group1- sleep_wide$group2, mu = 0)



## dplyr 활용
library(dplyr)
library(ggplot2)
library(tidyr) # pivot_wider, pivot_longer 사용

# 데이터 불러오기
data(sleep)

# 데이터 확인 (tibble 형태로 출력)
as_tibble(sleep)

# 데이터 정렬
sleep <- sleep |> 
  arrange(group, ID)

# 대응 표본 t-검정 (paired t-test)
t.test(extra ~ group, data = sleep, paired = TRUE)

# 데이터를 넓은 형태로 변환
sleep_wide <- sleep |> 
  select(ID, group, extra) |> 
  pivot_wider(names_from = group, values_from = extra) |>
  rename(group1 = `1`, group2 = `2`)

# 대응 표본 t-검정 (paired t-test) - 두 가지 방법

# 1. 넓은 형태의 데이터에서 직접 수행
t.test(sleep_wide$group1, sleep_wide$group2, paired = TRUE)

# 2. 차이를 계산하여 단일 표본 t-검정 수행
sleep_wide <- sleep_wide |>
  mutate(diff = group1 - group2)

t.test(sleep_wide$diff, mu = 0)

# 시각화 (선택 사항)

# 상자 그림
ggplot(sleep, aes(x = factor(group), y = extra)) +
  geom_boxplot() +
  labs(title = "수면제 종류에 따른 수면 시간 증가량", x = "수면제 종류", y = "수면 시간 증가량")

# 수면제 종류별 수면 시간 증가량 비교를 위한 히스토그램
ggplot(sleep, aes(x = extra, fill = factor(group))) +
  geom_histogram(position = "identity", alpha = 0.5, binwidth = 1) +
  labs(title = "수면제 종류별 수면 시간 증가량", x = "수면 시간 증가량", fill = "수면제 종류") +
  facet_wrap(~group)

# 대응 표본 시각화 (점과 선 이용)
ggplot(sleep, aes(x = factor(group), y = extra, group = ID)) +
  geom_point() +
  geom_line() +
  labs(title = "수면제 종류에 따른 수면 시간 증가량 (대응 표본)", x = "수면제 종류", y = "수면 시간 증가량")



### 2.4 분산분석 ####
#### 기본 틀
fit <- lm(formula,
           data = ...)
summary(fit)

# formula for aov
# y ~ x # 일원분산분석 y: 수치형, x: 범주형
# y ~ x1 + x2 # 주효과만 있는 이원분산분석 y: 수치형, x1, x2: 범주형
# y ~ x1 + x2 + x1:x2 또는 y ~ x1*x2 # 교호작용을 포함한 이원분산분석

#### 예제 1(책) BuyData를 이용하여 연령 그룹(20대,30대,40대,50대이상)에 따라 제품 호감도의 평균이 다른지 알아 보자.####
# 독립변수: age 연령 그룹(20대,30대,40대,50대이상)
# 종속변수: prod 제품 호감도

# 자료읽기
df <-read.csv("buy.csv",header= TRUE)
df <-na.omit(df) #결측치생략

# 변수age를 범주형 변수 age4로 변환
df$age4 <-factor(df$age,
                 levels = c(2, 3, 4,5),
                 labels = c("20대", "30대", "40대", "50대"))

df

# 1-1 EDA
# 도수분포표
table(df$age4)

# age4 수준별로 prod 변수 summary
with(df, tapply(prod,age4,summary))

# 상자도표
ggplot(df, aes(age4,prod)) +
  geom_boxplot()+ xlab("age")

# 히스토그램
ggplot(df, aes(x = prod)) +
  geom_histogram(binwidth = 1.5) +
  facet_grid(age4 ~ .) +
  ggtitle("Histogram of Prod by Age")

# install.packages("lawstat")
# 1-2 분산 동일성 검정
lawstat::levene.test(df$prod, df$age4)
bartlett.test(prod ~ age4, data = df)

# 1-3-1 분산분석:: 분산이 다른경우에
oneway.test(prod ~ age4, data = df, var.equal = FALSE)

# 1-3-2 분산분석:: 분산이 같은경우에
aov.out <- aov(prod ~ age4, data = df)
summary(aov.out)

# 1-4 다중비교
# Tukey HSD
TukeyHSD(aov.out, conf.level = 0.95)
# Scheffe (more conservative)
install.packages("agricolae")
agricolae::scheffe.test(aov.out,
                        "age4", # 집단변수
                        alpha = 0.05, # 유의수준
                        console = TRUE) # 화면출력

#### 예제 1(dplyr 이용) ####
library(dplyr)
library(ggplot2)
library(tibble)
# library(lawstat) # levene.test를 위해 필요
if(!require(lawstat)) install.packages("lawstat")
library(lawstat)
if(!require(agricolae)) install.packages("agricolae")
library(agricolae) # scheffe.test를 위해 필요

# 데이터 불러오기 및 결측치 제거
df <- read.csv("buy.csv") |>
  na.omit()

# age 변수를 범주형 변수 age4로 변환
df <- df |>
  mutate(age4 = factor(age,
                       levels = c(2, 3, 4, 5),
                       labels = c("20대", "30대", "40대", "50대")))

# 1-1 EDA

# 도수분포표
df |>
  count(age4)

# age4 수준별로 prod 변수 summary
df |>
  group_by(age4) |>
  summarize(across(prod, list(min = min, q1 = ~quantile(.x, 0.25), median = median,
                              mean = mean, q3 = ~quantile(.x, 0.75), max = max, sd = sd)))

# 상자 도표
ggplot(df, aes(x = age4, y = prod)) +
  geom_boxplot() +
  xlab("age")

# 히스토그램
ggplot(df, aes(x = prod)) +
  geom_histogram(binwidth = 1.5) +
  facet_wrap(~ age4) +
  ggtitle("Histogram of Prod by Age")

# 1-2 분산 동일성 검정

# Levene's test
levene.test(df$prod, df$age4)

# Bartlett's test
bartlett.test(prod ~ age4, data = df)

# 1-3 분산 분석

# 1-3-1 분산이 다른 경우
oneway.test(prod ~ age4, data = df, var.equal = FALSE)

# 1-3-2 분산이 같은 경우 (참고용)
aov.out <- aov(prod ~ age4, data = df)
summary(aov.out)

# 1-4 사후 검정 (다중 비교)

# Tukey HSD
TukeyHSD(aov.out, conf.level = 0.95)

# Scheffe's test
scheffe.test(aov.out,
             "age4",
             alpha = 0.05,
             console = TRUE)


#### 실습 ####
library(dplyr)
library(ggplot2)
library(tibble)
library(lawstat) # levene.test를 위해 필요

# 데이터 불러오기 및 결측치 제거
df <- read.csv("buy.csv") |>
  na.omit()

# edu 변수를 범주형으로 변환
df <- df |>
  mutate(edu = factor(edu,
                      levels = c(1, 2, 3, 4, 5),
                      labels = c("1", "2", "3", "4", "5")))

# 1-1 EDA

# 도수분포표
df |>
  count(edu)

# edu 수준별로 income 변수 summary
df |>
  group_by(edu) |>
  summarize(across(income, list(min = min, q1 = ~quantile(.x, 0.25), median = median,
                                mean = mean, q3 = ~quantile(.x, 0.75), max = max, sd = sd)))

# 상자 도표
ggplot(df, aes(x = edu, y = income)) +
  geom_boxplot() +
  xlab("edu")

# 히스토그램
ggplot(df, aes(x = income)) +
  geom_histogram(binwidth = 5000) +
  facet_wrap(~ edu) +
  ggtitle("Histogram of Income by Education Level")

# 1-2 분산 동일성 검정

# Levene's test
levene.test(df$income, df$edu)

# Bartlett's test
bartlett.test(income ~ edu, data = df)

# 1-3 분산 분석

# 1-3-1 분산이 다른 경우
oneway.test(income ~ edu, data = df, var.equal = FALSE)

# 1-3-2 분산이 같은 경우 (참고용)
aov.out <- aov(income ~ edu, data = df)
summary(aov.out)

# 1-4 사후 검정

# Tukey HSD (참고용, 분산이 다를 경우 사용하지 않음)
TukeyHSD(aov.out, conf.level = 0.95)

# 결과 해석
## 1. 분산 동일성 검정
## Levene's test: Test Statistic = 6.0363, p-value = 8.886e-05
## Bartlett's test: Bartlett's K-squared = 97.227, df = 4, p-value < 2.2e-16
### 해석: Levene's test와 Bartlett's test 결과, 두 검정 모두 p-value가 유의 수준 0.05보다 매우 작게 나타났습니다. 
###       따라서 교육 수준 그룹 간 수입의 분산이 동일하다는 귀무 가설을 기각합니다. 
###       즉, 교육 수준에 따라 수입의 분산에 유의미한 차이가 있다고 결론 내릴 수 있습니다.

## 2. 분산 분석
## Welch ANOVA (분산이 다른 경우): F = 7.1602, num df = 4.000, denom df = 27.678, p-value = 0.0004321
## 일반 ANOVA (분산이 같은 경우, 참고용): F = 13.38, df = 4, p-value = 1.66e-10
### 해석: 분산 동일성 검정 결과, 분산이 다른 것으로 나타났기 때문에 Welch ANOVA 결과를 해석하는 것이 적절합니다. 
###       Welch ANOVA 결과, p-value가 0.0004321로 유의 수준 0.05보다 작습니다. 
###       따라서 교육 수준에 따른 수입 평균에 유의미한 차이가 있다는 결론을 내릴 수 있습니다.

## 2.5 회귀분석 ####
# 기본 틀
fit <-lm(formula,
          data = ...)
summary(fit)

# formula for regression analysis
y ~ -1 + x        # y =a + b*x
y ~ x             # y =a*x
y ~ x1+ x2        # y =a + b*x1 + c*x2
log(y) ~ log(x)   # log(y) = a+ b*log(x)
y ~ x+ I(x^2)     # y =a + b*x + c*x*x
y ~ .             # 데이터의 모든 변수가 설명변수로 들어감

# useful functions 
coef(fit)                 # 회귀계수값
confint(fit,level = 0.95) # 회귀계수의 95% 신뢰구간
fitted(fit)               # 종속변수 y의 적합값
residuals(fit)            # 잔차
anova(fit)                # 분산분석표
vcov(fit)                 # 회귀계수의 분산-공분산 행렬
influence(fit)            # 회귀 진단시 이용
plot(fit)                 # 오차의 등분산성,정규성 확인 및 영향치 판단

# how to compare different models
fit1 <- lm(y ~ x1 + x2 + x3 + x4, data = ...)
fit2 <- lm(y ~ x1 + x2, data = ...)
anova(fit1, fit2)
##  p-value가 0.05보다 크면 유의수준 0.05에서 두 모형의 설명력이 비슷하다고 볼 수 있어서 작은 모형을 선택. 

# how to choose model 
## 설명변수의 개수가 많으면 회귀모형의 설명력은 좋지만 모형이 복잡해짐
## 적은수의 설명변수를 선택하여 잘 적합되는 모형 추정
## MASS 패키지의 stepAIC()를 이용, 아래는 예시
# Stepwise Regression
fit <- lm(y ~ x1 + x2 + x3, data = ...)
step <- MASS::stepAIC(fit, direction = 'both')
step$anova

#### 예제 1(책) ####
#### Buy Data를 이용하여 기업호감도가 제품호감도에 미치는 영향을 단순 선형 회귀모형으로 알아보자.
# 독립변수: co 기업호감도
# 종속변수: prod 제품호감도

# 자료 읽기
df <- read.csv("buy.csv", header = TRUE)
df <- na.omit(df) # 결측치 생략
str(df)

# 1-1 EDA
# 기술 통계량
summary(df[,c('co', 'prod')])

# 산점도
ggplot(df, aes(y = prod, x = co)) +
  geom_point()

# 1-2 단순선형 회귀모형 적합
fit <- lm(prod ~ co, data = df)
summary(fit)

# 1-3 도표를 그려보고 회귀모형이 어떤지 진단해보자. #
par(mfrow = c(2,2))
plot(fit)

# 1-4 변수 변환을 했을 때 모형의 결과가 어떻게 변하는가? #
# 로그변환
df$lprod <- log(df$prod)
df$lco <- log(df$co)

# 로그변환 산점도: 이전의 scatter plot과 비교해보세요 
ggplot(df, aes(y = lprod, x = lco)) +
  geom_point()

# 1-5 다시 단순선형 회귀모형 적합 #
fit1 <- lm(lprod ~ lco, data = df)
summary(fit1)

# 1-6 도표를 그려보고 회귀모형이 어떤지 진단해보자 #
par(mfrow = c(2,2))
plot(fit1) # par(mfrow = c(2,2)); plot(fit2)와 비교해보세요

# 1-7 추론
# 회귀계수와 신뢰구간
coef(fit1)
confint(fit1, level = 0.95)

# 1-8 예측
# 새로운 co값 10, 20, 30에 대한 예측값
newda <- data.frame(co = c(10, 20, 30))
newda$lco <- log(newda$co)
predict(fit1, newda, interval = 'confidence')
predict(fit1, newda, interval = 'predict')

#### 예제 1(dplyr) ####
#### Buy Data를 이용하여 기업호감도가 제품호감도에 미치는 영향을 단순 선형 회귀모형으로 알아보자.
library(dplyr)
library(ggplot2)
library(tibble)

# 데이터 불러오기 및 결측치 제거
df <- read.csv("buy.csv") |>
  na.omit()

# 데이터 구조 확인
str(df)

# 1-1 EDA

# 기술 통계량
df |>
  select(co, prod) |>
  summary()

# 산점도
ggplot(df, aes(x = co, y = prod)) +
  geom_point() +
  labs(title = "기업호감도(co) vs 제품호감도(prod)", x = "기업호감도", y = "제품호감도")

# 1-2 단순 선형 회귀 모형 적합
fit <- lm(prod ~ co, data = df)
summary(fit)

# 1-3 회귀 모형 진단
par(mfrow = c(2, 2))
plot(fit)
par(mfrow = c(1, 1)) # 원래대로 복구

# 1-4 변수 변환 (로그 변환)
df <- df |>
  mutate(lprod = log(prod),
         lco = log(co))

# 로그 변환 후 산점도
ggplot(df, aes(x = lco, y = lprod)) +
  geom_point() +
  labs(title = "로그 변환 후: 기업호감도(lco) vs 제품호감도(lprod)", x = "log(기업호감도)", y = "log(제품호감도)")

# 1-5 로그 변환 후 단순 선형 회귀 모형 적합
fit1 <- lm(lprod ~ lco, data = df)
summary(fit1)

# 1-6 회귀 모형 진단 (로그 변환 후)
par(mfrow = c(2, 2))
plot(fit1)
par(mfrow = c(1, 1)) # 원래대로 복구

# 1-7 추론

# 회귀 계수
coef(fit1)

# 신뢰 구간
confint(fit1, level = 0.95)

# 1-8 예측

# 새로운 co 값에 대한 lco 계산
newda <- tibble(co = c(10, 20, 30)) |>
  mutate(lco = log(co))

# 예측
predict(fit1, newdata = newda, interval = "confidence") # 신뢰 구간
predict(fit1, newdata = newda, interval = "predict") # 예측 구간

#### 예제 2(책) ####
####  BuyData를 이용하여 기업호감도와 연령대가 제품호감도에 미치는 영향을 회귀모형으로 알아보자.
# 독립변수: co    기업호감도(수치), age 연령대(범주)
# 종속변수: prod  제품호감도

# 자료 읽기
df <- read.csv("buy.csv", header = TRUE)
df <- na.omit(df) 

# 변수 age를 범주화 (Young, Old)
df$yage <- ifelse(df$age < 4, 1, 0)
df$yage <- factor(df$yage, levels = c(1, 0), labels = c("Young", "Old"))
head(df)
df <- df |>  # 책에는 누락되어 있는 부분
  mutate(lprod = log(prod),
         lco = log(co))

# 1-1 EDA
# 산점도
ggplot(df, aes(y = lprod, x = lco, color = yage)) +
  geom_point()


# 1-2 회귀모형 적합
fit2 <- lm(lprod ~ lco + yage, data = df)
summary(fit2)
fit3 <- lm(lprod ~ lco*yage, data = df)
summary(fit3)

# 1-3 모형 선택
anova(fit2, fit3)

#### 예제 2(dplyr) #### 
library(dplyr)
library(ggplot2)
library(tibble)

# 데이터 불러오기 및 결측치 제거
df <- read.csv("buy.csv") |>
  na.omit()

# 변수 age 범주화 (Young, Old) 및 로그 변환
df <- df |>
  mutate(yage = if_else(age < 4, "Young", "Old"),
         yage = factor(yage, levels = c("Young", "Old")),
         lprod = log(prod),
         lco = log(co))

# 1-1 EDA

# 산점도 (연령대별 색상 구분)
ggplot(df, aes(x = lco, y = lprod, color = yage)) +
  geom_point() +
  labs(title = "기업호감도(lco) vs 제품호감도(lprod) by 연령대(yage)", x = "log(기업호감도)", y = "log(제품호감도)")

# 1-2 회귀 모형 적합

# 상호작용 없는 모형
fit2 <- lm(lprod ~ lco + yage, data = df)
summary(fit2)

# 상호작용 있는 모형
fit3 <- lm(lprod ~ lco * yage, data = df)
summary(fit3)

# 1-3 모형 선택 (ANOVA를 이용한 F-검정)
anova(fit2, fit3)



# 결과 해석
#### fit2 (상호작용 없는 모형):
  
  # lprod = -1.59057 + 0.98943 * lco + 0.59930 * yageOld

# lco와 yageOld의 회귀 계수는 모두 통계적으로 유의미했습니다. (p < 0.001)

# lco가 1 단위 증가할 때 lprod는 평균적으로 0.98943 단위 증가합니다.

# yage가 Old인 경우 Young에 비해 lprod가 평균적으로 0.59930 단위 높습니다.

# Adjusted R-squared는 0.6625로, 모형이 lprod 변동의 약 66.25%를 설명합니다.

#### fit3 (상호작용 있는 모형):
  
  # lprod = -1.55053 + 0.97024 * lco + 0.47309 * yageOld + 0.06082 * lco:yageOld

# lco와 yageOld의 회귀 계수는 통계적으로 유의미했으나(p < 0.001), 
# 상호작용 항(lco:yageOld)의 계수는 유의미하지 않았습니다 (p = 0.320).

# Adjusted R-squared는 0.6625로, fit2와 동일합니다.

#### 실습 ####
#### Buy Data를 이용하여 제품호감도에 영향을 미치는 변수를 찾아보시오.
# 필요한 패키지 설치 및 로드
if (!require(dplyr)) install.packages("dplyr")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(tibble)) install.packages("tibble")
if (!require(leaps)) install.packages("leaps")  # 변수 선택
if (!require(MASS)) install.packages("MASS")    # stepwise selection

library(dplyr)
library(ggplot2)
library(tibble)
library(leaps)
library(MASS)

# 데이터 불러오기 및 결측치 제거
df <- read.csv("buy.csv") |>
  na.omit()

# prod와 다른 변수들 간의 산점도 행렬
df_numeric <- df |> select_if(is.numeric)  # 숫자형 변수만 선택, select_if는 deprecated
pairs(df_numeric)

# 모든 가능한 회귀 모형 적합 (시간이 오래 걸릴 수 있음)
all_regs <- regsubsets(prod ~ ., data = df_numeric, nbest = 1, nvmax = ncol(df_numeric) - 1)
summary(all_regs)

# 변수 선택 결과 시각화
plot(all_regs, scale = "adjr2")

# Stepwise regression (AIC 기준)
full_model <- lm(prod ~ ., data = df_numeric)
step_model <- stepAIC(full_model, direction = "both", trace = FALSE)
summary(step_model)

?stepAIC # AIC와 BIC 
# Stepwise regression (BIC 기준)
n <- nrow(df_numeric)
step_model_bic <- stepAIC(full_model, direction = "both", k = log(n), trace = FALSE)
summary(step_model_bic)

# 최종 모형 (예시: step_model 결과를 사용)
final_model <- lm(prod ~ age + edu + co + ad, data = df_numeric)
summary(final_model)

# 최종 모형 진단
par(mfrow = c(2, 2))
plot(final_model)
par(mfrow = c(1, 1))

# 결과 해석:
## summary(all_regs) 출력 결과, *는 해당 변수가 그 개수의 변수를 가진 모형 중 최적의 모형에 포함되었다는 것을 의미합니다.
## plot(all_regs, scale = "adjr2") 시각화를 통해 변수 개수별 최적 모형과 그 때의 수정된 R-squared 값을 확인할 수 있습니다.
### 변수 1개: ad
### 변수 2개: co, ad
### 변수 3개: income, co, ad
### 변수 4개: edu, income, co, ad
### 변수 5개: edu, income, co, ad
### 변수 6개: age, edu, income, co, ad
### 변수 7개: age, edu, income, exp, co, ad
### 변수 8개: year, buy, age, edu, income, exp, co, ad
### 변수 9개: 모든 변수 포함

# Stepwise Regression
## AIC 기준: stepAIC(full_model, direction = "both", trace = FALSE)는 AIC를 기준으로 stepwise regression을 수행했습니다.
## 선택된 모형: prod ~ age + income + exp + co + ad
## age, income, exp, co, ad 변수가 유의미하게 prod에 영향을 미치는 것으로 나타났습니다.
## co의 계수가 가장 크고, income, age, exp 순으로 계수 크기가 나타났습니다. ad는 음의 계수를 가집니다.
## 수정된 R-squared는 0.7497로, 모형이 prod 변동의 약 75%를 설명합니다.

## BIC 기준: stepAIC(full_model, direction = "both", k = log(n), trace = FALSE)는 BIC를 기준으로 stepwise regression을 수행했습니다.
## 선택된 모형: prod ~ income + exp + co
## income, exp, co 변수가 유의미하게 prod에 영향을 미치는 것으로 나타났습니다.
## co의 계수가 가장 크고, income, exp 순으로 계수 크기가 나타났습니다.
## 수정된 R-squared는 0.7472로, 모형이 prod 변동의 약 74.7%를 설명합니다.





#### 심심한 사람만해보세요 ####
# 필요한 패키지 설치 및 로드
if (!require(dplyr)) install.packages("dplyr")
if (!require(leaps)) install.packages("leaps")
if (!require(MASS)) install.packages("MASS")

library(dplyr)
library(leaps)
library(MASS)

# 데이터 불러오기 및 결측치 제거
df <- read.csv("buy.csv") |>
  na.omit()

# 숫자형 변수만 선택 (종속 변수: prod)
df_numeric <- df |>
  select_if(where(is.numeric))

# 최적의 회귀모형을 찾는 함수
find_best_model <- function(data, y_var, method = "exhaustive", criterion = "adjr2") {
  # 1. 모든 가능한 회귀모형 적합 (regsubsets)
  
  # nvmax를 (독립변수 개수 -1)로 제한
  all_regs <- regsubsets(reformulate(".", y_var), data = data, nbest = 1, nvmax = ncol(data) - 2, method = method) 
  
  all_regs_summary <- summary(all_regs)
  
  # 2. 선택 기준에 따른 최적 모형 선택
  if (criterion == "adjr2") {
    best_model_index <- which.max(all_regs_summary$adjr2)
    
  } else if (criterion == "bic") {
    best_model_index <- which.min(all_regs_summary$bic)
    
  } else if (criterion == "cp") {
    best_model_index <- which.min(all_regs_summary$cp)
    
  } else {
    stop("Invalid criterion. Choose from 'adjr2', 'bic', or 'cp'.")
  }
  
  
  # 3. 선택된 변수들로 최종 모형 적합
  selected_vars <- names(coef(all_regs, best_model_index))[-1] # 상수항 제외
  final_formula <- reformulate(selected_vars, response = y_var)
  final_model <- lm(final_formula, data = data)
  
  # 4. Stepwise regression (AIC 기준)
  step_model_aic <- stepAIC(final_model, direction = "both", trace = FALSE)
  
  # 5. Stepwise regression (BIC 기준)
  n <- nrow(data)
  step_model_bic <- stepAIC(final_model, direction = "both", k = log(n), trace = FALSE)
  
  # 결과 반환
  return(list(
    all_regs_summary = all_regs_summary,
    best_model_index = best_model_index,
    selected_vars = selected_vars,
    final_model = final_model,
    step_model_aic = step_model_aic,
    step_model_bic = step_model_bic
  ))
}

# 함수 실행 (exhaustive search, adjr2 기준)
best_model_result_ex <- find_best_model(df_numeric, "prod", method = "exhaustive", criterion = "adjr2")
best_model_result_ex$selected_vars
best_model_result_ex$final_model |> summary()
best_model_result_ex$step_model_aic |> summary()
best_model_result_ex$step_model_bic |> summary()

# 함수 실행 (forward selection, adjr2 기준)
best_model_result_fw <- find_best_model(df_numeric, "prod", method = "forward", criterion = "adjr2")
best_model_result_fw$selected_vars
best_model_result_fw$final_model |> summary()
best_model_result_fw$step_model_aic |> summary()
best_model_result_fw$step_model_bic |> summary()

# 함수 실행 (backward elimination, adjr2 기준)
best_model_result_bw <- find_best_model(df_numeric, "prod", method = "backward", criterion = "adjr2")
best_model_result_bw$selected_vars
best_model_result_bw$final_model |> summary()
best_model_result_bw$step_model_aic |> summary()
best_model_result_bw$step_model_bic |> summary()

# 함수 실행 (exhaustive search, bic 기준)
best_model_result_ex_bic <- find_best_model(df_numeric, "prod", method = "exhaustive", criterion = "bic")
best_model_result_ex_bic$selected_vars
best_model_result_ex_bic$final_model |> summary()
best_model_result_ex_bic$step_model_aic |> summary()
best_model_result_ex_bic$step_model_bic |> summary()

# 함수 실행 (forward selection, bic 기준)
best_model_result_fw_bic <- find_best_model(df_numeric, "prod", method = "forward", criterion = "bic")
best_model_result_fw_bic$selected_vars
best_model_result_fw_bic$final_model |> summary()
best_model_result_fw_bic$step_model_aic |> summary()
best_model_result_fw_bic$step_model_bic |> summary()

# 함수 실행 (backward elimination, bic 기준)
best_model_result_bw_bic <- find_best_model(df_numeric, "prod", method = "backward", criterion = "bic")
best_model_result_bw_bic$selected_vars
best_model_result_bw_bic$final_model |> summary()
best_model_result_bw_bic$step_model_aic |> summary()
best_model_result_bw_bic$step_model_bic |> summary()

# 함수 실행 (exhaustive search, Cp 기준)
best_model_result_ex_cp <- find_best_model(df_numeric, "prod", method = "exhaustive", criterion = "cp")
best_model_result_ex_cp$selected_vars
best_model_result_ex_cp$final_model |> summary()
best_model_result_ex_cp$step_model_aic |> summary()
best_model_result_ex_cp$step_model_bic |> summary()

# 함수 실행 (forward selection, Cp 기준)
best_model_result_fw_cp <- find_best_model(df_numeric, "prod", method = "forward", criterion = "cp")
best_model_result_fw_cp$selected_vars
best_model_result_fw_cp$final_model |> summary()
best_model_result_fw_cp$step_model_aic |> summary()
best_model_result_fw_cp$step_model_bic |> summary()

# 함수 실행 (backward elimination, Cp 기준)
best_model_result_bw_cp <- find_best_model(df_numeric, "prod", method = "backward", criterion = "cp")
best_model_result_bw_cp$selected_vars
best_model_result_bw_cp$final_model |> summary()
best_model_result_bw_cp$step_model_aic |> summary()
best_model_result_bw_cp$step_model_bic |> summary()


