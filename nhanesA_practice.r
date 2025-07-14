## 1. 데이터 준비 및 기본 정보 확인 ####

# --- 데이터 준비 ---
# nhanesA 패키지가 없다면 설치
install.packages("nhanesA")
# dplyr 패키지가 없다면 설치 (slice 함수 사용을 위해)
# install.packages("dplyr")

# 2017-2018 인구통계 데이터 불러오기
data <- nhanesA::nhanes('DEMO_J')


# --- 데이터 기본 정보 확인 ---

# 데이터의 첫 6행 확인
head(data)

# 데이터의 마지막 6행 확인
tail(data)

# 특정 행 선택 (5번째부터 10번째 행까지)
# dplyr 패키지의 slice 함수 사용
dplyr::slice(data, 5:10)

# 데이터 객체의 속성 확인 (이름, 행 이름, 클래스 등)
attributes(data)

# 데이터 구조(structure) 확인 (각 열의 데이터 타입과 미리보기)
str(data)

# 데이터 차원 확인 (행의 수, 열의 수)
dim(data)

# 행의 개수 확인
nrow(data)

# 열(변수)의 개수 확인
ncol(data)

# 열의 이름 확인
names(data)
# colnames(data) 와 동일합니다.

# 데이터의 기술통계 요약 정보 확인
# 수치형 변수는 사분위수, 평균 등을 보여주고 범주형 변수는 빈도를 보여줍니다.
summary(data)



## 2. 벡터 생성 및 관련 함수 실습 ####
# c() : 벡터 생성 (combine)
my_vector <- c(10, 20, 30, 40, 50)
print(my_vector)

# seq() : 연속된 숫자 벡터 생성 (sequence)
# 1부터 10까지 2씩 증가하는 시퀀스
seq_vector <- seq(from = 1, to = 10, by = 2) 
print(seq_vector)

# : (콜론 연산자) : 1씩 증가하는 연속된 정수 벡터 생성
colon_vector <- 1:5 # c(1, 2, 3, 4, 5)와 동일
print(colon_vector)

# rep() : 벡터나 값을 반복하여 생성 (repeat)
# 3을 5번 반복
rep_vector1 <- rep(3, 5)
print(rep_vector1)

# 1, 2, 3 벡터를 2번 반복
rep_vector2 <- rep(c(1, 2, 3), 2)
print(rep_vector2)

# rev() : 벡터의 순서를 거꾸로 변경 (reverse)
rev_vector <- rev(my_vector) # my_vector는 c(10, 20, 30, 40, 50) 이었음
print(rev_vector) # 결과: 50 40 30 20 10

# length() : 벡터의 길이(원소의 개수) 확인
vec_length <- length(my_vector)
print(vec_length) # 결과: 5


## 3. 데이터 프레임 결합 (cbind, rbind) ####
# --- 실습용 데이터 프레임 생성 ---
df1 <- data.frame(id = 1:3, name = c("Kim", "Lee", "Park"))
df2 <- data.frame(age = c(25, 30, 28), gender = c("M", "F", "M"))
df3 <- data.frame(id = 4, name = "Choi", age = 40, gender = "F") # df1, df2와 구조가 다름


# cbind() : 열(column) 기준으로 좌우 결합
# df1과 df2는 행의 수가 같으므로 cbind 가능
combined_col <- cbind(df1, df2)
print(combined_col)

# rbind() : 행(row) 기준으로 상하 결합
# rbind를 하려면 두 데이터 프레임의 열 이름과 순서가 같아야 합니다.
# 따라서 df1과 df3은 바로 rbind 할 수 없습니다.
# 여기서는 df1과 구조가 같은 새로운 데이터를 만들어 합쳐보겠습니다.
df4 <- data.frame(id = 4:5, name = c("Choi", "Jung"))
combined_row <- rbind(df1, df4)
print(combined_row)


## 4. 인덱싱(Indexing) 실습
# R의 인덱스는 1부터 시작합니다.
# 형식: data[행, 열]

# --- 단일 값 추출 ---
# 1행 2열의 값 추출 (ID, SEQN)
val_1_2 <- data[1, 2]
print(val_1_2)

# --- 행/열 추출 ---
# 3번째 행의 모든 열 추출
row_3 <- data[3, ]
print(row_3)

# 5번째 열(성별, GENDER)의 모든 행 추출
# 벡터 형태로 반환됨
col_gender_vec <- data[, 5] 
head(col_gender_vec)

# 5번째 열을 데이터 프레임 형태로 유지하며 추출
col_gender_df <- data[, 5, drop = FALSE]
head(col_gender_df)

# --- 여러 행/열 추출 ---
# 1, 3, 5번째 행의 모든 열 추출
rows_135 <- data[c(1, 3, 5), ]
print(rows_135)

# 1~5번째 행과 1~3번째 열 추출
subset_1 <- data[1:5, 1:3]
print(subset_1)

# --- 이름과 $ 기호를 이용한 열 추출 ---
# 'RIDAGEYR' (나이) 열 추출 (가장 일반적인 방법)
col_age <- data$RIDAGEYR
head(col_age)

# 대괄호 두 개를 이용한 열 추출
col_race <- data[["RIDRETH3"]]
head(col_race)

# 이름으로 여러 열 추출
cols_subset <- data[, c("SEQN", "RIAGENDR", "RIDAGEYR", "DMDBORN4")]
head(cols_subset)

# --- 조건(논리값)을 이용한 인덱싱 ---
# 30세 이상인 사람들의 데이터만 추출
# 1. 조건에 맞는 행의 인덱스를 TRUE/FALSE 벡터로 생성
over_30_condition <- data$RIDAGEYR >= 30
head(over_30_condition) # TRUE, FALSE, TRUE, TRUE, ...

# 2. TRUE인 행만 필터링
data_over_30 <- data[over_30_condition, ]
head(data_over_30)

# 남성(RIAGENDR == 1)이면서 60세 이상(RIDAGEYR >= 60)인 데이터 추출
complex_condition <- data$RIAGENDR == 1 & data$RIDAGEYR >= 40
data_male_over_60 <- data[complex_condition, ]

# 추출된 데이터의 나이와 성별만 확인
head(data_male_over_60[, c("RIAGENDR", "RIDAGEYR")])

