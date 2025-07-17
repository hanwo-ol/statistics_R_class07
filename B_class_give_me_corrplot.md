예시 데이터가 없어서 일부 오류가 생길 수 있습니다.(예시 데이터가 있어야 디버깅이 가능합니다. ㅠㅠ)
### 만약 오류가 생겨서 수정이 필요하거나, 예시 데이터 제공이 가능하다면,,, 아래 이메일로 메일 주시면 수정 도움 드리겠습니다.
* 11015khw@gmail.com

#### 1단계: 필요 패키지 설치 및 라이브러리 로드
*이 스크립트를 처음 실행할 때만 설치하면 됩니다.*

```R
# 1. 필요 패키지 설치
install.packages(c("terra", "tidyverse", "corrplot", "RColorBrewer", "cowplot", "sp", "GWmodel"))

# 2. 라이브러리 로드
library(terra)
library(tidyverse)
library(corrplot)
library(RColorBrewer)
library(cowplot)
library(sp)
library(GWmodel)
```

#### 2단계: 데이터 로드 및 전처리
* 자신의 환경에 맞게 이 부분을 수정해야 합니다.*

```R
# --- 사용자 설정 영역 ---

# 1. tif 파일이 저장된 폴더 경로를 지정하세요.
# 예: folder_path <- "C:/Users/MyUser/Documents/MyProject/Data"
folder_path <- "YOUR_FOLDER_PATH_HERE" # ★★★ 여기에 실제 폴더 경로를 입력하세요.

# 2. 분석할 tif 파일의 목록을 정확하게 입력하세요.
# 파일명은 폴더에 있는 이름과 정확히 일치해야 합니다. (영문 파일명 권장/ 한글 이름일 때, 거의 99퍼센트 확률로 오류 생성)
file_names_to_load <- c(
  "provision_freshwater.tif", 
  "provision_biomass.tif", 
  "cultural_landscape.tif",
  "regulating_airquality.tif", 
  "regulating_water_p.tif", 
  "regulating_water_n.tif",
  "regulating_carbon.tif", 
  "supporting_habitat.tif"
  # 필요에 따라 파일 목록을 수정하거나 추가/삭제하세요.
)

# 3. 각 파일에 해당하는 분석용 약칭(Abbreviation)을 순서에 맞게 지정하세요.
# 이 약칭이 플롯의 변수명으로 사용됩니다.
abbr_names <- c(
  "FW", "BM", "LS", "AQ", "WP_P", "WP_N", "CR", "HQ"
  # 위 파일 목록 순서와 반드시 일치해야 합니다.
)

# --- 데이터 로딩 및 처리 ---

# 1. 전체 파일 경로 생성
full_paths <- file.path(folder_path, file_names_to_load)

# 2. 파일 존재 여부 확인 (오류 방지)
files_exist <- file.exists(full_paths)
if (!all(files_exist)) {
  stop("다음 파일이 지정된 경로에 존재하지 않습니다: ", 
       paste(file_names_to_load[!files_exist], collapse = ", "))
}

# 3. 여러 tif 파일을 하나의 래스터 스택으로 불러오기
# terra::rast() 함수는 여러 파일 경로를 벡터로 받아 한 번에 처리합니다.
raster_stack <- rast(full_paths)
print("--- 래스터 파일 로드 완료 ---")

# ★★★ 중요: 래스터 데이터 확인 ★★★
# 모든 래스터의 해상도, 좌표계, 범위가 동일한지 확인하세요.
# 만약 다르다면, 기준 래스터를 정하고 terra::resample, terra::project, terra::crop 등의 함수로 통일시켜야 합니다.
print(raster_stack)

# 4. 래스터 스택에 분석용 이름 지정
names(raster_stack) <- abbr_names

# 5. 분석용 데이터프레임 생성 (NA 값은 제외)
analysis_df <- as.data.frame(raster_stack, xy = TRUE, na.rm = TRUE)
print("--- 분석용 데이터프레임 생성 완료 ---")
head(analysis_df)
```

#### 3단계: 상관관계 분석 (`corrplot` 사용)
*이 부분은 수정 없이 바로 실행할 수 있습니다.*

```R
# 1. 상관관계 분석을 위한 데이터 선택 (좌표 제외)
# dplyr::select()를 명시적으로 호출하여 다른 패키지와의 함수 충돌을 방지합니다.
cor_data <- analysis_df %>% 
  dplyr::select(all_of(abbr_names))

# 2. 피어슨 상관행렬 계산
cor_matrix <- cor(cor_data, method = "pearson")

# 3. 시각화를 위한 색상 팔레트 정의
col_palette <- colorRampPalette(c("blue", "white", "red"))(200)

# 4. 상관관계 행렬 시각화
print("--- 상관관계 행렬 시각화 (corrplot) ---")
corrplot(
  cor_matrix,
  method = "ellipse",
  type = "lower",
  addCoef.col = "black",
  tl.col = "black",
  tl.srt = 45,
  diag = FALSE,
  cl.pos = "r",
  title = "Ecosystem Service Correlation Matrix",
  mar = c(0,0,1,0),
  col = col_palette
)
```

### GWR 분석은 실제 좌표계로 형성이 된 tif파일들이 있으면 가능하니, 필요한경우 연락주세요요
