ecosystem service assesment 관련 논문의 실험을 R 특강에서 배운 "corrplot"을 통해 재현하는 과정입니다.
* 논문: Spatiotemporal differentiation and trade-offs and synergies of ecosystem services in tropical island basins: A case study of three major basins of Hainan Island
* 링크: [https://www.sciencedirect.com/science/article/pii/S0959652625001489]

---

예시 데이터가 없어서 일부 오류가 생길 수 있습니다.(예시 데이터가 있어야 디버깅이 가능합니다. ㅠㅠ)
### 만약 오류가 생겨서 수정이 필요하거나, 예시 데이터 제공이 가능하다면,,, 아래 이메일로 메일 주시면 수정 도움 드리겠습니다.
* 11015khw@gmail.com

---

* 07/18 ㅅㅅㄹ님 요청: 상관계수 글자 크기 줄이려면...?
<details> <summary> 해당 코드 열기 </summary>

corrplot에서 코드에 `cex.col` 인자를 추가하여 글씨 크기를 줄이고 늘릴 수 있습니다.
사실 cex.col 건드는 거보단 number.digits로 10자리까지 출력해달라고 하는게 더 강제성있긴 합니다.

``` R
corrplot(
  cor_matrix,
  method = "ellipse",       # 타원 형태로 표현
  type = "lower",           # 아래쪽 삼각형만 표시
  addCoef.col = "black",    # 상관계수 색상
  cex.col = 0.7,            # 상관계수 글씨 크기 조절 (👈 이 부분)
  tl.col = "black",         # 변수명 텍스트 색상
  number.digits = 2         # 또는!!!!  👈 소수점 자리수 2로 지정
  tl.srt = 45,              # 변수명 텍스트 회전 각도
  diag = TRUE,              # 대각선 표시
  cl.pos = "r",             # 범례 위치 (오른쪽)
  title = "Ecosystem Service Correlation Matrix",
  mar = c(0,0,1,0),         # 그래프 여백 조정 (하, 좌, 상, 우)
  col = col_palette         # 위에서 정의한 색상 팔레트 사용
)
```

</details>     

---

만든 플랏의 크기를 지정해서 저장하고 싶다면...
* `B_class_how_to_save_my_plot.md`를 참고하세요!

---

#### 1단계: 필요 패키지 설치 및 라이브러리 로드
* 이 스크립트를 처음 실행할 때만 설치하면 됩니다.*
* 처음 까실 때 시간이 무지막지하게 걸립니다...

  
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

<details> <summary> 보통의 경우의 방법 </summary>

#### 2단계: 데이터 로드 및 전처리
* 자신의 환경에 맞게 이 부분을 수정해야 합니다.
    
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
  diag = TRUE,
  cl.pos = "r",
  title = "Ecosystem Service Correlation Matrix",
  mar = c(0,0,1,0),
  col = col_palette
)
```

</details>

<details> <summary> 현재 디렉토리를 기준으로 파일 불러서 처리하기 </summary>

``` R

# --- 필요 패키지 로드 ---
# install.packages(c("terra", "dplyr", "corrplot")) # 최초 1회만 실행
library(terra)
library(dplyr)
library(corrplot)

# --- 1단계: 설정 (Configuration) ---

# 1. tif 파일이 저장된 폴더 경로 지정
# 현재 작업 폴더에 파일이 있으므로 경로를 "."으로 설정합니다.
folder_path <- "."

# 2. 파일명과 그에 해당하는 약칭(Abbreviation)을 매핑(mapping)합니다.
# 이 방식은 파일 순서가 바뀌어도 정확한 약칭을 찾아주므로 매우 안정적입니다.
file_abbr_map <- c(
  "provision_freshwater.tif"  = "FW",
  "provision_biomass.tif"     = "BM",
  "cultural_landscape.tif"    = "LS",
  "regulating_airquality.tif" = "AQ",
  "regulating_water_p.tif"    = "WP_P",
  "regulating_water_n.tif"    = "WP_N",
  "regulating_carbon.tif"     = "CR",
  "supporting_habitat.tif"    = "HQ"
  # 필요에 따라 이 목록을 수정, 추가, 삭제하세요.
)

# --- 2단계: 데이터 로딩 및 전처리 ---

# 1. 설정된 폴더에서 .tif로 끝나는 모든 파일 목록을 자동으로 가져옵니다.
file_paths_to_load <- list.files(path = folder_path, pattern = "\\.tif$", full.names = TRUE)

# 2. 파일이 하나도 없는 경우 오류 메시지를 출력하고 스크립트를 중지합니다.
if (length(file_paths_to_load) == 0) {
  stop("지정된 폴더에 .tif 파일이 없습니다. 경로를 확인해주세요: ", folder_path)
}

# 3. 불러온 raster 데이터를 저장할 비어있는 리스트(list)를 생성합니다.
raster_data_list <- list()

# 4. for 반복문을 사용하여 각 tif 파일을 하나씩 처리합니다.
cat("--- TIF 파일 로딩 시작 ---\n")
for (file_path in file_paths_to_load) {
  file_name <- basename(file_path)
  abbr_name <- file_abbr_map[file_name]
  
  if (is.na(abbr_name)) {
    warning(paste("다음 파일에 대한 약칭이 정의되지 않았습니다 (건너뜀):", file_name))
    next 
  }
  
  raster_data_list[[abbr_name]] <- rast(file_path)
  cat(paste(" - 로딩 완료:", file_name, "-> 변수명:", abbr_name, "\n"))
}
cat("--- 모든 파일 로딩 완료 ---\n\n")

# 5. 여러 tif 파일을 하나의 래스터 스택으로 합치기
# 리스트에 저장된 래스터 객체들을 사용하여 스택을 생성합니다.
raster_stack <- rast(raster_data_list)
print("--- 래스터 파일 스택 생성 완료 ---")

# ★★★ 중요: 래스터 데이터 확인 ★★★
# 모든 래스터의 해상도, 좌표계, 범위가 동일한지 확인하세요.
# 만약 다르다면, 기준 래스터를 정하고 terra::resample, terra::project, terra::crop 등의 함수로 통일시켜야 합니다.
print(raster_stack)

# 6. 래스터 스택에 지정된 이름이 있는지 확인하고, 분석용 'abbr_names' 벡터 생성
# 이 변수가 후속 분석 코드와의 호환성을 위해 반드시 필요합니다.
abbr_names <- names(raster_stack)
if (is.null(abbr_names) || length(abbr_names) == 0) {
  stop("래스터 스택에 이름이 지정되지 않았습니다. file_abbr_map 설정을 확인하세요.")
}
cat("\n분석에 사용될 변수명 (abbr_names):\n")
print(abbr_names)

# 7. 분석용 데이터프레임 생성 (NA 값은 제외)
analysis_df <- as.data.frame(raster_stack, xy = TRUE, na.rm = TRUE)
print("\n--- 분석용 데이터프레임 생성 완료 ---")
head(analysis_df)


# --- 3단계: 상관관계 분석 (`corrplot` 사용) ---

# 1. 상관관계 분석을 위한 데이터 선택 (좌표 x, y 제외)
# dplyr::select()를 명시적으로 호출하여 다른 패키지와의 함수 충돌을 방지합니다.
cor_data <- analysis_df %>% 
  dplyr::select(all_of(abbr_names))

# 2. 피어슨 상관행렬 계산
cor_matrix <- cor(cor_data, method = "pearson")

# 3. 시각화를 위한 색상 팔레트 정의
col_palette <- colorRampPalette(c("#0000FF", "#FFFFFF", "#FF0000"))(200) # Blue-White-Red

# 4. 상관관계 행렬 시각화
print("\n--- 상관관계 행렬 시각화 (corrplot) ---")
corrplot(
  cor_matrix,
  method = "ellipse",       # 타원 형태로 표현
  type = "lower",           # 아래쪽 삼각형만 표시
  addCoef.col = "black",    # 상관계수 색상
  tl.col = "black",         # 변수명 텍스트 색상
  tl.srt = 45,              # 변수명 텍스트 회전 각도
  diag = TRUE,              # 대각선 표시
  cl.pos = "r",             # 범례 위치 (오른쪽)
  title = "Ecosystem Service Correlation Matrix",
  mar = c(0,0,1,0),         # 그래프 여백 조정 (하, 좌, 상, 우)
  col = col_palette         # 위에서 정의한 색상 팔레트 사용
)


```


</details>


<details> 

<summary> 나 </summary>

``` R
# 1. 필요 패키지 설치
#install.packages(c("terra", "tidyverse", "corrplot", "RColorBrewer", "cowplot", "sp", "GWmodel"))

# 2. 라이브러리 로드
library(terra)
library(tidyverse)
library(corrplot)
library(RColorBrewer)
library(cowplot)
library(sp)
library(GWmodel)

setwd("C:/Users/11015/Downloads/tifs")
getwd()


# --- 1단계: 설정 (Configuration) ---

# 1. tif 파일이 저장된 폴더 경로 지정
# 현재 작업 폴더에 파일이 있으므로 경로를 "."으로 설정합니다.
folder_path <- "."

# 2. 파일명과 그에 해당하는 약칭(Abbreviation)을 매핑(mapping)합니다.
# 이 방식은 파일 순서가 바뀌어도 정확한 약칭을 찾아주므로 매우 안정적입니다.
file_abbr_map <- c(
  "coastal_risk_reduction_for_coastal_populations_thresholded.tif"  = "CR",
  "nitrogen_retention_for_downstream_populations.tif"     = "NR",
  "sediment_retention_for_downstream_populations.tif"    = "SR",
  "nature_access_for_people.tif" = "NA"#,
  #"regulating_water_p.tif"    = "WP_P",
  #"regulating_water_n.tif"    = "WP_N",
  #"regulating_carbon.tif"     = "CR",
  #"supporting_habitat.tif"    = "HQ"
  # 필요에 따라 이 목록을 수정, 추가, 삭제하세요.
)

# --- 2단계: 데이터 로딩 및 전처리 ---

# 1. 설정된 폴더에서 .tif로 끝나는 모든 파일 목록을 자동으로 가져옵니다.
file_paths_to_load <- list.files(path = folder_path, pattern = "\\.tif$", full.names = TRUE)

# 2. 파일이 하나도 없는 경우 오류 메시지를 출력하고 스크립트를 중지합니다.
if (length(file_paths_to_load) == 0) {
  stop("지정된 폴더에 .tif 파일이 없습니다. 경로를 확인해주세요: ", folder_path)
}

# 3. 불러온 raster 데이터를 저장할 비어있는 리스트(list)를 생성합니다.
raster_data_list <- list()

# 4. for 반복문을 사용하여 각 tif 파일을 하나씩 처리합니다.
cat("--- TIF 파일 로딩 시작 ---\n")
for (file_path in file_paths_to_load) {
  file_name <- basename(file_path)
  abbr_name <- file_abbr_map[file_name]
  
  if (is.na(abbr_name)) {
    warning(paste("다음 파일에 대한 약칭이 정의되지 않았습니다 (건너뜀):", file_name))
    next 
  }
  
  raster_data_list[[abbr_name]] <- rast(file_path)
  cat(paste(" - 로딩 완료:", file_name, "-> 변수명:", abbr_name, "\n"))
}
cat("--- 모든 파일 로딩 완료 ---\n\n")

# --- ★★★ 오류 수정: 데이터 통일 (Harmonization) ★★★ ---
# 모든 래스터의 범위(extent)와 해상도(resolution)를 통일시키는 과정입니다.

cat("--- 래스터 데이터 통일 시작 ---\n")
# 1. 첫 번째 래스터를 '기준(reference)'으로 설정합니다.
reference_raster <- raster_data_list[[1]]
cat(paste("기준 래스터:", names(raster_data_list)[1], "\n"))

# 2. 통일된 래스터를 저장할 새로운 리스트를 생성합니다.
aligned_raster_list <- list()
aligned_raster_list[[names(raster_data_list)[1]]] <- reference_raster # 기준 래스터를 먼저 추가

# 3. 나머지 래스터들을 기준 래스터에 맞게 리샘플링(resample)합니다.
if (length(raster_data_list) > 1) {
  for (i in 2:length(raster_data_list)) {
    current_raster_name <- names(raster_data_list)[i]
    cat(paste(" - 처리 중:", current_raster_name, "-> 기준에 맞게 변환...\n"))
    
    # terra::resample 함수로 현재 래스터를 기준 래스터에 맞춥니다.
    # method='bilinear'는 연속적인 값에 적합한 보간법입니다.
    aligned_raster <- terra::resample(raster_data_list[[i]], reference_raster, method = "bilinear")
    
    # 변환된 래스터를 새 리스트에 추가합니다.
    aligned_raster_list[[current_raster_name]] <- aligned_raster
  }
}
cat("--- 모든 래스터 통일 완료 ---\n\n")


# 4. 통일된 래스터 리스트를 사용하여 최종 스택을 생성합니다.
raster_stack <- rast(aligned_raster_list)
print("--- 래스터 파일 스택 생성 완료 ---")
print(raster_stack)

# 5. 래스터 스택의 이름으로 분석용 'abbr_names' 벡터 생성
abbr_names <- names(raster_stack)

# 6. 분석용 데이터프레임 생성 (NA 값은 제외)
analysis_df <- as.data.frame(raster_stack, xy = TRUE, na.rm = TRUE)
print("\n--- 분석용 데이터프레임 생성 완료 ---")
head(analysis_df)


# --- 3단계: 상관관계 분석 (`corrplot` 사용) ---

# (이 부분은 수정 없이 그대로 실행됩니다)
cor_data <- analysis_df %>% 
  dplyr::select(all_of(abbr_names))

cor_matrix <- cor(cor_data, method = "pearson")

col_palette <- colorRampPalette(c("#0000FF", "#FFFFFF", "#FF0000"))(200)

print("\n--- 상관관계 행렬 시각화 (corrplot) ---")
corrplot(
  cor_matrix,
  method = "ellipse",
  type = "lower",
  addCoef.col = "black",
  tl.col = "black",
  tl.srt = 45,
  diag = TRUE,
  cl.pos = "r",
  title = "Ecosystem Service Correlation Matrix",
  mar = c(0,0,1,0),
  col = col_palette
)
```

</details>

### GWR 분석은 실제 좌표계로 형성이 된 tif파일들이 있으면 가능하니, 필요한경우 연락주세요요
