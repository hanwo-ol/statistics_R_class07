# 1. 필요한 라이브러리를 설치하고 불러옵니다.
# install.packages("dplyr")
# install.packages("ggplot2")
library(dplyr)
library(ggplot2)
    
# 2. 예제 데이터를 생성합니다.
df <- data.frame(
  지역별_5 = rep(c(1, 2, 3, 4, 5), each = 100),
  투표율 = runif(500, 0.45, 0.85) # 45% ~ 85% 사이의 임의의 투표율 데이터 생성
)

# 3. 지역별로 그룹을 묶고, 평균 투표율을 계산합니다.
summary_df <- df %>%
  group_by(지역별_5) %>%
  summarise(평균투표율 = mean(투표율))

# 계산된 결과 확인
print(summary_df)

# 4. ggplot을 이용해 막대그래프를 그립니다.
ggplot(data = summary_df, aes(x = factor(지역별_5), y = 평균투표율)) +
  geom_bar(stat = "identity", fill = "skyblue") + # stat="identity"는 y축 값을 그대로 사용하라는 의미
  labs(
    title = "지역별 평균 투표율",
    x = "지역",
    y = "평균 투표율"
  ) +
  theme_minimal() # 깔끔한 테마 적용
