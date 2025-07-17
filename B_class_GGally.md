## 상관행렬도, 각 연도별로,?
   
``` R
# install.packages("sf")
# 1. 필요 패키지 로드
library(sf)           # 내장 데이터셋 쓰려고 로드했슴미다.
library(dplyr)
library(GGally)       # ggpairs() 함수를 사용하여 여러 변수 간의 관계를 한 번에 시각화하기 위해 로드합니다.
library(ggplot2)      # GGally의 기반이 되며, 플롯의 세부적인 디자인(theme)을 조정하기 위해 사용합니다.
library(gridExtra)    # 여러 개의 ggplot을 하나의 화면에 배열하기 위해 로드합니다.
library(RColorBrewer) # 시각적으로 조화로운 색상 팔레트를 사용하기 위해 로드합니다.

# 2. nc 데이터 불러오기
nc <- st_read(system.file("shape/nc.shp", package="sf"), quiet = TRUE)

# 3. 데이터 가공
#    - 수치형 변수 4개 선택 및 이름 변경 (Var1 ~ Var4)
#    - ntile() 함수로 100개 카운티를 5개의 그룹으로 나눔 -> 'Region_Group' 생성
#    - st_drop_geometry()로 공간 정보 제거하여 일반 데이터 프레임으로 변환
nc_data_prepared <- nc %>%
  select(
    Var1 = AREA,      # 카운티 면적
    Var2 = PERIMETER, # 카운티 둘레
    Var3 = BIR74,     # 1974년 출생아 수
    Var4 = SID74      # 1974년 영아 돌연사 수
  ) %>%
  mutate(
    Region_Group = as.factor(ntile(row_number(), 5)) # 데이터를 5개 그룹으로 나눔
  ) %>%
  st_drop_geometry()

# 최종 데이터 형태 확인
print(head(nc_data_prepared))


# 그룹 정보 가져오기
groups <- unique(nc_data_prepared$Region_Group)
groups
# 4. 그룹별 plot 생성 및 저장
#----------------------------------------------------------------#
plot_list <- list()                                                                            # # 생성된 여러 개의 ggpairs 플롯 객체를 저장하기 위한 빈 리스트를 생성합니다.
point_color <- brewer.pal(9, "YlOrRd")[7]                                                      # # "YlOrRd" 팔레트의 9개 색상 중 7번째 색상을 점(point) 색상으로 지정합니다.
density_color <- brewer.pal(9, "YlOrRd")[8]                                                    # # "YlOrRd" 팔레트의 9개 색상 중 8번째 색상을 밀도 그래프(density plot)의 선 색상으로 지정합니다.
density_fill <- brewer.pal(9, "YlOrRd")[5]                                                     # # "YlOrRd" 팔레트의 9개 색상 중 5번째 색상을 밀도 그래프의 채우기 색상으로 지정합니다.

# for 루프를 그룹 기준으로 변경
for (i in seq_along(groups)) {
  # nc_data_prepared에서 현재 그룹에 해당하는 데이터만 필터링
  group_data <- nc_data_prepared %>%
    filter(Region_Group == groups[i]) %>%
    select(-Region_Group)                                                                      # 분석에 불필요한 그룹 열은 제거
  
  # ggpairs 플롯 생성
  plot <- ggpairs(
    group_data,                                                                                # # 각 그룹별로 필터링된 데이터를 플롯의 입력으로 사용합니다.
    title = paste("Group", groups[i]),                                                         # # 각 플롯 행렬의 전체 제목을 설정합니다 (예: "Group 1").
    switch = "both",                                                                           # # 축 레이블(y축은 왼쪽, x축은 아래쪽)을 매트릭스 안쪽(대각선 패널)으로 이동시켜 공간을 절약합니다.
    upper = list(continuous = custom_cor),                                                     # # 매트릭스의 대각선 위쪽(upper triangle)에 표시할 내용을 정의합니다. 여기서는 변수 간의 상관계수를 보여주는 사용자 정의 함수 `custom_cor`를 사용합니다.
    lower = list(continuous = wrap("points", alpha = 0.5, size = 0.7, color = point_color)),   # # 대각선 아래쪽(lower triangle)에는 산점도(points)를 그립니다.
                                                                                               # # alpha: 점의 투명도를 50%로 설정합니다.
                                                                                               # # size: 점의 크기를 0.7로 설정합니다.
                                                                                               # # color: 위에서 지정한 `point_color` 변수를 점의 색상으로 사용합니다.
    diag = list(continuous = wrap("densityDiag", color = density_color, fill = density_fill)), # # 대각선 패널에는 각 변수의 밀도 그래프(densityDiag)를 그립니다.
                                                                                               # # color: 밀도 그래프의 선 색상을 위에서 지정한 `density_color`로 설정합니다.
                                                                                               # # fill: 밀도 그래프의 내부 영역 색상을 위에서 지정한 `density_fill`로 설정합니다.
    progress = FALSE                                                                           # # 플롯 생성 중 진행률 표시줄이 나타나지 않도록 설정합니다.
  ) +
    theme(                                                                                     # # 플롯의 데이터 외적인 요소(배경, 축 텍스트 등)를 상세하게 조정합니다.
      aspect.ratio = 1,                                                                        # # 각 개별 플롯 패널의 가로세로 비율을 1:1 (정사각형)로 만듭니다.
      axis.text.x = element_blank(),                                                           # # x축의 눈금 숫자(레이블)를 제거합니다.
      axis.text.y = element_blank(),                                                           # # y축의 눈금 숫자(레이블)를 제거합니다.
      axis.ticks = element_blank(),                                                            # # x축과 y축의 눈금 표시를 모두 제거합니다.
      panel.background = element_blank(),                                                      # # 각 플롯 패널의 배경을 제거하여 흰색으로 만듭니다.
      strip.background = element_blank(),                                                      # # 각 열과 행의 변수 이름(예: Var1, Var2)이 표시되는 스트립(strip)의 배경을 제거합니다.
      strip.text = element_text(size = 8, face = "bold")                                       # # 스트립의 텍스트(변수 이름) 크기를 8로, 글씨체를 굵게(bold) 설정합니다.
    )
  
  plot_list[[i]] <- plot                                                                       # # 완성된 플롯을 `plot_list`의 i번째 요소로 저장합니다.
}

# 5. 여러 플롯을 한 화면에 배열
#----------------------------------------------------------------#
grid.arrange(
  grobs = lapply(plot_list, ggmatrix_gtable),                                                  # # `plot_list`에 저장된 모든 ggpairs 객체들을 `grid.arrange`가 이해할 수 있는 gtable 형태로 변환하여 전달합니다.
  ncol = 5                                                                                     # # 모든 플롯을 5개의 열(column)을 가지는 그리드 형태로 배열합니다. (플롯이 5개이므로 한 줄로 표시됩니다.)
)

```

<img width="850" height="280" alt="image" src="https://github.com/user-attachments/assets/2cb0da01-6e18-4c39-9472-b81df19172a4" />


# 데이터가 어떻게 생겼는지 좀 더 자세하게 말씀주시면 도움 드릴 수 있도록 하겠습니다...

11015khw@gmail.com
