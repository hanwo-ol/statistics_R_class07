# 조교가 예습하면서 미리 해봤을 뿐, 코드가 완벽하게 같지 않을 수 있습니다.

# install.packages 함수는 CRAN(Comprehensive R Archive Network)에서 패키지를 다운로드하고 설치합니다.
# c() 함수는 여러 항목을 묶어 하나의 벡터로 만들어 줍니다.
# 'ggplot2', 'gridExtra' 등은 데이터 시각화 및 조작에 널리 사용되는 패키지들입니다.
# install.packages(c('ggplot2', 'gridExtra', 'plyr', 'GGally', 'maps', 'mapproj', 'rgl', 'corrplot', 'igraph', 'vcd', 'lawstat', 'agricolae', 'dplyr', 'MASS'))

# 데이터 파일이 저장된 폴더 경로를 변수에 저장합니다.
# 사용자의 컴퓨터 환경에 맞게 "D:\\2025여름 특강\\R\\B_data" 부분을 수정해야 합니다.
# R에서는 경로 구분자로 역슬래시(\) 대신 슬래시(/)를 사용하는 것이 좋습니다.
data_path <- "D:/2025여름 특강/R/B_data/"

# --- 1. R을 이용한 데이터 시각화 ---

### **1.1 내장 함수의 활용**

#### **1.1.1 기본 그래프**

# R에 내장된 기본 함수들을 사용하여 다양한 그래프를 생성합니다.

# R에 내장된 '버지니아 주 사망률' 데이터셋을 불러옵니다.
data(VADeaths)

# --- 막대 그래프 (Bar Plot) ---
# help() 또는 ? 함수를 사용하여 함수의 상세한 설명을 볼 수 있습니다.
# 예: ?barplot
graphics::barplot(VADeaths,
        beside = TRUE,              # TRUE로 설정 시, 각 그룹의 막대들이 옆으로 나란히 표시됩니다.
        legend = TRUE,              # 그래프에 범례를 추가합니다.
        ylim = c(0, 90),            # y축의 값 범위를 0에서 90으로 설정합니다.
        ylab = "Deaths per 1000",   # y축의 라벨(이름)을 지정합니다.
        xlab = 'group',             # x축의 라벨(이름)을 지정합니다.
        main = "Death rates in Virginia") # 그래프의 전체 제목을 지정합니다.

# --- 점 그래프 (Dot Chart) ---
# help() 또는 ? 함수를 사용하여 함수의 상세한 설명을 볼 수 있습니다.
# 예: ?dotchart
graphics::dotchart(VADeaths,
         xlim = c(0, 75),          # x축의 값 범위를 0에서 75로 설정합니다.
         xlab = "Deaths per 1000", # x축의 라벨을 지정합니다.
         main = "Death rates in Virginia") # 그래프의 제목을 지정합니다.

# --- 파이 차트 (Pie Chart) ---
# 파이 차트를 그리기 위한 예제 데이터를 생성합니다.
groupsizes <- c(18, 30, 32, 10, 10)
labels <- c("A", "B", "C", "D", "F")

# pie() 함수로 파이 차트를 생성합니다.
graphics::pie(groupsizes,                                     # 각 조각의 크기를 나타내는 숫자 벡터입니다.
              labels,                                         # 각 조각의 라벨입니다.
              col = c("grey40", "white", "grey", "black", "grey90")) # 각 조각의 색상을 지정합니다.

# --- 히스토그램 (Histogram) ---
# 표준정규분포(평균 0, 표준편차 1)를 따르는 1000개의 난수를 생성합니다.
x <- stats::rnorm(1000)

# hist() 함수로 히스토그램을 생성합니다.
# 히스토그램은 데이터의 분포를 막대 형태로 보여주는 그래프입니다.
# help() 또는 ? 함수를 사용하여 함수의 상세한 설명을 볼 수 있습니다.
# 예: ?hist
graphics::hist(x)

graphics::hist(x,
     probability = TRUE,      # TRUE로 설정 시, y축이 빈도수(frequency)가 아닌 확률 밀도(density)로 표시됩니다.
     col = 'gray90',          # 막대의 색상을 'gray90'으로 지정합니다.
     main = 'Distribution of x') # 그래프의 제목을 지정합니다.

# --- 상자 그림 (Box Plot) ---
# boxplot() 함수는 데이터의 분포를 요약하여 보여줍니다 (최솟값, 1사분위수, 중앙값, 3사분위수, 최댓값).
# help() 또는 ? 함수를 사용하여 함수의 상세한 설명을 볼 수 있습니다.
# 예: ?boxplot
graphics::boxplot(x,
        main = 'Boxplot of x',  # 그래프의 제목을 지정합니다.
        ylab = 'x')             # y축의 라벨을 지정합니다.

# iris 데이터셋을 불러옵니다.
data(iris)

# iris 데이터의 Sepal.Length(꽃받침 길이) 변수에 대한 상자 그림을 그립니다.
graphics::boxplot(iris$Sepal.Length)

# Species(종)에 따라 Sepal.Length의 분포를 비교하는 상자 그림을 그립니다.
# 'y ~ x' 형식은 x에 따라 그룹화된 y의 분포를 의미합니다.
graphics::boxplot(Sepal.Length ~ Species, data = iris)

# head() 함수는 데이터프레임의 첫 6개 행을 보여줍니다.
utils::head(iris)


# --- Q-Q 그림 (Q-Q Plot) ---
# Q-Q 그림은 두 확률 분포를 비교하거나, 데이터가 특정 분포를 따르는지 확인하는 데 사용됩니다.
X <- stats::rnorm(1000) # 기준이 되는 정규분포 데이터
A <- stats::rnorm(1000) # 비교할 데이터

# qqplot() 함수는 두 데이터셋의 분위수를 비교하는 그래프를 그립니다.
stats::qqplot(A, X)
# qqline() 함수는 Q-Q 그림에 기준선을 추가합니다. 데이터가 이 선을 잘 따르면 두 분포가 유사하다고 볼 수 있습니다.
# help() 또는 ? 함수를 사용하여 함수의 상세한 설명을 볼 수 있습니다.
# 예: ?qqline
stats::qqline(X, distribution= function(p) stats::qnorm(p))

# qqnorm() 함수는 데이터가 정규분포를 따르는지 확인하는 Q-Q 그림을 그립니다.
stats::qqnorm(X)
stats::qqline(X) # 정규분포 기준선을 추가합니다.


# --- 산점도 (Scatter Plot) ---
# iris 데이터셋의 두 변수(꽃받침 길이와 꽃잎 길이) 간의 관계를 점으로 나타냅니다.
# with() 함수는 특정 데이터셋의 컨텍스트 내에서 표현식을 평가하여, 'iris$'를 반복해서 쓰지 않게 해줍니다.
base::with(iris, graphics::plot(Sepal.Length, Petal.Length))
utils::head(iris)

# --- 산점도 행렬 (Scatter Plot Matrix) ---
# pairs() 함수는 데이터프레임의 모든 숫자형 변수 쌍에 대한 산점도를 행렬 형태로 한 번에 그려줍니다.
graphics::pairs(iris[,1:4]) # iris 데이터의 1~4번째 열을 사용합니다.


#### **1.1.2 저수준의 그래픽 함수의 활용**
이미 그려진 그래프 위에 점, 선, 텍스트 등을 추가하는 함수들입니다.

# 'indexfinger.csv' 파일을 읽어와 데이터프레임으로 저장합니다.
indexfinger <- utils::read.csv(paste0(data_path, "indexfinger.csv"))

# 'width'를 y축, 'length'를 x축으로 하는 산점도를 그립니다.
graphics::plot(width ~ length , data = indexfinger)
# with() 함수를 사용하여 3번째와 7번째 행의 데이터에 대해 다른 모양(pch=16)과 색(col='red')으로 점을 추가합니다.
base::with(indexfinger[c(3,7),], graphics::points(length, width, pch = 16, col='red'))


# 성별(sex)에 따라 점의 모양(pch)을 다르게 하여 산점도를 그립니다. 'as.character'는 M, F 문자를 모양으로 사용하게 합니다.
graphics::plot(width ~ length, pch = as.character(sex), data = indexfinger)

# abline() 함수는 직선을 추가합니다. lm() 함수로 계산된 회귀선을 그립니다.
# 성별(sex)이 'M'인 데이터에 대한 회귀선(실선, 파란색)을 추가합니다.
graphics::abline(stats::lm(width ~ length, data = indexfinger, subset = (sex == "M")), lty = 1, col='blue')
# 성별(sex)이 'F'인 데이터에 대한 회귀선(점선, 초록색)을 추가합니다.
graphics::abline(stats::lm(width ~ length, data = indexfinger, subset = (sex == "F")), lty = 2, col='green')

# legend() 함수로 그래프에 범례를 추가합니다. "topleft"는 범례 위치입니다.
graphics::legend("topleft", legend = c("M", "F"), lty = 1:2, col=c('blue','green'))

# segments() 함수는 두 점을 잇는 선분을 그립니다.
graphics::segments(x0 = 5.3, y0 = 1.9, x1 = 7.5, y1 = 1.9)
# arrows() 함수는 화살표를 그립니다.
graphics::arrows(x0 = 5.3, y0 = 1.9, x1 = 7.5, y1 = 1.9)
# text() 함수는 지정된 위치에 텍스트를 추가합니다. 이상치(outlier)를 표시합니다.
graphics::text(x=7.5, y=2.0, labels = 'outlier')


# --- 그래프 여백과 배치 ---
# par() 함수는 그래픽 파라미터(설정)를 조작합니다.
# mar 파라미터로 그래프의 여백을 설정합니다 (아래, 왼쪽, 위, 오른쪽 순).
graphics::par(mar = c(7, 5, 5, 5) + 0.1)

# 빈 그래프 영역을 만듭니다. type='n'은 'no plotting'을 의미합니다.
graphics::plot(c(1, 9), c(0, 50), type = 'n', xlab = "", ylab = "")

# 그래프 영역(Plot region) 내에 텍스트와 점을 추가합니다.
graphics::text(6, 40, "Plot region")
graphics::points(6, 20)
# adj는 텍스트 정렬을 조정합니다. adj=c(0.5, 2)는 텍스트를 점 위로 이동시킵니다.
graphics::text(6, 20, "(6, 20)", adj = c(0.5, 2))

# mtext() 함수는 그래프 여백(margin)에 텍스트를 추가합니다.
graphics::mtext(paste("Margin", 1:4), side = 1:4, line = 3) # 각 여백(1:아래, 2:왼쪽, 3:위, 4:오른쪽)에 텍스트를 추가합니다.
# 각 여백의 line 위치에 따라 텍스트를 추가하여 여백의 구조를 시각적으로 보여줍니다.
graphics::mtext(paste("Line", 0:4), side = 1, line = 0:4, at = 3, cex = 0.6) # cex는 글자 크기입니다.
graphics::mtext(paste("Line", 0:4), side = 2, line = 0:4, at = 15, cex = 0.6)
graphics::mtext(paste("Line", 0:4), side = 3, line = 0:4, at = 3, cex = 0.6)
graphics::mtext(paste("Line", 0:4), side = 4, line = 0:4, at = 15, cex = 0.6)

# par(mfrow = ...)는 그래픽 장치를 여러 개의 행과 열로 분할하여 여러 그래프를 한 번에 표시합니다.
# c(1, 2)는 1행 2열을 의미합니다.
graphics::par(mfrow = c(1, 2))
graphics::plot(width ~ length , data = indexfinger)
graphics::plot(width ~ length, pch = as.character(sex), data = indexfinger)
# 분할된 화면을 다시 원래대로 되돌리려면 par(mfrow=c(1,1))을 실행합니다.
graphics::par(mfrow=c(1,1))


# --- 그래프 저장하기 ---
# pdf() 함수는 이후에 생성되는 그래프를 PDF 파일로 저장하도록 지시합니다.
grDevices::pdf('plot.pdf', width=10, height=10)
graphics::hist(stats::rnorm(1000))
# dev.off() 함수는 현재 그래픽 장치(여기서는 PDF 파일)를 닫습니다. 이 함수를 호출해야 파일이 완전히 저장됩니다.
grDevices::dev.off()

# tiff() 함수는 TIFF 형식의 이미지 파일로 저장합니다.
grDevices::tiff('plot.tif')
graphics::hist(stats::rnorm(1000))
grDevices::dev.off()


#### **1.1.3 다양한 그래프**

# --- 3D 산점도 ---
data(mtcars)

# rgl::plot3d 함수는 3차원 산점도를 그립니다. 
# 이 플롯은 마우스로 회전, 확대, 축소가 가능합니다.
# windows()는 Windows 운영체제에서 새 그래픽 창을 열 때 사용될 수 있습니다.
# 다른 OS에서는 x11() 또는 quartz()를 사용하거나 생략할 수 있습니다.
grDevices::windows()
rgl::plot3d(mtcars$wt, mtcars$disp, mtcars$mpg,
            type = "s",    # 점의 모양을 's'(sphere, 구)로 지정합니다.
            size = 0.75,   # 점의 크기를 지정합니다.
            lit = FALSE,   # 조명 효과를 끕니다.
            xlab = "Weight", ylab = "Displacement", zlab = "MPG") # 각 축의 라벨을 지정합니다.

# --- 상관계수 행렬 그림 (Correlogram) ---
# cor() 함수는 숫자형 변수들 간의 상관계수 행렬을 계산합니다.
mcor <- stats::cor(mtcars)
# corrplot::corrplot 함수는 상관계수 행렬을 시각적으로 표현합니다.
# 색상과 원의 크기로 상관관계의 방향과 강도를 나타냅니다.
corrplot::corrplot(mcor)
# plot.new()와 dev.off()는 현재 그래픽 장치를 초기화하거나 닫기 위해 사용될 수 있습니다.
# rgl 창을 닫으려면 rgl::rgl.close() 함수를 사용하는 것이 일반적입니다.
grDevices::plot.new(); grDevices::dev.off()


# --- 네트워크 그래프 ---
# igraph 패키지를 사용하여 관계 데이터를 시각화합니다.
# c(1,2, 2,3, ...)는 (1->2, 2->3, ...) 방향을 가진 연결(edge)을 의미합니다.
gd <- igraph::graph(c(1,2, 2,3, 2,4, 1,4, 5,5, 3,6))
plot(gd)

# 방향이 없는(undirected) 네트워크 그래프를 생성합니다.
gd <- igraph::graph(c(1,2, 2,3, 2,4, 1,4, 5,5, 3,6),
                    directed = FALSE) # directed=FALSE로 설정하여 방향성을 제거합니다.
plot(gd,
     layout = igraph::layout.circle, # layout.circle은 노드를 원형으로 배치합니다.
     vertex.label = NA)              # vertex.label=NA는 노드의 라벨을 생략합니다.

# 'madmen.csv' 데이터를 읽어와 네트워크 그래프를 생성합니다.
madmen <- utils::read.csv(paste0(data_path, 'madmen.csv'))
# graph.data.frame은 두 열(from, to)로 구성된 데이터프레임으로부터 그래프를 생성합니다.
g <- igraph::graph.data.frame(madmen, directed=FALSE)
plot(g)

# --- 덴드로그램 (Dendrogram) ---
# 덴드로그램은 계층적 군집 분석(Hierarchical Clustering) 결과를 시각화한 것입니다.
countries <- utils::read.csv(paste0(data_path, 'countries.csv'), row.names = 1) # 첫 번째 열을 행 이름으로 사용합니다.
utils::head(countries)

# scale() 함수는 데이터를 표준화(평균 0, 표준편차 1)합니다. 변수 간의 단위를 맞추기 위함입니다.
d <- scale(countries)
# dist() 함수는 데이터 포인트 간의 거리(유사성)를 계산합니다.
# hclust() 함수는 계산된 거리를 바탕으로 계층적 군집 분석을 수행합니다.
hc <- stats::hclust(stats::dist(d))
plot(hc)


# --- 모자이크 그림 (Mosaic Plot) ---
# 모자이크 그림은 다차원 분할표(contingency table)를 시각화하여 변수 간의 관계를 보여줍니다.
data(UCBAdmissions) # UC 버클리 대학원 입학 데이터
# vcd::mosaic 함수를 사용하여 모자이크 그림을 생성합니다.
# ~ Dept + Gender + Admit는 세 변수 간의 관계를 보겠다는 의미입니다.
vcd::mosaic(~ Dept + Gender + Admit, data = UCBAdmissions,
            highlighting = "Admit", # 'Admit' 변수를 기준으로 색상을 강조합니다.
            highlighting_fill = c('lightblue', 'pink'), # 강조 색상을 지정합니다.
            direction = c('v','h','v')) # 각 변수별로 분할 방향을 지정합니다 (v:수직, h:수평).


### **1.2 ggplot2의 활용**

#`ggplot2`는 '그래픽의 문법(Grammar of Graphics)'에 기반한 강력하고 유연한 시각화 패키지입니다. 데이터(data), 미적 매핑(aes), 기하 객체(geom) 등의 요소를 조립하여 그래프를 만듭니다.

#### **1.2.1 ggplot2 소개**
#`ggplot()` 함수로 기본 캔버스를 만들고, `+` 기호로 다양한 레이어(geom, theme 등)를 추가합니다.

#### **1.2.2 ggplot2 기본 그래프**

# 'diamonds' 데이터셋을 사용합니다.
utils::head(ggplot2::diamonds)
# str() 함수는 데이터프레임의 구조를 보여줍니다.
utils::str(ggplot2::diamonds)

# --- 막대 그래프 (Bar Chart) ---
# ggplot() 함수로 그래프 객체를 생성합니다. 데이터와 aes(미적 매핑)를 지정합니다.
# aes(x=cut)는 x축에 'cut' 변수를 매핑하겠다는 의미입니다.
ggplot2::ggplot(ggplot2::diamonds, ggplot2::aes(x=cut))+
  # geom_bar()는 막대 그래프 레이어를 추가합니다.
  # stat='count'는 각 'cut' 범주의 개수를 세어 막대 높이로 사용하겠다는 의미입니다.
  ggplot2::geom_bar(stat = 'count',
                    fill = 'green',    # 막대의 채우기 색상
                    colour = 'orange') # 막대의 테두리 색상

# 'cut'에 따라 색상(fill)을 다르게 하여 누적 막대 그래프를 그립니다.
ggplot2::ggplot(ggplot2::diamonds, ggplot2::aes(x=color, fill = cut))+
  ggplot2::geom_bar(stat = 'count')+
  # theme_bw()는 흑백 배경 테마를 적용합니다.
  ggplot2::theme_bw()

# 'climate.csv' 데이터를 읽어옵니다.
climate <- utils::read.csv(paste0(data_path, 'climate.csv'))
utils::head(climate)

# |> (네이티브 파이프) 또는 %>% (magrittr 파이프)는 왼쪽의 결과를 오른쪽 함수의 첫 번째 인자로 전달합니다.
# Anomaly10y 값이 0 이상이면 'Pos', 아니면 'Neg'인 'pos_neg' 변수를 추가합니다.
plt1 <- climate |>
  dplyr::mutate(pos_neg = ifelse(Anomaly10y>=0, 'Pos', 'Neg')) |>
  ggplot2::ggplot(ggplot2::aes(x=Year, y=Anomaly10y, fill = pos_neg))+
  # stat='identity'는 y축 값을 데이터에 있는 그대로(Anomaly10y) 사용하겠다는 의미입니다.
  ggplot2::geom_bar(stat = 'identity')

plt2 <- climate |>
  dplyr::mutate(pos_neg = ifelse(Anomaly10y>=0, 'Pos', 'Neg')) |>
  ggplot2::ggplot(ggplot2::aes(x=Year, y=Anomaly10y, fill = pos_neg))+
  ggplot2::geom_bar(stat = 'identity', colour = 'black', size=0.25)+
  # scale_fill_manual()은 채우기 색상을 수동으로 지정합니다.
  ggplot2::scale_fill_manual(values = c("blue", 'orange'))

# gridExtra::grid.arrange()는 여러 ggplot 그래프를 한 화면에 배열합니다.
gridExtra::grid.arrange(plt1, plt2, ncol = 2) # 2열로 배열
gridExtra::grid.arrange(plt2, plt1, ncol = 2)


# --- 점 그림 (Dot Plot) ---
tophitters <- utils::read.csv(paste0(data_path, "tophitters.csv"))
utils::head(tophitters)
# geom_point()로 점 그림을 그립니다.
ggplot2::ggplot(tophitters,ggplot2::aes(x=avg, y=name))+
  ggplot2::geom_point()

# reorder(name, avg)는 avg(타율) 값에 따라 name(선수 이름)의 순서를 재정렬합니다.
ggplot2::ggplot(tophitters,ggplot2::aes(x=avg, y=reorder(name, avg)))+
  ggplot2::geom_point()+
  # labs()로 축이나 제목의 라벨을 변경합니다.
  ggplot2::labs(y = 'name')

# 리그(lg)와 타율(avg) 순으로 정렬된 선수 이름의 순서를 만듭니다.
name.order <- tophitters$name[order(tophitters$lg, tophitters$avg)]
# factor() 함수를 사용하여 name 변수를 위에서 정의한 순서를 가진 요인(factor)으로 변환합니다.
tophitters$name <- factor(tophitters$name, levels = name.order)

ggplot2::ggplot(tophitters, ggplot2::aes(x=avg, y=name))+
  ggplot2::geom_point(size = 3, ggplot2::aes(colour = lg))+
  # facet_grid()는 특정 변수(lg)의 값에 따라 그래프를 여러 패널로 분리합니다.
  # scales = 'free_y'는 각 패널의 y축이 독립적인 범위를 갖도록 합니다.
  # space = 'free_y'는 각 패널의 높이가 y축 범주 수에 비례하도록 합니다.
  ggplot2::facet_grid(lg ~., scale = 'free_y', space = 'free_y')


# --- 파이 차트 (Pie Chart) ---
# ggplot2에는 직접적인 파이 차트 geom이 없습니다.
# 막대 그래프를 그린 후 coord_polar()를 이용해 극좌표계로 변환하여 만듭니다.
ggplot2::ggplot(ggplot2::diamonds, ggplot2::aes(factor(1), fill = cut))+
  ggplot2::geom_bar(stat = 'count',
                    width = 1) + # width=1은 막대 사이의 간격을 없애줍니다.
  # coord_polar()는 데카르트 좌표계를 극좌표계로 변환합니다.
  # theta = 'y'는 y축 값(여기서는 count)을 각도로 매핑합니다.
  ggplot2::coord_polar(theta = 'y')

# --- 선 그래프 (Line Chart) ---
utils::str(ToothGrowth) # 기니피그 치아 성장 데이터

# supp(보조제 종류)와 dose(복용량)에 따라 평균 길이를 계산합니다.
ToothGrowth |>
  dplyr::group_by(supp, dose) |> # supp와 dose로 그룹화
  dplyr::summarise(mean_len = mean(len, na.rm=TRUE))|> # 각 그룹의 평균 계산
  ggplot2::ggplot(ggplot2::aes(x=dose, y=mean_len, group=supp, color =supp))+
  ggplot2::geom_line(linetype = 'dashed')+ # 점선으로 선 그래프 추가
  ggplot2::geom_point(size = 3, shape = 3) # 십자 모양 점 추가

# --- 영역 차트 (Area Chart) ---
uspopage <- utils::read.csv(paste0(data_path, 'uspopage.csv'))
utils::head(uspopage)

# geom_area()는 x축과 선 사이의 영역을 채우는 그래프를 그립니다.
ggplot2::ggplot(uspopage, ggplot2::aes(x = Year, y = Thousands, fill = AgeGroup))+
  ggplot2::geom_area(alpha=0.4)+ # alpha는 투명도를 조절합니다.
  # scale_fill_brewer()는 미리 정의된 색상 팔레트를 적용합니다.
  ggplot2::scale_fill_brewer(palette = 'Blues')+
  # position = 'stack'은 각 그룹의 선이 아래 그룹의 선 위에서 시작되도록 합니다.
  ggplot2::geom_line(position = 'stack', size=0.2)


# --- 리본 차트 (Ribbon Chart) ---
# 리본 차트는 두 선 사이의 영역을 채워 불확실성이나 범위를 나타낼 때 유용합니다.
utils::head(climate)

# UB(상한)와 LB(하한) 변수를 생성합니다.
climate |>
  dplyr::mutate(UB = Anomaly10y + Unc10y,
                LB = Anomaly10y - Unc10y)|>
  ggplot2::ggplot(ggplot2::aes(x=Year, y=Anomaly10y))+
  ggplot2::geom_line()+ # 중앙 추정치 선
  ggplot2::geom_line(ggplot2::aes(y = UB), linetype='dotted')+ # 상한선
  ggplot2::geom_line(ggplot2::aes(y = LB), linetype='dotted')  # 하한선

# geom_ribbon()을 사용하여 상한과 하한 사이의 영역(불확실성)을 채웁니다.
climate |>
  dplyr::mutate(UB = Anomaly10y + Unc10y,
                LB = Anomaly10y - Unc10y)|>
  ggplot2::ggplot(ggplot2::aes(x=Year, y=Anomaly10y))+
  ggplot2::geom_line()+ # 중앙선
  ggplot2::geom_ribbon(ggplot2::aes(ymin=LB, ymax=UB), alpha = 0.4) # 불확실성 리본

# --- 히스토그램과 밀도 그림 ---
# MASS 패키지의 birthwt(신생아 출생 체중) 데이터를 사용합니다.
birthwt_dat<-MASS::birthwt
utils::str(birthwt_dat)

# geom_histogram()으로 히스토그램을 그립니다.
ggplot2::ggplot(birthwt_dat, ggplot2::aes(x = bwt))+
  ggplot2::geom_histogram(fill = 'white',
                          colour = 'black',
                          bins=30) # bins는 막대의 개수를 지정합니다.

# 흡연 여부(smoke)에 따라 히스토그램을 분리하여 그립니다.
birthwt_dat |>
  dplyr::mutate(smoke1 = ifelse(smoke==0, 'non_smoker','smoker'))|>
  ggplot2::ggplot(ggplot2::aes(x = bwt))+
  ggplot2::geom_histogram()+
  ggplot2::facet_grid(smoke1 ~.) # smoke1 변수에 따라 수직으로 패널을 나눕니다.

# 하나의 그래프에 두 그룹의 히스토그램을 겹쳐 그립니다.
birthwt_dat |>
  dplyr::mutate(smoke1 = ifelse(smoke==0, 'non_smoker','smoker'))|>
  ggplot2::ggplot(ggplot2::aes(x = bwt, fill = smoke1))+
  ggplot2::geom_histogram(alpha=0.5, # 투명도를 주어 겹치는 부분을 볼 수 있게 합니다.
                          position = 'identity') # 각 그룹의 히스토그램을 같은 위치에서 시작하게 합니다.

# geom_freqpoly()는 빈도 다각형(frequency polygon)을 그립니다. 히스토그램을 선으로 표현한 것과 유사합니다.
ggplot2::ggplot(birthwt_dat, ggplot2::aes(x = bwt))+
  ggplot2::geom_freqpoly()


# --- 상자 그림과 바이올린 그림 ---
ggplot2::ggplot(birthwt_dat, ggplot2::aes(y=bwt))+
  ggplot2::geom_boxplot()

# 흡연 여부에 따른 출생 체중 분포를 상자 그림으로 비교합니다.
birthwt_dat |>
  dplyr::mutate(smoke1 = ifelse(smoke==0, 'non_smoker','smoker'))|>
  ggplot2::ggplot(ggplot2::aes(x=smoke1, y=bwt))+
  ggplot2::geom_boxplot()+
  # coord_flip()은 x축과 y축을 서로 바꿉니다.
  ggplot2::coord_flip()

# geom_violin()은 바이올린 그림을 그립니다. 데이터의 분포를 밀도 그림 형태로 보여주며, 상자 그림과 정보를 결합한 형태입니다.
birthwt_dat |>
  dplyr::mutate(smoke1 = ifelse(smoke==0, 'non_smoker','smoker'))|>
  ggplot2::ggplot(ggplot2::aes(x=smoke1, y=bwt))+
  ggplot2::geom_violin()

# --- 산점도와 산점도 행렬 ---
hw <- utils::read.csv(paste0(data_path, 'heightweight.csv'))
utils::str(hw)

# 성별(sex)에 따라 색상(colour)과 모양(shape)을 다르게 하여 산점도를 그립니다.
ggplot2::ggplot(hw, ggplot2::aes(x=heightIn, y=weightLb, colour = sex, shape = sex))+
  ggplot2::geom_point()

# GGally::ggpairs()는 ggplot2 스타일의 산점도 행렬을 생성합니다.
# 대각선에는 각 변수의 분포(밀도), 아래쪽에는 산점도, 위쪽에는 상관계수가 표시됩니다.
GGally::ggpairs(hw)

# --- 주석과 텍스트 추가 ---
countries <- utils::read.csv(paste0(data_path, "countries.csv"), row.names = 1)
utils::head(countries)

ggplot2::ggplot(countries, ggplot2::aes(x=healthexp,y=infmortality))+
  ggplot2::geom_point()+
  # scale_x_log10()은 x축을 로그 스케일로 변환합니다. 데이터가 넓게 퍼져있을 때 유용합니다.
  ggplot2::scale_x_log10()+
  # annotate() 함수는 그래프에 고정된 위치에 주석(텍스트, 도형 등)을 추가합니다.
  ggplot2::annotate('text',
                    x=countries[which(rownames(countries) == 'Italy'), "healthexp"],
                    y=countries[which(rownames(countries) == 'Italy'), "infmortality"],
                    label = 'Italy')


# geom_text()는 각 데이터 포인트에 텍스트 라벨을 추가합니다.
ggplot2::ggplot(countries, ggplot2::aes(x=healthexp,y=infmortality))+
  ggplot2::geom_point()+
  ggplot2::scale_x_log10()+
  # aes(label = ...)은 각 점에 해당하는 라벨을 지정합니다.
  # hjust, vjust는 텍스트의 수평/수직 위치를 조정합니다.
  # check_overlap=TRUE는 겹치는 텍스트를 자동으로 제거해줍니다.
  ggplot2::geom_text(ggplot2::aes(label = rownames(countries)), hjust=0, vjust=1, size=4, check_overlap = TRUE)+
  ggplot2::theme_bw()+
  # theme() 함수는 그래프의 세부적인 디자인 요소(글자 크기, 색상, 선 모양 등)를 수정합니다.
  ggplot2::theme(axis.text = ggplot2::element_text(size=15),    # 축 텍스트 크기
                 axis.title = ggplot2::element_text(size=15))   # 축 제목 크기

# 내일은..
# --- 2. R을 이용한 자료 분석 ---

# 2.1 비율 검정 (Proportion Test)
# 2.2 교차 분석 (Chi-squared Test)
# 2.3 T-검정 (T-test)
# 2.4 분산 분석 (ANOVA)
# 2.5 회귀 분석 (Regression Analysis)
