# 연습 문제 1####################################
# 1. 패키지 및 데이터 로드
library(MASS)
data(Boston)

# 2. 분석에 사용할 변수 선택 (medv, chas, rad 제외)
boston_pca_data <- Boston[, !(names(Boston) %in% c("medv", "chas", "rad"))]

# 3. 주성분분석 수행 (상관행렬 기반)
pca_boston <- princomp(boston_pca_data, cor = TRUE)
getwd()
# 4. 결과 확인
# 요약 정보 (각 주성분의 표준편차, 설명 분산 비율)   
summary(pca_boston)

# 적재계수 (Loadings)
print(pca_boston$loadings)

# Scree Plot
screeplot(pca_boston, type = "lines", main = "Scree Plot for Boston Data")

# Biplot
biplot(pca_boston)



# 연습 문제 2##################################################
# 1. 패키지 및 데이터 로드
library(MASS)
library(psych) # scree 함수 등 편의 기능 사용

# 2. 분석에 사용할 변수 선택
boston_fa_data <- Boston[, !(names(Boston) %in% c("medv", "chas", "rad"))]

# 3. 요인 개수 결정을 위한 스크리 플롯 확인
scree(boston_fa_data, factors = TRUE, pc = TRUE)

# 4. 인자분석 수행 (예: 4개의 요인, varimax 회전)
# 스크리 플롯을 참고하여 요인 수를 4개로 가정
fa_boston <- factanal(boston_fa_data, 
                      factors = 4, 
                      rotation = "varimax",
                      scores = "regression")

# 5. 결과 확인
# 요인 적재량(Factor Loadings) 및 요약 통계량 출력
print(fa_boston, digits = 2, cutoff = 0.3, sort = TRUE)

# 요인 적재량 시각화
loadings <- fa_boston$loadings
loadings
plot(loadings)
# plot(loadings, type="n") # 빈 플롯 생성
text(loadings, labels=names(boston_fa_data), cex=.7) # 변수 이름 표시
