# 해당 코드를 다 실행 해본 후에, C_class_chaper2_****.md 시리즈를 보시면서 해석을 같이 비교해보세요(제가 정답이 아닐때도 있습니다)

#install.packages(c("mclust", "ggplot2", "caret", "ROCR", "rpart", "randomForest"))

### k-평균 군집분석 예제 (모의실험) (page25~26)
# 데이터 생성
set.seed(1)
nc=2; n=50                  # 2개의 군집, 50개의 관측치
x=matrix(rnorm(n*nc), ncol=nc) # 모의실험 자료 생성
x[1:20, 1]=x[1:20, 1]+1
x[21:n, 1]=x[21:n, 1]-2

# 원본 데이터 시각화
plot(x, cex=2)

# 화면 분할
par(mfrow=c(1, 2))

# k=2로 군집분석
km <- kmeans(x, 2)
plot(x, pch=km$cluster, col=km$cluster, main="k-means clustering with 2 clusters", cex=2)

# k=3으로 군집분석
km <- kmeans(x, 3)
plot(x, pch=km$cluster, col=km$cluster, main="k-means clustering with 3 clusters", cex=2)

#### k-평균 군집분석 예제 (초기치 선택) (page27)
set.seed(5)
xdata=iris[, c(2, 4)]

# 1차 군집분석
km1 <- kmeans(xdata, 3)
km1$withinss # 군집 내 제곱합

# 2차 군집분석 (다른 초기치로 시작)
km2 <- kmeans(xdata, 3)
km2$withinss # 군집 내 제곱합

par(mfrow=c(1, 2))
plot(xdata, pch=km1$cluster, col=km1$cluster, cex=2)
plot(xdata, pch=km2$cluster, col=km2$cluster, cex=2)


#####iris 데이터 k-평균 군집분석 (nstart) (page29)#########
par(mfrow=c(1,1))

data("iris"); iris
str(iris) # 데이터 구조 확인

set.seed(2019)
xdata=iris[, c(2, 4)] # 2개 변수만 선택

# nstart=1 (기본값)
km.res <- kmeans(xdata, 3)
km.res
km.res$betweenss/km.res$totss # information with 1 start

# nstart=25 (25회 반복 후 최적 결과 저장)
km.res25 <- kmeans(xdata, 3, nstart = 25)
km.res25$betweenss/km.res25$totss # information with 25 starts
km.res25$cluster # 분류된 군집 번호
km.res25$centers # 각 군집의 중심
km.res25$size    # 군집별 관측치 개수

# 군집화 결과 시각화
plot(xdata, pch=20, col=km.res25$cluster+1,
     cex=1.5, main="k-means clustering with 3 clusters")


##### Elbow Method로 최적 군집 수 찾기(page30)######
N = 10
infom = c()
# 군집의 개수를 1~10까지 변화시키며 수행
for (i in 1:N)
{
  km.out = kmeans(xdata, i, nstart=10)
  infom[i] = km.out$betweenss/km.out$totss
}
plot(1:N, infom, type="b", col=2, pch=16,
     xlab="number of clusters", ylab="information")


##### iris 데이터 계층적 군집분석(page34) ######
data("iris"); iris
xdata=iris[, c(2, 4)]

# 계층적 군집분석 수행 (최장연결법-유클리디안 거리)
hc.res <- hclust(dist(xdata), method="complete")
hc.res

# 덴드로그램
plot(hc.res, hang=-1, labels=FALSE)

# 2, 3, 4개 군집으로 자르기
(ct <- cutree(hc.res, k=2:4))

# k=2와 k=4일 때의 군집 결과 비교
table(k2=ct[,"2"], k4=ct[,"4"])

par(mfrow=c(1, 2))
plot(xdata, pch=20, cex=2, col=ct[,"2"], main="2 clusters")
plot(xdata, pch=20, cex=2, col=ct[,"4"], main="4 clusters")

par(mfrow=c(1,1))

###### 혼합모형 군집분석 page36~37 ################
# 데이터 생성
set.seed(1)
n=100
p=0.4 # 혼합비율
u=rbinom(n, 1, p) # cluster index
x1=rnorm(n, 10, 1) # cluster 1
x2=rnorm(n, 17, 1.5) # cluster 2
x=u*x1 + (1-u)*x2 # 관측치

# 데이터 밀도 함수 시각화
plot(density(x))

# mclust 패키지 로드
library(mclust)

# K=2, 분산이 다른 모델
M1=Mclust(x, G=2)
M1$parameters # 추정 모수
M1$z[, 1] > 0.5 # 군집 1에 속할 확률

# K=2, 분산이 같은 모델 ("E")
M2=Mclust(x, G=2, modelNames = "E")
M2$parameters # 추정 모수
M2$z[, 2] > 0.5 # 군집 2에 속할 확률



######## 챌린저 호 데이터 로지스틱 회귀분석 page44~45######
# 자료 불러오기
challenger <- read.csv('https://bit.ly/2YPCg4V')
str(challenger)

# 시각화
library(ggplot2)
# 온도와 실패 횟수의 관계
ggplot(challenger, aes(temperature, distress_ct)) + geom_point(color="red", size=3)
ggplot(challenger, aes(factor(distress_ct), temperature)) + geom_boxplot()

# 반응변수 정의 (성공횟수, 실패횟수)
xm <- cbind(challenger$distress_ct, challenger$o_ring_ct - challenger$distress_ct)

# 로지스틱 회귀모형 적합
fit <- glm(xm ~ temperature, data=challenger, family="binomial")
summary(fit)

# 온도=30일 때 예측
predict(fit, data.frame(temperature=30)) # linear predictor (로짓 값)
predict(fit, data.frame(temperature=30), type="response") # estimated prob. (확률 값)


###########adult 데이터 로지스틱 회귀분석 및 평가 page44~45#############
# 자료 불러오기 및 전처리
adult <- read.table('https://bit.ly/2zRvsrQ', sep = ',', fill = F, strip.white = T)
colnames(adult) <- c('age', 'workclass', 'fnlwgt', 'educatoin', 'educatoin_num',
                     'marital_status', 'occupation', 'relationship', 'race', 'sex',
                     'capital_gain', 'capital_loss', 'hours_per_week', 'native_country',
                     'income')
str(adult)

# 시각화
(f1 = ggplot(adult) + aes(x=as.numeric(age), fill=income) +
    geom_density(alpha=0.5))
f1 + facet_grid(race~sex)

# 데이터 분할 (훈련:검증 = 7:3)
set.seed(0716)
(n = length(adult$income))
idx = sample(1:n, size=round(n*0.7))
training = adult[idx,] # 훈련자료
test = adult[-idx,]   # 평가자료

# 모형 적합
fit1 <- glm(factor(income) ~ race + age + sex + hours_per_week + educatoin_num, 
            data=training, family="binomial")
summary(fit1)

# 예측 및 평가
(p1=predict(fit1, newdata=test[1:5,], type="response")) # 일부 데이터 예측
p1>0.5
yobs=test$income # 실제값
yhat=predict(fit1, newdata=test, type="response") # 예측 확률

# 혼동행렬
library(caret)
yhat1 = as.factor(ifelse(yhat > 0.5, ">50K", "<=50K"))
confusionMatrix(yhat1, factor(yobs))
table(yhat1, yobs)

# ROC 곡선
library(ROCR)
pred <- prediction(yhat, yobs)
perf <- performance(pred, measure = "tpr", x.measure = "fpr")
plot(perf, col=2, main="ROC curve")
abline(a=0, b=1)
performance(pred, "auc")@y.values # AUC 값

################## adult 데이터 의사결정나무 및 랜덤포레스트 page50#################
### 의사결정나무 ###
library(rpart)
(dt = rpart(income ~ race + age + sex + hours_per_week + educatoin_num, data=training))
printcp(dt); summary(dt)
plot(dt)
text(dt, use.n=TRUE)

# 모형 평가
yhat_tr <- predict(dt, test)[, ">50K"]
yhat_tr1 <- as.factor(ifelse(yhat_tr > 0.5, ">50K", "<=50K"))
confusionMatrix(yhat_tr1, factor(yobs))

# ROC 곡선 (의사결정나무)
library(ROCR)
pred_tr <- prediction(yhat_tr, yobs)
perf_tr <- performance(pred_tr, measure = "tpr", x.measure = "fpr")
plot(perf_tr, col=2, main="ROC curve")
# 로지스틱 모형과 비교
plot(perf, col=4, add=TRUE) 
abline(a=0, b=1)
performance(pred_tr, "auc")@y.values


### 랜덤포레스트 ###
library(randomForest)
(rf = randomForest(factor(income) ~ race + age + sex + hours_per_week + educatoin_num, data=training))
varImpPlot(rf) # 변수 중요도

# 모형 평가
yhat_rf <- predict(rf, test, type="prob")[, ">50K"]
pred_rf <- prediction(yhat_rf, yobs)
perf_rf <- performance(pred_rf, measure = "tpr", x.measure = "fpr")

# ROC 곡선 비교 (랜덤포레스트 vs 로지스틱 vs 의사결정나무)
plot(perf_rf, col=3, main="ROC curve")
plot(perf, col=2, add=TRUE)      # 로지스틱 (파랑)
plot(perf_tr, col=4, add=TRUE)   # 의사결정나무 (초록)
abline(a=0, b=1)
performance(pred_rf, "auc")@y.values

