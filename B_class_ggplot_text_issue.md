이전 특강 진행 시 나왔던 질문과 제가 드렸던 답변들 입니다. 참고하시면 좋을 것 같아 찾아서 

---

# ggplot + geom_text 겹치는것 해결 안되냐?
 
답변 드린 내용
* 원본 코드
``` R
countries <-read.csv("countries.csv")
plt <-ggplot(countries, aes(x = healthexp, y = infmortality)) + geom_point()
#특정지역의표시
plt + annotate("text",
               x = countries[countries$X=="Greece","healthexp"],
               y = countries[countries$X=="Greece","infmortality"],
               label = "Greece")
#지역의표시
plt + geom_text(aes(label= X), hjust = 0, vjust =1, 
                position = position_jitter(width = 3, height = 3))
```

# 방안 1: 추가 패키지 설치: 점이 겹쳐있으면 선을 통해 해당 점이 어떤 데이터인지 표시해줌
``` R
# install.packages("GGrepel")
library(GGrepel)

plt + geom_text_repel(aes(label = X), hjust = 0, vjust = 1) 
```

---

# 방안 2: 단순 jitter 기능 활용
``` R
plt + geom_text(aes(label = X), hjust = 0, vjust = 1, 
                position = position_nudge(x = 0.5, y = 0.5))  # x, y 방향으로 이동
```

---

# 방안 3: 글씨를 기울이면 조금 더 가시성을 확보할 수 있음
``` R
plt + geom_text(aes(label = X), hjust = 0, vjust = 1, angle = 45, size = 3)
```

---

# 방안 4: 그냥 각 데이터마다 레이블을 만들어 legend 추가
``` R
# 랜덤 데이터 생성
set.seed(123)  # 재현 가능성을 위한 seed 설정
data <- data.frame(
  x = rnorm(10),
  y = rnorm(10),
  label = paste("Label", 1:10)
)

# 기본 산점도 with geom_text()
ggplot(data, aes(x = x, y = y, label = label)) +
    geom_text()


# position_jitter()를 사용하여 레이블 위치 조정
ggplot(data, aes(x = x, y = y, label = label)) +
  geom_text(position = position_jitter(width = 0.2, height = 0.2))

#?geom_text

data$point_id <- c("1","2","d","f","g","vv","sss","qwe","dsa","sad") # 레이블 지정

ggplot(data, aes(x = x, y = y, label = label, color = point_id)) +
  geom_text(position = position_jitter(width = 0.2, height = 0.2))

```
