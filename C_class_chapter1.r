# install.packages(c('ade4', 'psych'))

# page 3 ~ 4
## 예시 데이터 생성
n <- 100 
x1 <- rnorm(n, 1, 0.2)
x2 <- 0.5 + 0.5*x1

## 이변량 정규분포 생성 -> 시각화
# 화면을 1x2로 분할
par(mfrow=c(1, 2))

# 데이터 A: x1과 x2가 선형 관계
plot(x1, x2, xlim=c(0, 2), ylim=c(0, 2), main="A")

# MASS 패키지 로드
library(MASS)

# 데이터 B: 이변량 정규분포에서 자료 생성
mu <- c(1, 1)
sigma <- matrix(c(0.04, 0.018, 0.018, 0.01), 2, 2)
x <- mvrnorm(n, mu, sigma)
plot(x, xlim=c(0, 2), ylim=c(0, 2), main="B")

############ USArrests 데이터 주성분분석######################
# page 10~11
## USArrests data PCA
# 데이터 로드
data("USArrests"); USArrests

# 산점도 행렬
plot(USArrests)

# 데이터 요약
summary(USArrests)

# 변수별 분산 확인
apply(USArrests, 2, var)

# 주성분분석 시행 (상관행렬 기반)
p1 <- princomp(USArrests, cor=TRUE)

# p1 객체 내용 확인
ls(p1)

# loadings: 각 변수의 주성분에 대한 기여도 (적재계수)
p1$loadings

# sdev: 각 주성분의 표준편차
p1$sdev

# 주성분분석 결과 요약
summary(p1)

# Scree plot
screeplot(p1, type="lines")

# 누적 설명 분산(PVE) 계산 및 시각화
pve <- cumsum(sort(p1$sdev^2, decreasing = T))/sum(p1$sdev^2)
plot(pve, xlab="Principal Component", ylab="Proportion of Variance Explained",
     ylim=c(0, 1), type='b')

# Biplot
biplot(p1)

# 제1, 제2 주성분 점수 산점도
plot(p1$scores[,1], p1$scores[,2])


################olympic 데이터 주성분분석 (page12##########################################
# 패키지 로딩
library(ade4)

# 데이터 로드
data("olympic"); olympic

# 데이터 요약
summary(olympic$tab)

# 주성분분석 시행 (상관행렬 기반)
p2 <- princomp(olympic$tab, cor=TRUE)

# 적재계수
p2$loadings

# 각 주성분의 표준편차
p2$sdev

# 주성분분석 결과 요약
summary(p2)

# Scree plot
screeplot(p2, type="lines")

# 누적 설명 분산(PVE) 계산 및 시각화
pve <- cumsum(sort(p2$sdev^2, decreasing = T))/sum(p2$sdev^2)
plot(pve, xlab="Principal Component", ylab="Proportion of Variance Explained",
     ylim=c(0, 1), type='b')

# Biplot
biplot(p2)

# 제1 주성분 점수와 10종경기 총점 비교
plot(p2$scores[,1], olympic$score)


####Harman 데이터 요인분석 (최대우도법) (page20)################################
# 패키지 로딩
par(mfrow= c(1,1))
library(psych)
data("Harman74.cor"); Harman74.cor

# 1-요인 모델 적합
Harman74.FA <- factanal(factors = 1, covmat = Harman74.cor)
Harman74.FA
Harman74.FA$loadings      # 요인의 설명력
Harman74.FA$uniquenesses  # 특정분산 추정치
Harman74.FA$scores        # 요인 점수 (이 경우 원본 데이터가 없어 NULL)

# 요인 개수를 2개부터 5개까지 늘려가며 모델 적합
for(factors in 2:5) print(update(Harman74.FA, factors = factors))

# 5-요인 모델 적합 (회전 없음)
Harman74.FA <- factanal(factors = 5, covmat = Harman74.cor,
                        rotation = "none")
(LL <- Harman74.FA$loadings)
rowSums(LL^2) # 공통성(communality) 계산

# 5-요인 모델 적합 (promax 회전 적용)
Harman74.FA.rotation <- factanal(factors = 5, covmat = Harman74.cor,
                                 rotation = "promax")
Harman74.FA.rotation
plot(Harman74.FA.rotation$loadings)
text(Harman74.FA.rotation$loadings, labels = colnames(Harman74.cor$cov), cex=0.5)

###### Harman 데이터 요인분석 (주축인자법) (page21)#####################
# 주축인자법 (회전 없음)
pc <- principal(Harman74.cor$cov, nfactors=5, rotate="none")
pc$loadings
pc$communality

# 주축인자법 (promax 회전)
pc.rot <- principal(Harman74.cor$cov, nfactors=5, rotate="promax")
pc.rot$loadings
pc.rot$communality
plot(pc.rot$loadings)
text(pc.rot$loadings, labels = colnames(Harman74.cor$cov), cex=0.5)


