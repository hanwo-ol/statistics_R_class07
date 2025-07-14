각 분야별로 고차원 텐서 데이터를 생성하고 `dim()` 함수로 차원을 확인하는 예시 R 코드입니다.

-----

### **기계공학 (Mechanical Engineering) ⚙️**

  * **시나리오**: 10x10x5 크기의 3D 격자에서 20개의 시간 단계에 걸쳐 유체의 압력(pressure)과 속도(velocity)를 시뮬레이션한 데이터입니다.
  * **데이터**: CFD 시뮬레이션 결과
  * **코드**:

<!-- end list -->

```r
# 5차원 텐서 생성: (x, y, z, time, variable)
# 10x10x5 공간 격자, 20개 시간 단계, 2개 변수(압력, 속도)
cfd_data <- array(
  rnorm(10 * 10 * 5 * 20 * 2), 
  dim = c(10, 10, 5, 20, 2),
  dimnames = list(
    x_coord = 1:10,
    y_coord = 1:10,
    z_coord = 1:5,
    time_step = 1:20,
    variable = c("pressure", "velocity")
  )
)

# 차원 확인
cat("## 기계공학: CFD 데이터 차원 ##\n")
print(dim(cfd_data))
```

  * **결과**: `[1] 10 10 5 20 2`는 데이터가 **10x10x5 공간, 20개 시간 단계, 2개 변수**로 구성되었음을 보여줍니다.

-----

### **생태조경 (Landscape Architecture and Ecology) 🌳**

  * **시나리오**: 특정 국립공원을 256x256 픽셀 해상도로, 5년간(계절별로 1회) 120개의 초분광 밴드로 촬영한 위성 이미지 데이터입니다.
  * **데이터**: 다중시기 초분광 이미지
  * **코드**:

<!-- end list -->

```r
# 5차원 텐서 생성: (longitude, latitude, band, year, season)
# 256x256 픽셀, 120개 분광 밴드, 5년, 4계절
# 데이터가 매우 크므로 작은 크기로 예시를 만듭니다. (50x50 픽셀, 10밴드, 2년, 4계절)
landsat_data <- array(
  runif(50 * 50 * 10 * 2 * 4), 
  dim = c(50, 50, 10, 2, 4),
  dimnames = list(
    lon = 1:50,
    lat = 1:50,
    band = 1:10,
    year = c("2023", "2024"),
    season = c("Spring", "Summer", "Fall", "Winter")
  )
)

# 차원 확인
cat("## 생태조경: 위성 이미지 데이터 차원 ##\n")
print(dim(landsat_data))
```

  * **결과**: `[1] 50 50 10 2 4`는 **50x50 해상도, 10개 분광 밴드, 2년, 4계절**의 데이터를 의미합니다.

-----

### **사회학 (Sociology) 👨‍👩‍👧‍👦**

  * **시나리오**: 5개 국가에서 500명을 대상으로 3년간(매년) 20개 문항의 설문조사를 진행한 패널 데이터입니다.
  * **데이터**: 다국적 패널 서베이
  * **코드**:

<!-- end list -->

```r
# 4차원 텐서 생성: (participant, question, year, country)
# 500명 응답자, 20개 문항, 3개년, 5개 국가
survey_data <- array(
  sample(1:5, 500 * 20 * 3 * 5, replace = TRUE), 
  dim = c(500, 20, 3, 5),
  dimnames = list(
    participant_id = 1:500,
    question_id = paste0("Q", 1:20),
    year = c(2022, 2023, 2024),
    country = c("KR", "US", "JP", "DE", "CN")
  )
)

# 차원 확인
cat("## 사회학: 패널 서베이 데이터 차원 ##\n")
print(dim(survey_data))
```

  * **결과**: `[1] 500 20 3 5`는 **응답자 500명, 문항 20개, 3년, 5개 국가**의 데이터 구조를 나타냅니다.

-----

### **분자생물학 (Molecular Biology) 🧬**

  * **시나리오**: 2가지 약물(대조군 포함 3가지 조건)을 1000개의 세포에 처리하고, 4개의 시간 지점에서 5000개 유전자의 발현량을 측정한 데이터입니다.
  * **데이터**: 단일세포 유전자 발현 데이터
  * **코드**:

<!-- end list -->

```r
# 4차원 텐서 생성: (cell, gene, condition, time_point)
# 1000개 세포, 5000개 유전자, 3개 조건, 4개 시간 지점
# 데이터 크기가 매우 크므로 축소된 예시 (100세포, 500유전자)
scrna_seq_data <- array(
  rpois(100 * 500 * 3 * 4, lambda = 5), 
  dim = c(100, 500, 3, 4),
  dimnames = list(
    cell = paste0("cell_", 1:100),
    gene = paste0("gene_", 1:500),
    condition = c("Control", "DrugA", "DrugB"),
    time = c("0h", "6h", "12h", "24h")
  )
)

# 차원 확인
cat("## 분자생물학: scRNA-seq 데이터 차원 ##\n")
print(dim(scrna_seq_data))
```

  * **결과**: `[1] 100 500 3 4`는 **100개 세포, 500개 유전자, 3가지 조건, 4개 시간 지점**의 실험 데이터임을 의미합니다.

-----

### **헬스케어공학학 (Healthcare Engineering) 🩺**

  * **시나리오**: 50명의 환자를 대상으로 64x64x32 복셀 해상도의 뇌 fMRI를 120초 동안 촬영한 데이터입니다.
  * **데이터**: 다수 환자의 fMRI 스캔
  * **코드**:

<!-- end list -->

```r
# 5차원 텐서 생성: (voxel_x, voxel_y, voxel_z, time, patient)
# 64x64x32 복셀, 120개 시간 지점, 50명 환자
# 축소된 예시 (10x10x5 복셀, 20 time, 5 환자)
fmri_data <- array(
  rnorm(10 * 10 * 5 * 20 * 5), 
  dim = c(10, 10, 5, 20, 5),
  dimnames = list(
    vx = 1:10, vy = 1:10, vz = 1:5,
    time = 1:20,
    patient_id = paste0("P", 1:5)
  )
)

# 차원 확인
cat("## 헬스케어공학: fMRI 데이터 차원 ##\n")
print(dim(fmri_data))
```

  * **결과**: `[1] 10 10 5 20 5`는 **10x10x5 해상도, 20개 시간 지점, 5명 환자**의 데이터 구조를 보여줍니다.

-----

### **스마트팜 (Smart Farm Science) 🍓**

  * **시나리오**: 4개의 구역으로 나뉜 스마트팜에 10개의 센서가 설치되어 3가지 환경 변수(온도, 습도, 조도)를 24시간 동안 매시간 측정한 데이터입니다.
  * **데이터**: 스마트팜 다중 센서 데이터
  * **코드**:

<!-- end list -->

```r
# 4차원 텐서 생성: (zone, sensor_id, variable, time)
# 4개 구역, 10개 센서, 3개 변수, 24시간
smartfarm_data <- array(
  rnorm(4 * 10 * 3 * 24),
  dim = c(4, 10, 3, 24),
  dimnames = list(
    zone = c("A", "B", "C", "D"),
    sensor = paste0("S", 1:10),
    variable = c("Temp", "Humidity", "Light"),
    hour = 0:23
  )
)

# 차원 확인
cat("## 스마트팜: 센서 데이터 차원 ##\n")
print(dim(smartfarm_data))
```

  * **결과**: `[1] 4 10 3 24`는 **4개 구역, 10개 센서, 3개 변수, 24시간**의 측정 데이터임을 의미합니다.
