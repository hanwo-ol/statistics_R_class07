# statistics_R_class07


<img width="1000" height="1000" alt="Untitled 1" src="https://github.com/user-attachments/assets/de94d9ad-d19f-407c-815c-44183b09e658" />


안녕하세요! R을 이용한 통계자료분석 강의를 위한 페이지입니다.
* 수강 중 도움이 필요하시면 손을 들어주세요!
* 파일에 오류가 생겼다면 아래 링크에서 다시 다운 받아주시면 됩니다.

## A과정 데이터 다운로드 (최혜미 교수님 강좌, )
1. 데이터   
[https://drive.google.com/drive/folders/1ggq9oP9Qc0Tye70EOFdpluZzqFVPIZAB?usp=sharing]

2. 교재 PDF(월요일 수업 종료 후에 배포하겠습니다.)

3. 심심할 때 보는 코드(의료 데이터 패키지 이용한 기초 R 실습 코드)
[https://github.com/hanwo-ol/statistics_R_class07/blob/main/nhanesA_practice.r]

## B과정 데이터 및 참고자료 다운로드 (황승용 교수님 강좌, )
[https://drive.google.com/drive/folders/1T0pNwryVx8zLN04_qjniQ_Ha0MoY1iEe?usp=sharing]    





## 실습 중 궁금하신 사항 손들어주시면 달려가겠습니다~
- 실습조교: 통계학과 대학원생 김한울
- R 사용 도움 필요하신 분: 11015khw@gmail.com
- ggplot 좀 더 이쁘게 그림 다듬기: [https://blog.naver.com/d0njusey0/223089751106]

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
