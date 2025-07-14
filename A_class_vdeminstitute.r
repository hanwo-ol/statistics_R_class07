

devtools::install_github("vdeminstitute/vdemdata")

library(vdemdata) # V-Dem 데이터셋을 불러옵니다.
library(ggplot2)
# --- 데이터 기본 정보 확인 ---
# vdem 데이터셋의 차원 확인 (매우 큰 것을 볼 수 있습니다)
dim(vdem)

# 앞부분 몇 개의 열 이름만 확인
head(names(vdem))


# --- 분석에 사용할 변수 선택 ---
# 너무 많은 변수가 있으므로 분석할 변수만 선택하여 'pol_data'라는 새 객체를 만듭니다.
# dplyr::select() 함수를 사용합니다.
pol_data <- vdem %>%
  dplyr::select(
    country_name,      # 국가 이름
    year,              # 연도
    v2x_polyarchy,     # 선거 민주주의 지수 (핵심 민주주의 지표)
    v2x_corr,          # 정치 부패 지수 (높을수록 부패 심함)
    v2x_freexp_altinf, # 표현의 자유 및 대안정보 지수
    e_gdppc            # 1인당 GDP (로그 변환값)
  )

# 새로 만든 데이터 프레임 확인
head(pol_data)
str(pol_data)
summary(pol_data)

# 1. 대한민국 데이터만 필터링
korea_dem <- pol_data %>%
  dplyr::filter(country_name == "South Korea" & year >= 1945)

# 2. ggplot2를 이용한 시계열 그래프 그리기
ggplot(data = korea_dem, mapping = aes(x = year, y = v2x_polyarchy)) +
  geom_line(color = "blue", linewidth = 1) +  # 파란색 선으로 그래프를 그립니다.
  geom_point(color = "red", size = 2) + # 각 연도의 데이터를 빨간 점으로 표시합니다.
  labs(
    title = "대한민국 선거 민주주의 지수 변화 (1945-현재)",
    subtitle = "데이터 출처: V-Dem Institute",
    x = "연도",
    y = "선거 민주주의 지수 (v2x_polyarchy)"
  ) +
  theme_minimal() + # 깔끔한 테마 적용
  scale_y_continuous(limits = c(0, 1)) # y축 범위를 0~1로 고정

# 1. 2023년 데이터만 필터링하고, 결측치(NA)가 없는 데이터만 사용
world_2023 <- pol_data %>%
  dplyr::filter(year == 2023) %>%
  tidyr::drop_na(v2x_polyarchy, v2x_corr) # 분석할 변수에 결측치가 있으면 제외

# 2. 산점도 그리기
ggplot(data = world_2023, mapping = aes(x = v2x_polyarchy, y = v2x_corr)) +
  geom_point(alpha = 0.6) + # 점들을 약간 투명하게 처리 (alpha)
  geom_smooth(method = "loess", color = "red", se = FALSE) + # 추세선 추가 (빨간색, 신뢰구간 미표시)
  labs(
    title = "2023년 국가별 민주주의와 부패 지수의 관계",
    subtitle = "민주주의 지수가 높을수록 부패 지수가 낮은 경향",
    x = "선거 민주주의 지수",
    y = "정치 부패 지수 (높을수록 심함)"
  ) +
  theme_bw() # 흑백 테마 적용
