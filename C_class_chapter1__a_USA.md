## USArrests 데이터 주성분분석(PCA) 결과 및 해석

### 1. 데이터 확인 및 탐색

#### 코드
```R
> data("USArrests") # ; USArrests
> plot(USArrests)
> summary(USArrests)
```

<details> <summary> 실험 결과 열기 </summary>
   
``` R
> summary(USArrests)
     Murder          Assault         UrbanPop          Rape      
 Min.   : 0.800   Min.   : 45.0   Min.   :32.00   Min.   : 7.30  
 1st Qu.: 4.075   1st Qu.:109.0   1st Qu.:54.50   1st Qu.:15.07  
 Median : 7.250   Median :159.0   Median :66.00   Median :20.10  
 Mean   : 7.788   Mean   :170.8   Mean   :65.54   Mean   :21.23  
 3rd Qu.:11.250   3rd Qu.:249.0   3rd Qu.:77.75   3rd Qu.:26.18  
 Max.   :17.400   Max.   :337.0   Max.   :91.00   Max.   :46.00
```

<img width="643" height="519" alt="image" src="https://github.com/user-attachments/assets/e0a2db80-1e8e-45d9-b407-95552db8864d" />

</details>

#### 결과 해석
*   **데이터 로드 (`data("USArrests")`)**: R에 내장된 `USArrests` 데이터를 불러옵니다. 이 데이터는 1973년 미국 50개 주의 10만 명당 강력 범죄(살인, 폭행, 강간) 체포율과 도시 인구 비율(%)을 담고 있습니다.
*   **산점도 행렬 (`plot(USArrests)`)**: 각 변수 간의 관계를 시각적으로 파악하기 위해 산점도 행렬을 그립니다. 이 플롯을 통해 `Murder`(살인), `Assault`(폭행), `Rape`(강간) 변수들 사이에 양의 상관관계가 있음을 짐작할 수 있습니다. 즉, 한 종류의 범죄율이 높은 주가 다른 종류의 범죄율도 높은 경향이 있습니다.
*   **데이터 요약 (`summary(USArrests)`)**: 각 변수의 기초 통계량(최소, 최대, 중앙값, 평균 등)을 보여줍니다. 이를 통해 데이터의 전반적인 분포를 파악할 수 있습니다.

---

### 2. 변수별 분산 확인

#### 코드
```R
> # 변수별 분산 확인
> apply(USArrests, 2, var)
```
#### 결과
```
    Murder    Assault   UrbanPop       Rape 
  18.97047 6945.16571  209.51878   87.72916
```
#### 결과 해석
*   **목적**: 각 변수가 가지는 분산(데이터의 흩어진 정도)을 계산합니다.
*   **해석**: `Assault` 변수의 분산이 `6945.17`로 다른 변수들(예: `Murder` 18.97)에 비해 압도적으로 큽니다. 만약 이 데이터를 그대로 PCA에 사용하면(공분산 행렬 기반 분석), 분산이 가장 큰 `Assault` 변수가 첫 번째 주성분(PC1)을 거의 독점하게 되어 다른 변수들의 정보가 무시될 수 있습니다.
*   **결론**: 이처럼 변수들의 측정 단위나 스케일이 다를 때는 **표준화(standardization)** 과정을 거치는 것이 필수적입니다. `princomp` 함수에서 `cor=TRUE` 옵션을 사용하는 것이 바로 이 표준화 과정을 적용하여 상관계수 행렬을 기반으로 PCA를 수행하겠다는 의미입니다.

---

### 3. 주성분분석 시행 및 결과 확인

#### 코드
```R
> # 주성분분석 시행 (상관행렬 기반)
> p1 <- princomp(USArrests, cor=TRUE)
> # p1 객체 내용 확인
> ls(p1)
> # loadings: 각 변수의 주성분에 대한 기여도 (적재계수)
> p1$loadings
```
#### 결과
```
Loadings:
         Comp.1 Comp.2 Comp.3 Comp.4
Murder    0.536  0.418  0.341  0.649
Assault   0.583  0.188  0.268 -0.743
UrbanPop  0.278 -0.873  0.378  0.134
Rape      0.543 -0.167 -0.818       

               Comp.1 Comp.2 Comp.3 Comp.4
SS loadings      1.00   1.00   1.00   1.00
Proportion Var   0.25   0.25   0.25   0.25
Cumulative Var   0.25   0.50   0.75   1.00
```
#### 결과 해석
*   **PCA 시행**: `princomp(..., cor=TRUE)`를 통해 상관계수 행렬 기반의 PCA를 수행했습니다.
*   **적재량 (Loadings)**: 각 주성분(Comp.1 ~ Comp.4)이 원래 변수들을 어떻게 조합하여 만들어졌는지를 보여주는 계수입니다.
    *   **제1주성분 (Comp.1)**: `Murder`(0.536), `Assault`(0.583), `Rape`(0.543) 세 범죄 변수 모두 비슷한 크기의 양수 값을 가집니다. 이는 **제1주성분이 '전반적인 범죄율'**을 나타내는 종합 지표임을 의미합니다. 이 주성분 점수가 높은 주는 모든 유형의 범죄율이 높은 경향이 있습니다.
    *   **제2주성분 (Comp.2)**: `UrbanPop`(-0.873)이 매우 큰 음수 값을 가지고, `Murder`(0.418)와 `Assault`(0.188)는 양수 값을 가집니다. 이는 **제2주성분이 '도시화 수준'**과 관련된 특성을 나타냄을 의미합니다. 이 주성분은 도시화 비율이 높은 주(음의 방향)와 그렇지 않은 주(양의 방향)를 구분하는 역할을 합니다.
    *   **나머지 주성분**: Comp.3은 `Rape`과 `Murder`를, Comp.4는 `Assault`와 `Murder`를 대비시키는 등 더 세부적인 특성을 나타내지만, 설명력이 낮아 주된 분석에서는 보통 제외됩니다.

---

### 4. 주성분 중요도 요약

#### 코드
```R
> # sdev: 각 주성분의 표준편차
> p1$sdev
> # 주성분분석 결과 요약
> summary(p1)
```
#### 결과
```
# sdev 결과
   Comp.1    Comp.2    Comp.3    Comp.4 
1.5748783 0.9948694 0.5971291 0.4164494 

# summary(p1) 결과
Importance of components:
                          Comp.1    Comp.2    Comp.3     Comp.4
Standard deviation     1.5748783 0.9948694 0.5971291 0.41644938
Proportion of Variance 0.6200604 0.2474413 0.0891408 0.04335752
Cumulative Proportion  0.6200604 0.8675017 0.9566425 1.00000000
```
#### 결과 해석
*   **Standard deviation (표준편차)**: 각 주성분이 설명하는 변동성의 크기입니다. 이 값을 제곱하면 분산(Eigenvalue)이 되며, 각 주성분의 설명력을 나타냅니다. Comp.1의 표준편차가 가장 크므로 가장 많은 정보를 담고 있습니다.
*   **Proportion of Variance (분산 비율)**: 각 주성분이 전체 데이터 분산 중 몇 퍼센트를 설명하는지를 나타냅니다.
    *   **제1주성분(Comp.1)은 전체 분산의 62%**를 설명합니다.
    *   **제2주성분(Comp.2)은 전체 분산의 24.7%**를 설명합니다.
*   **Cumulative Proportion (누적 분산 비율)**: 주성분을 순서대로 더해갔을 때 설명되는 총 분산의 비율입니다.
    *   **제1주성분과 제2주성분 두 개만 사용해도 원래 데이터가 가진 정보(분산)의 86.75%를 설명**할 수 있습니다.
    *   이는 4개의 변수(4차원)로 표현되던 데이터를 단 2개의 주성분(2차원)으로 차원을 축소해도 정보 손실이 약 13%에 불과하다는 의미이며, PCA가 매우 효과적이었음을 보여줍니다.

---

### 5. 시각화

#### 코드
```R
> # Scree plot
> screeplot(p1, type="lines")
> # Biplot
> biplot(p1)

```
#### 결과 해석

<img width="643" height="519" alt="image" src="https://github.com/user-attachments/assets/5cdbddb5-f7f3-498e-87c5-3efcc5385108" />

*   ▲ **Scree Plot**: 각 주성분이 설명하는 분산(Eigenvalue)의 크기를 그래프로 나타낸 것입니다. 그래프가 급격히 꺾이는 지점(Elbow point) 이전까지의 주성분을 선택하는 것이 일반적입니다. 이 그래프에서는 2번째 주성분 이후 기울기가 완만해지므로, **주요 주성분으로 2개를 선택하는 것이 타당함**을 시각적으로 뒷받침합니다.

<img width="643" height="519" alt="image" src="https://github.com/user-attachments/assets/4e151263-b345-4bc5-80ea-fd5dd7e063c2" />


*   ▲ **Biplot**: PCA의 결과를 가장 함축적으로 보여주는 그래프입니다.
    *   **점 (State 이름)**: 각 주(데이터 관측치)가 제1주성분(x축)과 제2주성분(y축) 상에서 어디에 위치하는지를 나타냅니다.

    *   **화살표 (변수)**: 원래 변수들이 주성분 축과 어떤 관계를 맺는지 보여줍니다.
        *   `Murder`, `Assault`, `Rape` 화살표는 서로 비슷한 방향(오른쪽)을 가리키며, 이들이 강한 양의 상관관계를 가짐과 동시에 **PC1(전반적 범죄율)**과 관련이 깊음을 보여줍니다.
        *   `UrbanPop` 화살표는 아래쪽을 향하며 **PC2(도시화 수준)**와 강한 관련이 있음을 보여줍니다.
