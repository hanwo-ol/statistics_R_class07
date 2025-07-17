# statistics_R_class07


<img width="300" height="300" alt="Untitled 1" src="https://github.com/user-attachments/assets/de94d9ad-d19f-407c-815c-44183b09e658" />      

[https://github.com/hanwo-ol/statistics_R_class07/]

안녕하세요! R을 이용한 통계자료분석 강의를 위한 페이지입니다.
* 수강 중 도움이 필요하시면 손을 들어주세요!
* 파일에 오류가 생겼다면 아래 링크에서 다시 다운 받아주시면 됩니다.

---

# C과정 참고자료 다운로드 (이영미 교수님 강좌, 목요일&금요일)
* 목요일 수업 종료 후에 링크 정리해드리겠습니다.

<details> <summary> 참고자료 보기 </summary>

* **정리 중**
 
</details>


---

# B과정 데이터 및 참고자료 다운로드 (황승용 교수님 강좌, 화요일&수요일)
<details>
<summary>링크 및 예제 보기</summary>

1. 수업에 사용된 데이터 csv 파일    
[https://drive.google.com/drive/folders/1T0pNwryVx8zLN04_qjniQ_Ha0MoY1iEe?usp=sharing]    

[https://drive.google.com/file/d/1lzegHCp9Mykjqt9NX_vmxYzrlIwXc5Mn/view?usp=sharing]

2. 교재 PDF(수요일 수업 종료 후에 배포하겠습니다.)

3. 수업 코드 놓쳤어요(화요일)   
   * 설명 같이 작성된 버전: [https://github.com/hanwo-ol/statistics_R_class07/blob/main/B_class_Tues.r]

4. 수업 코드 놓쳤어요(수요일)
   * 텍스트 파일: [https://drive.google.com/file/d/1jEAXzb8Rf6sO2OSHP3eTsBsX9gD5984r/view?usp=drive_link]
   * 설명 같이 작성된 버전: [https://github.com/hanwo-ol/statistics_R_class07/blob/main/B_class_Wed.r]
  
</details>

## 수업에 사용된 내장 데이터 설명

---


---

# A과정 데이터 및 참고자료 다운로드 (최혜미 교수님 강좌, 월요일)
<details>
<summary>링크 및 예제 보기</summary>

1. 데이터 & 교재 PDF & 참고자료
[https://drive.google.com/drive/folders/1ggq9oP9Qc0Tye70EOFdpluZzqFVPIZAB?usp=sharing]

2. 의료 데이터 패키지 이용한 기초 R 실습 코드: [https://github.com/hanwo-ol/statistics_R_class07/blob/main/A_class_nhanesA_practice.r]    

3. 정치 상황 관련 데이터 이용한 실습 코드: [https://github.com/hanwo-ol/statistics_R_class07/blob/main/A_class_vdeminstitute.r]
* 데이터 설명
    * 선거 민주주의 (Electoral): 자유롭고 공정한 선거가 보장되는 정도를 측정합니다.
    * 자유 민주주의 (Liberal): 개인의 자유와 권리가 법치에 의해 보호받는 정도를 평가합니다.
    * 참여 민주주의 (Participatory): 시민들이 정치 과정에 적극적으로 참여하는 수준을 측정합니다.
    * 심의 민주주의 (Deliberative): 정치적 결정이 공적인 추론과 논증을 통해 이루어지는 정도를 평가합니다.
    * 평등 민주주의 (Egalitarian): 모든 사회 집단에 걸쳐 정치적 권력과 자원이 동등하게 분배되는 정도를 측정합니다.
* 데이터 구조
    * 형식: 데이터 프레임 (Data Frame)
    * 관측치 수: 27,913개
    * 변수 수: 4,607개
    * 최신 v15 데이터셋은 1789년부터 2024년까지 전 세계 202개 국가를 다루며, **500개 이상의 지표(indicators), 81개의 지수(indices), 5개의 상위 지수(high-level indices)** 를 포함합니다.

</details>


---
---



---

## 실습 중 궁금하신 사항 손들어주시면 달려가겠습니다~
- 실습조교: 통계학과 대학원생 김한울
- R 사용 도움 필요하신 분: 11015khw@gmail.com
- ggplot 좀 더 이쁘게 그림 다듬기: [https://blog.naver.com/d0njusey0/223089751106]

---

# A과정 질문 내용

<details>
<summary> 질문 및 답변 보기</summary>

## 파일 디렉토리 쉽게 설정하기
``` r
# 파일 경로를 path 변수에 저장합니다.
# R에서는 경로 구분자로 '\' 대신 '/'를 사용하거나 '\\'를 사용해야 합니다.
path <- "D:/R_여름특강/데이터/data/"

# path 변수와 파일명을 결합하여 전체 파일 경로를 생성하고 CSV 파일을 읽어옵니다.
body_data <- read.csv(file.path(path, "body.csv"))

# 읽어온 데이터의 처음 몇 줄을 확인합니다.
head(body_data)
```


## 한글 csv 깨짐 현상

-> fileEncoding 옵션 추가하기
``` r
df <- read.csv(file_path, fileEncoding = "CP949")
 # 또는

df <- read.csv(file_path, fileEncoding = "UTF-8")

```

## 결측치가 있는 경우 어떻게 해야할까?
* 데이터 분석 목적에 따라 다름
* 데이터 손실이 크지 않다면 na.omit으로 행을 삭제
* 중요한 데이터면 평균, 중앙값, 최빈값 등으로 대체
* 상황에 따라 0, 빈 문자열(""), "Unknown" 등으로 대체 가능


결측치를 어떻게 다루느냐에 따라 결과가 크게 달라질 수 있어서 선생님들의 데이터, 분석 목적에 따라 다르게 설정하시면 됩니다.

---

### 1. 결측치(NA, 빈값) 확인하기

먼저 데이터를 불러오고 결측치가 어디 있는지 확인합니다.

```r
df <- read.csv("파일이름.csv", fileEncoding = "CP949") # 또는 "UTF-8"
# 결측치 확인
is.na(df)
summary(df)
colSums(is.na(df))  # 각 열별 결측치 개수
```

---

### 2. 결측치 처리 방법

### 2-1. 결측치가 포함된 행/열 삭제하기

### (1) 결측치가 있는 행 삭제

```r
df_no_na <- na.omit(df)
# 또는
df_no_na <- df[complete.cases(df), ]
```

### (2) 결측치가 있는 열 삭제

```r
df_no_na_col <- df[, colSums(is.na(df)) == 0]
```

---

### 2-2. 결측치를 특정 값으로 대체하기

### (1) 0 또는 평균, 중앙값 등으로 대체

```r
# age 열의 결측치를 0으로 대체
df$age[is.na(df$age)] <- 0

# age 열의 결측치를 평균으로 대체 (결측치가 아닌 값의 평균)
df$age[is.na(df$age)] <- mean(df$age, na.rm = TRUE)
```

### (2) 전체 데이터프레임에 적용

```r
# 모든 결측치를 0으로 대체
df[is.na(df)] <- 0
```

---

### 2-3. 분석 시 결측치 자동 무시

* `mean()`, `sum()`, `sd()` 등 함수에서 `na.rm=TRUE` 옵션 사용

```r
mean(df$age, na.rm = TRUE)
sum(df$score, na.rm = TRUE)
```

---

### 3. 결측치 대체 함수 (`tidyverse` 패키지 활용)

`dplyr`과 `tidyr` 패키지에서 결측치 처리가 더 쉬워집니다.

```r
library(dplyr)
df <- df %>% mutate(age = ifelse(is.na(age), 0, age))
```

또는

```r
library(tidyr)
df <- df %>% replace_na(list(age = 0, score = 100))
```

---


## 티블 또는 데이터 프레임에 변수(column) 추가하기
`dplyr` 패키지의 `mutate()` 함수를 사용하면 간단하게 해결할 수 있습니다.

### `dplyr::mutate()` 함수 사용하기

`mutate()` 함수는 기존 데이터 프레임에 새로운 변수(열)를 추가하거나 기존 변수를 수정할 때 사용합니다.

```r
# 기존 티블과 새로운 벡터를 생성
tb_king <- dplyr::tibble(
  id = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
  kname = c("ads", "adgad", "adeeg", "adsgah", "rty ", "wyn ", "sfgsd ", "sfg ", "sg ", "sggggg "),
  ltime = c(73, 62, 55, 53, 38, 16, 51, 19, 37, 30)
)

nchildren <- c(13, 23, 29, 22, 3, 0, 5, 3, 28, 5)

# mutate() 함수를 사용하여 nchildren 열을 추가합니다.
tb_king <- tb_king %>%
  dplyr::mutate(nchildren = nchildren)

# 결과 확인
tb_king
```

-----

### 실행 결과

위 코드를 실행하면 `nchildren` 열이 성공적으로 추가된 것을 확인할 수 있습니다.

```
# A tibble: 10 × 4
      id kname    ltime nchildren
   <dbl> <chr>    <dbl>     <dbl>
 1     1 "ads"       73        13
 2     2 "adgad"     62        23
 3     3 "adeeg"     55        29
 4     4 "adsgah"    53        22
 5     5 "rty "      38         3
 6     6 "wyn "      16         0
 7     7 "sfgsd "    51         5
 8     8 "sfg "      19         3
 9     9 "sg "       37        28
10    10 "sggggg "   30         5
```

-----

### 다른 방법 (R 기본 문법)

`dplyr` 패키지 없이 R의 기본 문법인 `$` 연산자를 사용해서 열을 추가할 수도 있습니다.

```r
# '$' 연산자를 사용하여 nchildren 열 추가
tb_king$nchildren <- nchildren

# 결과 확인
tb_king
```

</details>

