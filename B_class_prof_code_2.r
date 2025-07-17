# codes 20250716
    
?prop.test

20*(11/20)

20*(1-11/20)

prop.test(x=11, n=20, p=0.5, alternative = 'greater')

buy <- read.csv('buy.csv')
head(buy)
str(buy)

buy_summary = buy |>
  dplyr::group_by(year) |>
  dplyr::summarise(num_n = dplyr::n(),
                   num_buy = sum(buy))
buy_summary
buy_temp =buy|>
  dplyr::mutate(buy2 = ifelse(buy==1,'Yes', 'No'))

buy|>
  dplyr::mutate(buy2 = ifelse(buy==1,'Yes', 'No'))|>
  ggplot2::ggplot(ggplot2::aes(x=buy2))+
  ggplot2::geom_bar(ggplot2::aes(fill = as.factor(year)))

# H0: 년도별 구매비율이 동일하다 
# H1: 적어도 한해의 구매비율은 다르다
# 유의수준 0.05

?prop.test

prop.test(x = buy_summary$num_buy,
          n = buy_summary$num_n)

### 연령대별 구매비율의 차이가 있는가?
## 귀무가설: 연령대별 구매비율이 동일하다
## 대립가설: 연령대별 구매비율이 다르다\
## 유의수준 0.05

summary_age = buy|>
  dplyr::group_by(age)|>
  dplyr::summarise(num_n = dplyr::n(),
                   num_buy = sum(buy))

prop.test(summary_age$num_buy,
          summary_age$num_n)

unique(buy$age)

buy_summary2 = buy |>
  dplyr::mutate(age2 = dplyr::case_when(
    age == 2 ~ '20대',
    age == 3 ~ '30대',
    age == 4 ~ '40대',
    age == 5 ~ '50대'))|>
  dplyr::group_by(age2)|>
  dplyr::summarise(n_time = dplyr::n(),
                   n_buy = sum(buy))

prop.test(x = buy_summary2$n_buy,
          n = buy_summary2$n_time)

## 교차분석

score<- matrix(c(73, 98, 79, 82, 58, 110),
               ncol=3, nrow=2, byrow=TRUE)



score
colnames(score) <- c('Korean', 'Math', 'Eng')
rownames(score) <- c('Male', 'Female')
class(score)

score <- as.table(score)
class(score)

as.data.frame(score)

ggplot2::ggplot(as.data.frame(score),
                ggplot2::aes(x = Var1,
                             y = Freq,
                             fill = Var2)) + 
  ggplot2::geom_bar(stat = 'identity')+
  ggplot2::labs(x = 'Gender',
                y = 'Frequency',
                fill = 'Subject')

class(score)
chisq.test(score)

buy_table = table(buy$age, buy$buy)
class(buy_table)
chisq.test(buy_table)




chisq.test(table(buy$age, buy$edu))


# 연령과 특정 상품의 구매여부가 관련이 있는지?
buy_new = buy |>
  dplyr::mutate(
    age2 = dplyr::case_when(
      age == 2 ~ '20대',
      age == 3 ~ '30대',
      age == 4 ~ '40대',
      age == 5 ~ '50대'),
    buy2 = ifelse(buy==1,'Yes', 'No'))

table_buy = table(buy_new$age2, buy_new$buy2)

vcd::mosaic(~ age2 + buy2, data = buy_new,
            highlighting = 'age2',
            highlighting_fill = c('lightblue', 'pink'))

chisq.test(table_buy)

###
head(buy)
unique(buy$edu)

# 연령대(age)와 교육수준(edu) 사이에 관련성이 있는지?
# 1. dplyr::mutate 두 변수를 업데이트해서 새로운 데이터셋 만들기
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
# 2. 테이블 만들어서 table2_buy로 저장하기
table2_buy = table(buy_new2$age2, buy_new2$edu2)
table2_buy
# 3. mosaic 플랏 그려보기
vcd::mosaic(~ age2 + edu2, data = buy_new2,
            highlighting = 'age2')
# 4. 가설을 세우고 검정해보기
# H0: 관련이 없다
# H1: 관련이 있다.
chisq.test(table2_buy)







# 제품호감도 비교 (30대 이상 vs 30대 미만)
# prod, age

buy_new3 = buy |>
  dplyr::mutate(age_30 = ifelse(age<3, '30대 미만', '30대 이상'))

table(buy_new3$age_30)

ggplot2::ggplot(buy_new3, ggplot2::aes(x = age_30, y = prod)) +
  ggplot2::geom_boxplot()

ggplot2::ggplot(buy_new3, ggplot2::aes(x = prod)) +
  ggplot2::geom_histogram()+
  ggplot2::facet_grid(age_30 ~ .)

?t.test


# 제품호감도 비교 (30대 이상 vs 30대 미만)
# prod, age

buy_new3 = buy |>
  dplyr::mutate(age_30 = ifelse(age<3, '30대 미만', '30대 이상'))

# 정규성 검정
#가설
#H0: 정규분포를 따른다
#HA: 정규분포를 따르지 않는다.
?shapiro.test
shapiro.test(buy_new3$prod[buy_new3$age_30 == '30대 미만'])
shapiro.test(buy_new3$prod[buy_new3$age_30 == '30대 이상']) 

hist(buy_new3$prod[buy_new3$age_30 == '30대 미만'])
hist(buy_new3$prod[buy_new3$age_30 == '30대 이상']) 

#등분산성 검정
# H0: 분산이 같다
# HA: 분산이 다르
var.test(prod ~ age_30, data = buy_new3)

# H0: 30대 미만의 제품선호도와 30대 이상의 제품선호도가 같다.
# H1: 30대 미만의 제품선호도와 30대 이상의 제품선호도가 다르다.
# 유의 수준 = 0.05

t.test(prod ~ age_30, data = buy_new3,
       alternative = 'two.sided',
       var.equal = FALSE,
       conf.level = 0.95) # 1-유의수준

t.test(prod ~ age_30, data = buy_new3,
       alternative = 'two.sided',
       var.equal = TRUE,
       conf.level = 0.95) # 1-유의수준


## 수입 비교 (30대 이상 vs 30대 미만)
# income, age
# 테이블 작성, 히스토그램, 박스플랏, 정규성테스트, 
table(buy_new3$age_30)

ggplot2::ggplot(buy_new3, ggplot2::aes(x=income))+
  ggplot2::geom_histogram()+
  ggplot2::facet_wrap(~age_30)


ggplot2::ggplot(buy_new3, ggplot2::aes(x=age_30, y=income))+
  ggplot2::geom_boxplot()

shapiro.test(buy_new3$income[buy_new3$age_30 == '30대 이상'])
shapiro.test(buy_new3$income[buy_new3$age_30 == '30대 미만'])

# 등분산성테스트, 티검정(가설까지세워보고)

var.test(income ~ age_30, data = buy_new3)

# H0: 30대 미만의 수입과 30대 이상의 수입이 같다.
# H1: 30대 미만의 수입과 30대 이상의 수입이 다르다.
# 유의수준: 0.05
t.test(income ~ age_30, data = buy_new3,
       alternative = 'two.sided',
       var.equal = FALSE,
       conf.level = 0.95)

# 대응표본

sleep
str(sleep)
?sleep

# y ~ x
# 자료가 집단과 개인순서로 나열
sleep1 = sleep[order(sleep$group, sleep$ID),]

#H0: group 1 과 group 2 효과가 동일하다
#H1: group 1 과 group 2 효과가 다르다
#유의수준 0.05
t.test(extra ~ group,
       data = sleep1,
       paired=TRUE)

# y1, y2

sleep2 = data.frame(ID = 1:10,
                    group1 = sleep$extra[1:10],
                    group2 = sleep$extra[11:20])

t.test(sleep2$group1, sleep2$group2, paired=TRUE)


### 분산분석
# H0: 연령그룹에 따라서 제품호감도 평균이 같다
# H1: 하나의 그룹이라도 다른 제품호감도 평균을 가진다.

buy <- read.csv('buy.csv')
buy$age_4 <- factor(buy$age,
                    levels = c(2,3,4,5),
                    labels = c('20대','30대','40대','50대'))

table(buy$age_4)

with(buy, tapply(prod, age_4, summary))

# 상자도표
ggplot2::ggplot(buy, 
                ggplot2::aes(x = age_4, 
                             y = prod))+
  ggplot2::geom_boxplot()

# 히스토그램
ggplot2::ggplot(buy, 
                ggplot2::aes(x=prod))+
  ggplot2::geom_histogram()+
  ggplot2::facet_grid(age_4 ~.)

#등분산성 테스트
?lawstat::levene.test
#H0: 분산이 같다
#H1: 분산이 다르다

lawstat::levene.test(buy$prod, buy$age_4)

# 분산분석
# H0: 연령대별 제품선호도의 평균이 같다
# H1: H0이 아니다
# 유의수준 0.05

aov_res<-aov(prod ~ age_4, data = buy)

summary(aov_res)

# 다중비교
TukeyHSD(aov_res, conf.level = 0.95)


agricolae::scheffe.test(aov_res,
                        'age_4',
                        alpha = 0.05,
                        console = TRUE)

#H0: 연령대 별 수입이 같다
#H1: H0이 아니다.
#유의수준 0.05

lawstat::levene.test(buy$income, buy$age_4)
oneway.test(income ~ age_4,
            data = buy,
            var.equal = FALSE)

aov_res2<-aov(income ~ age_4, data = buy)
TukeyHSD(aov_res2, conf.level = 0.95)


# 기업호감도(x, co)가 제품호감도(y, prod)에 미치는 영향?
summary(buy$co)
summary(buy$prod)
buy<-na.omit(buy)
summary(buy$co)
summary(buy$prod)

ggplot2::ggplot(buy,
                ggplot2::aes(x=co,
                             y=prod))+
  ggplot2::geom_point()+
  ggplot2::scale_x_log10()+
  ggplot2::scale_y_log10()

fit <- lm(prod ~ co, data = buy)
fit
summary(fit)

par(mfrow=c(2,2))
plot(fit)

buy$lprod  = log(buy$prod)
buy$lco  = log(buy$co)

ggplot2::ggplot(buy, 
                ggplot2::aes(x=lco,
                             y=lprod))+
  ggplot2::geom_point()


fit2 <- lm(lprod ~ lco, data = buy)
summary(fit2)

par(mfrow=c(2,2))
plot(fit2)

coef(fit2)
confint(fit2)

class(buy$age)

lprod = -1.385 + 0.985*lco

fit2 <- lm(lprod ~ lco, data = buy)
fit3 <- lm(lprod ~ lco + factor(age), data = buy)
anova(fit2, fit3)

summary(fit3)

#
head(buy)

buy$buy = factor(buy$buy)
buy$age = factor(buy$age)
buy$edu = factor(buy$edu)

fit4 <- lm(lprod ~ lco + buy + age + edu + income + exp + ad + age:edu, 
           data = buy)
summary(fit4)
step <- MASS::stepAIC(fit4, direction ='both')
step$anova
