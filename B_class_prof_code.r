# 7월 15일 특강에서 사용된 코드입니다. 공부하실 때 참고하시면 될 것 같습니다.

install.packages(c('rgl', 'corrplot', 'igraph', 'vcd', 'lawstat', 'agricolae'))
install.packages(c('ggplot2', 'gridExtra', 'plyr', 'GGally', 'maps', 'mapproj'))

data(VADeaths)

#막대그래프
?barplot
barplot(VADeaths,
        beside = TRUE, #각 그룹의 값을 나란히(beside) 배치
        legend = TRUE, # 막대에 대한 범례(legend)를 추가
        ylim = c(0, 90), # y축의 범위를 0에서 90으로 설정
        ylab = "Deaths per 1000", # y축 레이블
        xlab = 'group',
        main = "Death rates in Virginia") # 그래프 제목

?dotchart
dotchart(VADeaths)
dotchart(VADeaths,
         xlim = c(0, 75), # x축의 범위를 0에서 75으로 설정
         xlab = "Deaths per 1000", # x축 레이블
         main = "Death rates in Virginia") # 그래프 제목

groupsizes <- c(18, 30, 32, 10, 10)
labels <- c("A", "B", "C", "D", "F")
pie
#파이차트 생성
pie(groupsizes, labels, col = c("grey40", "white", "grey", "black", "grey90"))

#히스토그램
x <- rnorm(1000) # 표준정규분포로부터 추출된 임의 표본 생성

?hist
hist(x)
hist(x,
     probability = TRUE, # 밀도 함수로 표시
     col = 'gray90',
     main = 'Distribution of x') # 막대의 색상 지정

?boxplot
boxplot(x,
        main = 'Boxplot of x',
        ylab = 'x')

data(iris)

boxplot(iris$Sepal.Length)
boxplot(Sepal.Length ~ Species,data = iris)
head(iris)


X <- rnorm(1000) # 기준 데이터
A <- rnorm(1000) # 비교 데이터

qqplot(A, X)
?qqline
qqline(X, distribution= function(p) qnorm(p))

qqnorm(X)
qqline(X)

plot(iris$Sepal.Length,
     iris$Sepal.Width,
     xlab = "",
     ylab = "",
     main = "")

pairs(iris[, 1:4])


with(iris, plot(Sepal.Length, Petal.Length))

head(iris)

pairs(iris[,1:4])


indexfinger <- read.csv("indexfinger.csv")
head(indexfinger)

plot(width ~ length,
     data = indexfinger)

with(indexfinger[c(3,7),],
     points(length, width,
            pch = 16, col='red'))


plot(width ~ length, 
     pch = as.character(sex),
     data = indexfinger)

abline(lm(width ~ length,
          data = indexfinger,
          subset = (sex == "M")),
       lty = 1, col='blue')

abline(lm(width ~ length,
          data = indexfinger,
          subset = (sex == "F")),
       lty = 2, col='red')

legend("topleft", 
       legend = c("M", "F"), 
       lty = c(1,2), 
       col=c('blue','red'))

segments(x0 = 5.3, y0 = 1.9,
         x1 = 7.5, y1 = 1.9)
arrows(x0 = 5.3, 
       y0 = 1.9, 
       x1 = 7.5, 
       y1 = 1.9)
text(x=7.5, y=2.0, labels = 'outlier')

?points
?legend


# 그래프 여백 설정
?par
par(mar = c(7, 5, 5, 5) + 0.1)
# 빈 그래프 그리기
plot(c(1, 9), c(0, 50), type = 'n', xlab = "", ylab = "")

text(6, 40, "Plot region")

points(6, 20)

text(6, 20, "(6, 20)", adj = c(0.5, 2))


mtext(paste("Margin", 1:4), side = 1:4, line = 3)
# 특정 위치에 텍스트 추가
mtext(paste("Line", 0:4), side = 1, line = 0:4, at = 3, cex = 0.6)
mtext(paste("Line", 0:4), side = 2, line = 0:4, at = 15, cex = 0.6)
mtext(paste("Line", 0:4), side = 3, line = 0:4, at = 3, cex = 0.6)
mtext(paste("Line", 0:4), side = 4, line = 0:4, at = 15, cex = 0.6)


par(mfrow = c(1, 2))

plot(width ~ length, 
     data = indexfinger)

plot(width ~ length,
     pch = as.character(sex),
     data = indexfinger)

par(mfrow = c(2, 1))

plot(width ~ length, 
     data = indexfinger)

plot(width ~ length,
     pch = as.character(sex),
     data = indexfinger)


pdf('plot.pdf', width=10, height=10)
hist(rnorm(1000))
dev.off()

tiff('plot.tif')
hist(rnorm(1000))
dev.off()

?pdf

?tiff


data(mtcars)
mtcars
?mtcars
#install.packages('rgl')
#install.packages("xfun")
rgl::plot3d(mtcars$w,
            mtcars$disp,
            mtcars$mpg,
            #type = "s", # 점의 형태 "s" 는 구의 형태
            size = 20, # 점의 크기
            #lit = FALSE, # 조명 효과
            xlab = "Weight",
            ylab = "Displacement",
            zlab = "MPG")

mcor <- cor(mtcars)
corrplot::corrplot(mcor)
plot.new(); dev.off()


gd <- igraph::graph(c(1,2, 2,3, 2,4, 1,4, 5,5, 3,6))
plot(gd)
# 방향이 없는 네트워크
gd <- igraph::graph(c(1,2, 2,3, 2,4, 1,4, 5,5, 3,6),
                    directed = FALSE) # 방향이 없는 네트워크
plot(gd,
     layout = igraph::layout.circle, # 원형 레이아웃
     vertex.label = NA) # 텍스트 레이블 생략

madmen <- read.csv('madmen.csv')
g <- igraph::graph.data.frame(madmen, directed=FALSE)
plot(g)

# 덴드로그램
countries <- read.csv('countries.csv', row.names = 1)
head(countries)
d<-scale(countries)
hc<-hclust(dist(d))
plot(hc)


UCBAdmissions
vcd::mosaic(~ Dept + Gender + Admit, data = UCBAdmissions,
            highliting = "Admit",
            highliting_fill = c('lightblue', 'pink'),
            direction = c('v','h','v'))
?vcd::mosaic


library(ggplot2)

head(diamonds)
str(diamonds)

ggplot2::ggplot(diamonds,
                ggplot2::aes(
                  x=cut
                )) +
  ggplot2::geom_bar(
    stat = 'count',
    fill = 'green',
    colour = "orange"
  )


ggplot2::ggplot(diamonds,
                ggplot2::aes(
                  x=cut,
                  fill = color
                )) +
  ggplot2::geom_bar(
    stat = 'count') +
  ggplot2::theme_bw()+
  ggplot2::theme(legend.position = 'bottom') +
  ggplot2::labs(
    x = 'a',
    y = 'b',
    title= 'c'
  )



ggplot2::ggplot(diamonds, ggplot2::aes(x=color, fill = cut))+
  ggplot2::geom_bar(stat = 'count')+
  ggplot2::theme_bw()


climate <- read.csv('climate.csv')

head(climate)

plt1 = climate |>
  dplyr::mutate(pos_neg = ifelse(Anomaly10y>=0,
                                 'Pos',
                                 'Neg'))|>
  ggplot2::ggplot(ggplot2::aes(x = Year,
                               y = Anomaly10y,
                               fill = pos_neg))+
  ggplot2::geom_bar(stat = 'identity')


plt2 = climate |>
  dplyr::mutate(pos_neg = ifelse(Anomaly10y>=0,
                                 'Pos',
                                 'Neg')) |>
  ggplot2::ggplot(ggplot2::aes(x=Year,
                               y=Anomaly10y,
                               fill = pos_neg))+
  ggplot2::geom_bar(stat = 'identity',
                    colour = 'black',
                    size=0.25)+
  ggplot2::scale_fill_manual(values = c("blue",'orange'))

gridExtra::grid.arrange(plt1, plt2,,... plt10, ncol = 2)

gridExtra::grid.arrange(plt2, plt1, ncol = 2)


tophitters <- read.csv("tophitters.csv")

head(tophitters)

ggplot2::ggplot(tophitters, 
                ggplot2::aes(x=avg,
                             y=name))+
  ggplot2::geom_point()

ggplot2::ggplot(tophitters,
                ggplot2::aes(x=avg, 
                             y=reorder(name, avg)))+
  ggplot2::geom_point()+
  ggplot2::labs( y = 'name')+
  ggplot2::theme_bw()

name.order <- 
  tophitters$name[order(tophitters$lg, tophitters$avg)]

tophitters$name <- 
  factor(tophitters$name, levels = name.order)

ggplot2::ggplot(tophitters,
                ggplot2::aes(x=avg,
                             y=name))+
  ggplot2::geom_point(size = 3,
                      ggplot2::aes(colour = lg))+
  ggplot2::facet_grid(lg ~., 
                      scale = 'free_y',
                      space = 'free_y')


ggplot2::ggplot(diamonds, ggplot2::aes(factor(1), fill = cut))+
  ggplot2::geom_bar(stat = 'count',
                    width = 0.5) +
  ggplot2::coord_polar(theta = 'y')

str(ToothGrowth)

ToothGrowth |>
  dplyr::group_by(supp, dose) |>
  dplyr::summarise(mean_len = mean(len, na.rm=TRUE))|>
  ggplot2::ggplot(ggplot2::aes(x=dose, y=mean_len,
                               group=supp, color =supp))+
  ggplot2::geom_line(linetype = 'dashed')+
  ggplot2::geom_point(size = 3, shape = 3)

uspopage<-read.csv('uspopage.csv')

head(uspopage)

ggplot2::ggplot(uspopage,
                ggplot2::aes(x = Year,
                             y = Thousands,
                             fill = AgeGroup))+
  ggplot2::geom_area(alpha=0.4)+
  ggplot2::scale_fill_brewer(palette = 'Reds')+
  ggplot2::geom_line(position = 'stack', size=0.2)


climate
head(climate)

climate |>
  dplyr::mutate(UB = Anomaly10y + Unc10y,
                LB = Anomaly10y - Unc10y)|>
  ggplot2::ggplot(ggplot2::aes(x=Year, y=Anomaly10y))+
  ggplot2::geom_line()+
  ggplot2::geom_line(ggplot2::aes(y = UB), linetype='dotted')+
  ggplot2::geom_line(ggplot2::aes(y = LB), linetype='dotted')


climate |>
  dplyr::mutate(UB = Anomaly10y + Unc10y,
                LB = Anomaly10y - Unc10y)|>
  ggplot2::ggplot(ggplot2::aes(x=Year, y=Anomaly10y))+
  ggplot2::geom_line()+
  ggplot2::geom_ribbon(ggplot2::aes(ymin=LB, ymax=UB),
                       alpha = 0.4)


birthwt_dat<-MASS::birthwt

str(birthwt_dat)

ggplot2::ggplot(birthwt_dat, aes(x = bwt))+
  ggplot2::geom_histogram(fill = 'white',
                          colour = 'black',
                          bins=30)

birthwt_dat |>
  dplyr::mutate(smoke1 = ifelse(smoke==0,
                                'non_smoker',
                                'smoker'))|>
  ggplot2::ggplot(ggplot2::aes(x = bwt))+
  ggplot2::geom_histogram()+
  ggplot2::facet_grid(smoke1 ~.)

birthwt_dat |>
  dplyr::mutate(smoke1 = ifelse(smoke==0,
                                'non_smoker',
                                'smoker'))|>
  ggplot2::ggplot(ggplot2::aes(x = bwt,
                               fill = smoke1))+
  ggplot2::geom_histogram(alpha=0.5,
                          position = 'identity')


ggplot2::ggplot(birthwt_dat, ggplot2::aes(x = bwt))+
  ggplot2::geom_freqpoly()


ggplot2::ggplot(birthwt_dat,
                ggplot2::aes(y = bwt))+
  ggplot2::geom_boxplot()


birthwt_dat |>
  dplyr::mutate(smoke1 = ifelse(smoke==0, 
                                'non_smoker',
                                'smoker'))|>
  ggplot2::ggplot(ggplot2::aes(x=smoke1, y=bwt))+
  ggplot2::geom_boxplot()+
  ggplot2::coord_flip()


birthwt_dat |>
  dplyr::mutate(smoke1 = ifelse(smoke==0, 'non_smoker','smoker'))|>
  ggplot2::ggplot(ggplot2::aes(x=smoke1, y=bwt))+
  ggplot2::geom_violin()

hw <- read.csv('heightweight.csv')
str(hw)

ggplot2::ggplot(hw, ggplot2::aes(x = heightIn,
                                 y = weightLb,
                                 colour = sex,
                                 shape = sex))+
  ggplot2::geom_point()

ggplot2::ggplot(hw, ggplot2::aes(x = ageYear,
                                 y = heightIn,
                                 colour = sex,
                                 size = weightLb))+
  ggplot2::geom_point(alpha=0.5)



ggplot2::ggplot(hw, ggplot2::aes(x=heightIn, y=weightLb, colour = sex, shape = sex))+
  ggplot2::geom_point()


GGally::ggpairs(hw)

countries = read.csv('countries.csv')
str(countries)

head(countries)


ggplot2::ggplot(countries, ggplot2::aes(x=healthexp, 
                                        y=infmortality))+
  ggplot2::geom_point()+
  ggplot2::scale_x_log10()+
  ggplot2::annotate('text',
                    x=1000,
                    y=75,
                    label = 'Seungyong')



ggplot2::ggplot(countries, ggplot2::aes(x=healthexp,y=infmortality))+
  ggplot2::geom_point()+
  ggplot2::scale_x_log10()+
  ggplot2::annotate('text',
                    x=countries$healthexp[which(rownames(countries) == 'Croatia')],
                    y=countries$infmortality[which(rownames(countries) == 'Croatia')],
                    label = 'Croatia')


ggplot2::ggplot(countries, ggplot2::aes(x=healthexp,y=infmortality))+
  ggplot2::geom_point()+
  ggplot2::scale_x_log10()+
  ggplot2::geom_text(ggplot2::aes(label = rownames(countries)), hjust=0, vjust=1, size=4, check_overlap = TRUE)+
  ggplot2::theme_bw()+
  ggplot2::theme(axis.text = element_text(size=15),
                 axis.title = element_text(size=15))
