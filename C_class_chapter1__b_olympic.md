## Olympic 데이터 주성분분석(PCA) 결과 및 해석


### 1. 데이터 확인 및 탐색

#### 코드
```R
> # 패키지 로딩
> library(ade4)

> # 데이터 로드
> data("olympic")

> # 데이터 요약
> summary(olympic$tab)
      100             long      
 Min.   :10.62   Min.   :6.220  
 1st Qu.:11.02   1st Qu.:7.000  
 Median :11.18   Median :7.090  
 Mean   :11.20   Mean   :7.133  
 3rd Qu.:11.43   3rd Qu.:7.370  
 Max.   :11.57   Max.   :7.720  
      poid            haut      
 Min.   :10.27   Min.   :1.790  
 1st Qu.:13.15   1st Qu.:1.940  
 Median :14.12   Median :1.970  
 Mean   :13.98   Mean   :1.983  
 3rd Qu.:14.97   3rd Qu.:2.030  
 Max.   :16.60   Max.   :2.270  
      400             110       
 Min.   :47.44   Min.   :14.18  
 1st Qu.:48.34   1st Qu.:14.72  
 Median :49.15   Median :15.00  
 Mean   :49.28   Mean   :15.05  
 3rd Qu.:49.98   3rd Qu.:15.38  
 Max.   :51.28   Max.   :16.20  
      disq            perc      
 Min.   :34.36   Min.   :4.000  
 1st Qu.:39.08   1st Qu.:4.600  
 Median :42.32   Median :4.700  
 Mean   :42.35   Mean   :4.739  
 3rd Qu.:44.80   3rd Qu.:4.900  
 Max.   :50.66   Max.   :5.700  
      jave            1500      
 Min.   :49.52   Min.   :256.6  
 1st Qu.:55.42   1st Qu.:266.4  
 Median :59.48   Median :272.1  
 Mean   :59.44   Mean   :276.0  
 3rd Qu.:64.00   3rd Qu.:286.0  
 Max.   :72.60   Max.   :303.2 
```


#### 결과 해석
*   **데이터 로드 (`data("olympic")`)**: `ade4` 패키지에 내장된 `olympic` 데이터를 불러옵니다. 이 데이터는 10종 경기 선수들의 10개 종목에 대한 기록을 담고 있습니다.
*   **변수 확인**: `100`(100m 달리기), `long`(멀리뛰기), `poid`(포환던지기), `haut`(높이뛰기), `400`(400m 달리기), `110`(110m 허들), `disq`(원반던지기), `perc`(장대높이뛰기), `jave`(창던지기), `1500`(1500m 달리기) 총 10개의 변수로 구성되어 있습니다.
*   **데이터 요약 (`summary(olympic$tab)`)**: 각 종목별 기록의 기초 통계량을 보여줍니다.
    *   **중요한 점**: 변수들의 측정 단위와 값의 의미가 다릅니다.
        *   달리기 종목(`100`, `400`, `110`, `1500`)은 **시간(초)**이므로 **낮을수록 좋은 기록**입니다.
        *   투척/점프 종목(`long`, `poid`, `haut`, `disq`, `perc`, `jave`)은 **거리/높이(미터)**이므로 **높을수록 좋은 기록**입니다.
    *   또한, `1500` 종목은 250~300 사이의 값을 가지는 반면 `haut` 종목은 약 2 정도의 값을 가집니다. 이처럼 변수들의 스케일 차이가 매우 크기 때문에, **반드시 표준화를 거쳐 상관계수 행렬을 기반으로 PCA를 수행해야 합니다.** (`princomp` 함수에서 `cor=TRUE` 옵션을 사용하는 것이 바로 이 역할을 합니다.)

---

### 2. 주성분분석 시행 및 결과 확인

#### 코드
```R
> # 주성분분석 시행 (상관행렬 기반)
> p2 <- princomp(olympic$tab, cor=TRUE)
> 
> # 적재계수
> p2$loadings

Loadings:
     Comp.1 Comp.2 Comp.3 Comp.4
100   0.416  0.149  0.267       
long -0.394 -0.152  0.169  0.244
poid -0.269  0.484         0.108
haut -0.212         0.855 -0.388
400   0.356  0.352  0.189       
110   0.433         0.126  0.382
disq -0.176  0.503              
perc -0.384  0.150 -0.137 -0.144
jave -0.180  0.372  0.192  0.600
1500  0.170  0.421 -0.223 -0.486
     Comp.5 Comp.6 Comp.7 Comp.8
100   0.442         0.254  0.664
long -0.369         0.751  0.141
poid         0.230 -0.111       
haut               -0.135 -0.155
400  -0.147 -0.327  0.141 -0.147
110          0.210  0.273 -0.639
disq         0.615  0.144       
perc  0.717 -0.348  0.273 -0.277
jave        -0.437 -0.342       
1500 -0.340 -0.300  0.187       
     Comp.9 Comp.10
100   0.108  0.109 
long               
poid -0.422  0.651 
haut  0.102  0.119 
400  -0.651 -0.337 
110   0.207  0.260 
disq  0.167 -0.535 
perc               
jave  0.306 -0.131 
1500  0.457  0.243 

               Comp.1 Comp.2 Comp.3
SS loadings       1.0    1.0    1.0
Proportion Var    0.1    0.1    0.1
Cumulative Var    0.1    0.2    0.3
               Comp.4 Comp.5 Comp.6
SS loadings       1.0    1.0    1.0
Proportion Var    0.1    0.1    0.1
Cumulative Var    0.4    0.5    0.6
               Comp.7 Comp.8 Comp.9
SS loadings       1.0    1.0    1.0
Proportion Var    0.1    0.1    0.1
Cumulative Var    0.7    0.8    0.9
               Comp.10
SS loadings        1.0
Proportion Var     0.1
Cumulative Var     1.0
> # 각 주성분의 표준편차
> p2$sdev
   Comp.1    Comp.2    Comp.3 
1.8488478 1.6144328 0.9712345 
   Comp.4    Comp.5    Comp.6 
0.9370279 0.7460742 0.7008762 
   Comp.7    Comp.8    Comp.9 
0.6561975 0.5538936 0.5166715 
  Comp.10 
0.3191460 

> # 주성분분석 결과 요약
> summary(p2)
Importance of components:
                          Comp.1
Standard deviation     1.8488478
Proportion of Variance 0.3418238
Cumulative Proportion  0.3418238
                          Comp.2
Standard deviation     1.6144328
Proportion of Variance 0.2606393
Cumulative Proportion  0.6024631
                           Comp.3
Standard deviation     0.97123448
Proportion of Variance 0.09432964
Cumulative Proportion  0.69679277
                           Comp.4
Standard deviation     0.93702788
Proportion of Variance 0.08780212
Cumulative Proportion  0.78459489
                           Comp.5
Standard deviation     0.74607416
Proportion of Variance 0.05566267
Cumulative Proportion  0.84025756
                           Comp.6
Standard deviation     0.70087625
Proportion of Variance 0.04912275
Cumulative Proportion  0.88938031
                           Comp.7
Standard deviation     0.65619754
Proportion of Variance 0.04305952
Cumulative Proportion  0.93243983
                           Comp.8
Standard deviation     0.55389360
Proportion of Variance 0.03067981
Cumulative Proportion  0.96311964
                           Comp.9
Standard deviation     0.51667148
Proportion of Variance 0.02669494
Cumulative Proportion  0.98981458
                          Comp.10
Standard deviation     0.31914597
Proportion of Variance 0.01018542
Cumulative Proportion  1.00000000
```

#### 결과 해석

#### 1) 적재량 (Loadings) - 주성분의 의미 파악

`p2$loadings` 결과는 각 주성분이 10개 종목의 정보를 어떻게 조합하는지 보여줍니다.

*   **제1주성분 (Comp.1)**:
    *   **양수(+) 계수**: `100`(0.416), `400`(0.356), `110`(0.433) 등 달리기 종목.
    *   **음수(-) 계수**: `long`(-0.394), `poid`(-0.269), `haut`(-0.212), `perc`(-0.384) 등 점프/투척 종목.
    *   **해석**: 제1주성분 점수가 높다는 것은 달리기 기록(시간)이 크고(나쁨), 점프/투척 기록(거리)이 작다(나쁨)는 것을 의미합니다. 반대로, 제1주성분 점수가 낮을수록 달리기 기록은 좋고, 점프/투척 기록도 좋습니다. 따라서 **제1주성분은 '전반적인 운동 능력' 또는 '경기력'을 나타내는 종합 지표**로 해석할 수 있습니다. **점수가 낮을수록 우수한 선수**입니다.

*   **제2주성분 (Comp.2)**:
    *   **큰 양수(+) 계수**: `poid`(0.484), `disq`(0.503), `jave`(0.372) 등 투척 종목.
    *   **상대적으로 작은 계수**: 다른 종목들.
    *   **해석**: 제2주성분은 주로 투척 종목들과 강한 양의 관계를 가집니다. 따라서 **제2주성분은 '근력' 또는 '파워'**를 나타내는 지표로 해석할 수 있습니다. 이 점수가 높은 선수는 특히 던지기 종목에 강점이 있는 선수입니다.

#### 2) 주성분 중요도 요약 (`summary(p2)`)

*   **Proportion of Variance (분산 비율)**: 각 주성분이 전체 데이터 변동성 중 얼마를 설명하는지 나타냅니다.
    *   **제1주성분(전반적 경기력)**은 전체 분산의 **34.2%**를 설명합니다.
    *   **제2주성분(근력/파워)**은 전체 분산의 **26.1%**를 설명합니다.
*   **Cumulative Proportion (누적 분산 비율)**:
    *   **두 개의 주성분(PC1, PC2)만으로도 원래 10개 종목이 가진 정보의 60.2%를 설명**할 수 있습니다.
    *   이는 10차원의 복잡한 데이터를 '전반적 경기력'과 '근력/파워'라는 두 가지 축(2차원)으로 요약하여 선수들의 특성을 파악할 수 있음을 의미합니다.

---

### 3. 시각화

#### 코드
```R
> # Scree plot
> screeplot(p2, type="lines")
```

<img width="643" height="519" alt="image" src="https://github.com/user-attachments/assets/3f07804d-c41f-48fd-a408-ab5f55fc3432" />


``` R
> # Biplot
> biplot(p2)
```

<img width="1013" height="570" alt="image" src="https://github.com/user-attachments/assets/bc97e360-e0c3-4044-9c3b-1e4cac383f07" />


#### 결과 해석

*   **Scree Plot**: 각 주성분의 설명력(분산)을 시각적으로 보여줍니다. 그래프의 기울기가 급격히 꺾이는 '엘보우(Elbow)' 지점을 통해 몇 개의 주성분을 선택할지 결정하는 데 도움을 줍니다. 이 그래프에서는 2번째 또는 3번째 주성분 이후 기울기가 완만해지므로, **주요 주성분으로 2개 또는 3개를 선택하는 것이 타당함**을 시사합니다.

*   **Biplot**: 주성분분석의 모든 정보를 하나의 그래프에 압축하여 보여줍니다.
    *   **점 (선수)**: 각 선수가 '제1주성분(전반적 경기력)'과 '제2주성분(근력/파워)' 축에서 어디에 위치하는지를 나타냅니다.
    *   **화살표 (종목)**: 10개 종목이 주성분과 어떤 관계를 맺는지를 보여줍니다.
