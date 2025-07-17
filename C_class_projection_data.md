변동이 가장 커지는 과정을 시각화 했습니다. ~~(그냥 재미용)~~

---

``` R

# install.packages("MASS") # mvrnorm 함수 사용을 위해 필요
# install.packages("ggplot2") # 시각화 함수 사용을 위해 필요
# install.packages("patchwork") # 여러 플롯을 합치기 위해 필요

library(MASS)
library(ggplot2)
library(patchwork)

# 재현 가능성을 위해 시드 설정
#---------------------------------
# set.seed()는 난수 생성을 위한 시작점을 고정하는 역할을 합니다.
# 이 값을 42로 설정하면 코드를 실행할 때마다 항상 동일한 난수 데이터가 생성되어,
# 분석 결과를 동일하게 재현할 수 있습니다.
set.seed(42)

# 1. 데이터 생성
#---------------------------------
n <- 200  # 생성할 데이터 포인트의 개수를 200개로 지정합니다.
mu <- c(1, 1) # 데이터의 중심점(평균)을 (1, 1)로 설정합니다.
# 공분산 행렬을 정의합니다. 이 행렬은 데이터의 분포 형태(퍼진 정도와 방향)를 결정합니다.
# 대각선 원소는 각 변수의 분산, 비대각선 원소는 두 변수 간의 공분산입니다.
sigma <- matrix(c(0.04, 0.018, 0.018, 0.01), 2, 2)
# mvrnorm 함수를 사용하여 위에서 정의한 평균과 공분산을 따르는 다변량 정규분포 데이터를 생성합니다.
data <- as.data.frame(mvrnorm(n, mu, sigma))
# 생성된 데이터의 열 이름을 "V1", "V2"로 지정합니다.
colnames(data) <- c("V1", "V2")

# 2. 실제 PC1 방향 찾기 (시각화의 최종 목표 설정용)
#---------------------------------
# prcomp 함수를 사용하여 데이터의 주성분 분석(PCA)을 수행합니다.
# center = TRUE는 데이터의 중심을 원점으로 이동시키는 옵션입니다.
pca_result <- prcomp(data, center = TRUE, scale. = FALSE)
# PCA 결과에서 첫 번째 주성분(PC1)의 방향 벡터를 추출합니다. 이 벡터가 데이터의 분산이 가장 큰 방향입니다.
true_pc1_vector <- pca_result$rotation[, 1]
# atan2 함수를 사용하여 PC1 벡터의 각도를 라디안 단위로 계산합니다. 이 각도가 우리가 찾으려는 최종 목표 각도입니다.
true_angle <- atan2(true_pc1_vector[2], true_pc1_vector[1])

# 3. 7개의 탐색 각도 설정
#---------------------------------
# 0도부터 실제 PC1 각도(true_angle)까지 동일한 간격으로 7개의 각도를 생성합니다.
# 이 각도들을 순서대로 탐색하며 분산의 변화를 시각화할 것입니다.
angle_sequence <- seq(from = 0, to = true_angle, length.out = 7)
# 각 단계별로 생성될 ggplot 객체를 저장할 빈 리스트를 만듭니다.
plot_list <- list()

# 4. 각 단계별 플롯 생성
#---------------------------------
# 7개의 탐색 각도에 대해 반복문을 실행합니다.
for (i in 1:7) {
  # 첫 번째 탐색선(PC1 후보)의 각도를 설정합니다.
  theta1 <- angle_sequence[i]
  # 두 번째 탐색선은 첫 번째 선과 항상 직교(90도, pi/2 라디안 차이)하도록 각도를 설정합니다.
  theta2 <- theta1 + pi / 2
  # 각도를 사용하여 두 탐색선의 방향을 나타내는 단위 벡터(v1, v2)를 생성합니다.
  v1 <- c(cos(theta1), sin(theta1)) # PC1 후보 (빨간색 선)
  v2 <- c(cos(theta2), sin(theta2)) # PC2 후보 (녹색 선)
  
  # 데이터의 중심을 원점으로 이동시킵니다. (평균을 뺌)
  # 이는 분산을 계산하기 위한 표준적인 전처리 과정입니다.
  x_centered <- sweep(data, 2, mu, "-")
  
  # 각 데이터 포인트를 두 탐색선(v1, v2)에 정사영(projection)시킵니다.
  # (데이터 행렬 %*% 방향 벡터)는 각 점과 벡터의 내적(dot product)을 계산하여 투영된 길이를 구합니다.
  # 여기에 다시 방향 벡터의 전치 행렬을 곱하여 원래 좌표 공간의 위치를 계산합니다.
  proj_vec1 <- (as.matrix(x_centered) %*% v1) %*% t(v1)
  proj_vec2 <- (as.matrix(x_centered) %*% v2) %*% t(v2)
  # 정사영된 점들의 좌표를 다시 원래 데이터의 평균(mu)만큼 이동시켜 원래 좌표계에 표시합니다.
  projected_points1 <- as.data.frame(sweep(proj_vec1, 2, mu, "+"))
  projected_points2 <- as.data.frame(sweep(proj_vec2, 2, mu, "+"))
  
  # 두 탐색선에 정사영된 점들의 분산을 계산합니다.
  # PCA의 목표는 이 분산(variance1)이 최대가 되는 방향(v1)을 찾는 것입니다.
  variance1 <- var(as.matrix(x_centered) %*% v1)
  variance2 <- var(as.matrix(x_centered) %*% v2)
  
  # ggplot을 사용하여 시각화 객체(p)를 생성합니다.
  p <- ggplot(data, aes(x = V1, y = V2)) +
    geom_point(color = 'gray', alpha = 0.7) + # 원본 데이터를 회색 점으로 표시
    # 두 개의 탐색선(v1, v2)을 각각 빨간색과 녹색 직선으로 그립니다.
    geom_abline(slope = v1[2]/v1[1], intercept = mu[2]-(v1[2]/v1[1])*mu[1], color = "red", size = 1) +
    geom_abline(slope = v2[2]/v2[1], intercept = mu[2]-(v2[2]/v2[1])*mu[1], color = "darkgreen", size = 1) +
    # 각 탐색선에 정사영된 점들을 파란색과 진녹색 점으로 표시합니다.
    geom_point(data = projected_points1, aes(x = V1, y = V2), color = 'blue') +
    geom_point(data = projected_points2, aes(x = V1, y = V2), color = 'green4') +
    coord_fixed(ratio = 1, xlim = range(data$V1), ylim = range(data$V2)) + # 가로-세로 비율을 1:1로 고정하여 각도가 왜곡되지 않게 합니다.
    theme_bw() +
    labs(
      x = "첫 번째 변수 (V1)",  # <--- X축 설명 추가
      y = "두 번째 변수 (V2)",  # <--- Y축 설명 추가
      subtitle = paste("Var 1 (Red):", format(variance1, digits=4),
                       "\n | Var 2 (Green):", format(variance2, digits=4),
                       "\n sum(Var): ", format(variance1 + variance2, digits=10) )
    ) +
    theme( # <--- theme() 함수를 추가하여 세부 디자인을 조절합니다.
      axis.title.x = element_text(size = 9),      # X축 설명 글씨 크기 (필요시)
      axis.title.y = element_text(size = 9),      # Y축 설명 글씨 크기 (필요시)
      plot.subtitle = element_text(size = 8)      # <--- 부제목 글씨 크기 조절
    )
  
  # 완성된 ggplot 객체(p)를 리스트에 추가합니다.
  plot_list[[i]] <- p
}

# 5. 7개의 플롯을 한 번에 보여주기
#---------------------------------
# patchwork 패키지의 wrap_plots 함수를 사용하여 리스트에 저장된 7개의 플롯을
# 한 줄에 (ncol = 7) 나란히 배열하여 출력합니다.
wrap_plots(plot_list, ncol = 7)

```


<img width="2561" height="541" alt="image" src="https://github.com/user-attachments/assets/4b7dada4-8f68-4e45-8761-46bcdde7198a" />
