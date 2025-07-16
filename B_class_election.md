
데이터를 먼저 읽겠습니다.

[제21대_대통령선거_개표결과.xlsx](https://github.com/user-attachments/files/21245457/21._._.xlsx)


```R 
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)

# 1. 데이터 읽기 (skip = 1 등 옵션은 데이터 구조에 따라 필요시 추가)
df <- read_excel("C:/Users/11015/OneDrive/바탕 화면/2025stat/동별 투표.xlsx")
df(head)
```
결과
```
> head(df)
# A tibble: 6 × 14
  시도명     구시군명     읍면동명  투표구명 선거인수 투표수 더불어민주당\r\n이재명…¹…
  <chr>      <chr>        <chr>     <chr>       <dbl>  <dbl>                  <dbl>
1 전국       합계         NA        NA       44391871 3.52e7               17287513
2 서울특별시 합계(특별시) NA        NA        8293885 6.64e6                3105459
3 서울특별시 종로구       합계      NA         125901 9.93e4                  47735
4 서울특별시 NA           거소·선상투표…… NA            148 1.4 e2                     64
5 서울특별시 NA           관외사전투표…… NA          13110 1.31e4                   7527
6 서울특별시 NA           재외투표  NA           2073 1.59e3                   1033
# ℹ abbreviated name: ¹​`더불어민주당\r\n이재명`
# ℹ 7 more variables: `국민의힘\r\n김문수` <dbl>, `개혁신당\r\n이준석` <dbl>,
#   `민주노동당\r\n권영국` <dbl>, `무소속\r\n송진호` <dbl>, 계 <dbl>,
#   `무효\r\n투표수` <dbl>, 기권수 <dbl>

```

---

결과를 봐도, 원본 엑셀 열어보시면 빈칸이 많습니다. 다음 과정들을 진행하려면 구시군명은 채워줘야해요

``` R
# 2. 시도명/구시군명 NA 채우기
df <- df %>% fill(시도명, 구시군명, .direction = "down")
head(df)
```

``` 
> head(df)
# A tibble: 6 × 14
  시도명     구시군명     읍면동명  투표구명 선거인수 투표수 더불어민주당\r\n이재명…¹…
  <chr>      <chr>        <chr>     <chr>       <dbl>  <dbl>                  <dbl>
1 전국       합계         NA        NA       44391871 3.52e7               17287513
2 서울특별시 합계(특별시) NA        NA        8293885 6.64e6                3105459
3 서울특별시 종로구       합계      NA         125901 9.93e4                  47735
4 서울특별시 종로구       거소·선상투표…… NA            148 1.4 e2                     64
5 서울특별시 종로구       관외사전투표…… NA          13110 1.31e4                   7527
6 서울특별시 종로구       재외투표  NA           2073 1.59e3                   1033
# ℹ abbreviated name: ¹​`더불어민주당\r\n이재명`
# ℹ 7 more variables: `국민의힘\r\n김문수` <dbl>, `개혁신당\r\n이준석` <dbl>,
#   `민주노동당\r\n권영국` <dbl>, `무소속\r\n송진호` <dbl>, 계 <dbl>,
#   `무효\r\n투표수` <dbl>, 기권수 <dbl>
```

3번 과정은 가끔 숫자들이 문자열로 저장될 때가 많기 때문에 넣은 과정입니다. 이번 파일은 숫자로 잘 저장되어있어서 문제가 없네용

```
# 3. 숫자형 컬럼 변환(쉼표 제거)
num_cols <- c("선거인수", "투표수")
df <- df %>%
  mutate(across(all_of(num_cols), ~ as.numeric(str_replace_all(., ",", ""))))

# NA/합계/소계/기타 제외 (필요시)
#df2 <- df %>%
#  filter(!is.na(투표수), !is.na(선거인수))

```

``` R
# 4. 투표율 계산
df2 <- df %>%
  mutate(투표율 = 투표수 / 선거인수 * 100)
View(df2)
```

<img width="775" height="321" alt="image" src="https://github.com/user-attachments/assets/6cda13bc-704a-45b2-999b-a3d49b3e4ee5" />

음 잘 진행되고 있네요

``` R
# 5. 시도별/구시군별/읍면동별 투표율
시도별_투표율 <- df2 %>%
  group_by(시도명) %>%
  summarise(
    선거인수 = sum(선거인수, na.rm=TRUE),
    투표수 = sum(투표수, na.rm=TRUE)
  ) %>%
  mutate(시도별_투표율 = 투표수 / 선거인수 * 100)
head(시도별_투표율)
```

``` R
> head(시도별_투표율)
# A tibble: 6 × 4
  시도명         선거인수   투표수 시도별_투표율
  <chr>             <dbl>    <dbl>         <dbl>
1 강원특별자치도  5200841  4011571          77.1
2 경기도         45602577 35945052          78.8
3 경상남도       10872092  8492385          78.1
4 경상북도        8677361  6815587          78.5
5 광주광역시      4585973  3817503          83.2
6 대구광역시      8015811  6393827          79.8
```

``` R
구시군별_투표율 <- df2 %>%
  group_by(시도명, 구시군명) %>%
  summarise(
    선거인수 = sum(선거인수, na.rm=TRUE),
    투표수 = sum(투표수, na.rm=TRUE)
  ) %>%
  mutate(구시군별_투표율 = 투표수 / 선거인수 * 100)
head(구시군별_투표율)
```

```
> head(구시군별_투표율)
# A tibble: 6 × 5
# Groups:   시도명 [1]
  시도명         구시군명 선거인수 투표수 구시군별_투표율
  <chr>          <chr>       <dbl>  <dbl>           <dbl>
1 강원특별자치도 강릉시     538189 408393            75.9
2 강원특별자치도 고성군      70502  55213            78.3
3 강원특별자치도 동해시     220910 167254            75.7
4 강원특별자치도 삼척시     160759 126385            78.6
5 강원특별자치도 속초시     204642 151944            74.2
6 강원특별자치도 양구군      51315  40193            78.3

```

``` R
읍면동별_투표율 <- df2 %>%
  group_by(시도명, 구시군명, 읍면동명) %>%
  summarise(
    선거인수 = sum(선거인수, na.rm=TRUE),
    투표수 = sum(투표수, na.rm=TRUE)
  ) %>%
  mutate(읍면동별_투표율 = 투표수 / 선거인수 * 100)
head(읍면동별_투표율)
```

```
> head(읍면동별_투표율)
# A tibble: 6 × 6
# Groups:   시도명, 구시군명 [1]
  시도명         구시군명 읍면동명      선거인수 투표수 읍면동별_투표율
  <chr>          <chr>    <chr>            <dbl>  <dbl>           <dbl>
1 강원특별자치도 강릉시   강남동           13002   9098            70.0
2 강원특별자치도 강릉시   강동면            3790   2934            77.4
3 강원특별자치도 강릉시   거소·선상투표      325    306            94.2
4 강원특별자치도 강릉시   경포동            8747   6895            78.8
5 강원특별자치도 강릉시   관외사전투표     10413  10409           100. 
6 강원특별자치도 강릉시   교1동            20808  15709            75.5
```

```
# 6. 병합
df2 <- df %>%
  left_join(시도별_투표율 %>% select(시도명, 시도별_투표율), by = "시도명") %>%
  left_join(구시군별_투표율 %>% select(시도명, 구시군명, 구시군별_투표율), by = c("시도명", "구시군명")) %>%
  left_join(읍면동별_투표율 %>% select(시도명, 구시군명, 읍면동명, 읍면동별_투표율), by = c("시도명", "구시군명", "읍면동명"))
```

신나는 그림 그리기 시간입니다.

```
library(ggplot2)

ggplot(시도별_투표율, aes(x = reorder(시도명, 시도별_투표율), y = 시도별_투표율)) +
  geom_col(fill = "skyblue") +
  coord_flip() +  # 시도명이 많으면 가로 막대 추천
  labs(
    title = "시도별 투표율",
    x = "시도명",
    y = "투표율(%)"
  ) +
  theme_minimal()
```

<img width="1303" height="791" alt="image" src="https://github.com/user-attachments/assets/fdb7542f-4cbc-4dbb-9db6-deff53eeb2a2" />

---

```
ggplot(구시군별_투표율, aes(x = reorder(구시군명, 구시군별_투표율), y = 구시군별_투표율, fill = 시도명)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ 시도명, scales = "free_y") +
  coord_flip() +
  labs(
    title = "구시군별 투표율 (시도별 분할)",
    x = "구시군명",
    y = "투표율(%)"
  ) +
  theme_minimal()
```

<img width="2561" height="1494" alt="image" src="https://github.com/user-attachments/assets/5cc073ed-7c1c-444e-8321-a72f4d7cef74" />


---


```
library(stringr)

# 읍면동명이 "거소", "관외", "합계", "소계", "재외" 등으로 시작하는 행 제외
읍면동별_투표율_필터 <- 읍면동별_투표율 %>%
  filter(
    !str_detect(읍면동명, "^거소|^관외|^합계|^소계|^재외"),
    !is.na(읍면동별_투표율)
  )

ggplot(읍면동별_투표율_필터, aes(x = 시도명, y = 읍면동별_투표율)) +
  geom_boxplot(fill = "skyblue") +
  labs(
    title = "시도별 읍면동 투표율 분포 (박스플랏)",
    x = "시도명",
    y = "투표율(%)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

<img width="2561" height="1494" alt="image" src="https://github.com/user-attachments/assets/c287c708-3b3f-4d44-b35e-3375a74508e8" />



```
ggplot(읍면동별_투표율_필터, aes(x = 구시군명, y = 읍면동별_투표율)) +
  geom_boxplot(fill = "tomato") +
  facet_wrap(~ 시도명, scales = "free_x") +
  labs(
    title = "구시군별 읍면동 투표율 분포 (박스플랏)",
    x = "구시군명",
    y = "투표율(%)"
  ) +
  theme_minimal(base_size = 9) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

<img width="2561" height="1494" alt="image" src="https://github.com/user-attachments/assets/2a90e335-3ad5-4814-9e67-c8781caa31b4" />

이렇게 보면 눈나빠지니까 보고 싶은 시별로 보는게 눈에 이롭습니다.

---

보고싶은 시만 지정해서 해보기
```
서울_구별_투표율 <- 읍면동별_투표율_필터 %>%
  filter(시도명 == "서울특별시") %>%
  group_by(구시군명) %>%
  summarise(
    선거인수 = sum(선거인수, na.rm = TRUE),
    투표수 = sum(투표수, na.rm = TRUE),
    구별_투표율 = 투표수 / 선거인수 * 100
  )
```

<img width="871" height="791" alt="image" src="https://github.com/user-attachments/assets/1ab53298-7d31-4e1a-931f-199749e95a6c" />
