    > principal() 함수는 PCA 기반이지만, 상관행렬과 요인 회전을 통해 PAF와 유사한 결과를 도출할 수 있습니다. 단, 진정한 PAF는 fa(method = "pa")를 통해 수행하는 것이 더 정확합니다...

---

이번에는 요인 추출 방법으로 **주축인자법(Principal Axis Factoring)**을 사용한 결과입니다. 앞서 분석한 **최대우도법(Maximum Likelihood)**과 무엇이 다르고, 결과는 어떻게 해석해야 하는지 비교하며 상세하게 설명해 드리겠습니다.



### 분석의 목표: 다른 추출 방법으로 요인 구조 검증하기

요인분석에는 요인을 추출하는 여러 가지 방법이 있습니다.
*   **최대우도법 (ML, Maximum Likelihood)**: 통계적 가정을 기반으로 모델의 적합도를 카이제곱 검정으로 평가할 수 있는 장점이 있습니다. (앞선 분석에서 사용)
*   **주축인자법 (PAF, Principal Axis Factoring)**: 공통성(communality)을 반복적으로 추정하며 공통 요인을 추출합니다. 통계적 가정에 덜 민감하고, 데이터가 정규분포를 따르지 않아도 안정적인 결과를 내는 경향이 있습니다.

이번 분석의 목표는 **"주축인자법이라는 다른 방법으로 요인을 추출해도, 앞서 최대우도법으로 발견했던 5-요인 구조가 유사하게 나타나는가?"**를 확인하는 것입니다. 만약 다른 방법으로도 비슷한 결과가 나온다면, 우리가 발견한 요인 구조가 매우 안정적이고 신뢰할 만하다는 강력한 증거가 됩니다.

---

### 단계별 코드 및 결과 상세 해설

#### 1. 주축인자법 (회전 없음)

```R
> # 주축인자법 (회전 없음)
> pc <- principal(Harman74.cor$cov, nfactors=5, rotate="none")
> pc$loadings
> pc$communality
```

##### **함수 기능 설명**

*   `principal()`: `psych` 패키지에 포함된 함수로, **주성분분석(PCA)**과 **주축인자법(PAF)**을 모두 수행할 수 있습니다. 여기서는 상관계수 행렬을 입력값으로 사용하여 사실상 주축인자법과 유사한 방식으로 요인을 추출합니다. (엄밀히는 PAF와 약간의 차이가 있지만, `psych` 패키지에서는 이 함수를 요인분석 목적으로 널리 사용합니다.)
*   `Harman74.cor$cov`: 분석에 사용할 상관계수 행렬을 지정합니다.
*   `nfactors=5`: 추출할 요인의 개수를 5개로 지정합니다.
*   `rotate="none"`: 요인 회전을 적용하지 않습니다.
*   `pc$loadings`: 추출된 요인의 적재량을 확인합니다.
*   `pc$communality`: 각 변수의 공통성(communality)을 확인합니다.

##### **결과(회전 전) 상세 해석**

*   **Loadings (요인 적재량)**:
    *   `PC1` (첫 번째 요인)의 적재량을 보면, `GeneralInformation`(0.695), `WordMeaning`(0.694), `SeriesCompletion`(0.712) 등 거의 모든 변수들이 높은 양의 적재량을 보입니다.
    *   **해석**: 이는 앞서 본 최대우도법의 회전 전 결과와 매우 유사합니다. 첫 번째 요인이 **'일반 공통 요인(General Factor)'**의 역할을 하고 있으며, 여러 변수가 여러 요인에 걸쳐 있어(cross-loading) 해석이 매우 어렵습니다.

*   **Communality (공통성)**:
    *   `pc$communality` 결과는 각 변수의 분산 중 5개의 요인으로 설명되는 비율을 보여줍니다.
    *   예: `SentenceCompletion`의 공통성은 0.772로, 이 변수 분산의 77.2%가 5개 요인으로 설명됩니다.
    *   **중요한 차이점**: 이 값들은 **최대우도법(ML)으로 계산된 공통성과 다릅니다.** 이는 두 방법이 공통성을 추정하고 요인을 추출하는 알고리즘 자체가 다르기 때문입니다. 주축인자법이 일반적으로 더 높은 공통성 값을 추정하는 경향이 있습니다.

---

#### 2. 주축인자법 (Promax 회전)

```R
> # 주축인자법 (promax 회전)
> pc.rot <- principal(Harman74.cor$cov, nfactors=5, rotate="promax")
> pc.rot$loadings
> pc.rot$communality
```

##### **함수 기능 설명**

*   `principal(..., rotate="promax")`: 주축인자법으로 5개의 요인을 추출한 뒤, 해석을 용이하게 하기 위해 **`promax` 사각 회전**을 적용합니다.

##### **결과(회전 후) 상세 해석**

*   **Loadings (요인 적재량)**:
    *   `principal()` 함수의 결과에서는 회전된 요인(Rotated Component)을 `RC1`, `RC2`... 등으로 표시합니다.
    *   이 결과를 앞서 본 최대우도법(ML)의 회전 후 결과와 비교해 봅시다.

| 요인 (PAF) | 높게 적재된 변수 (PAF) | 요인명 (재해석) | 대응하는 요인 (ML) |
| :--- | :--- | :--- | :--- |
| **RC1** | `GeneralInformation`(0.826), `PargraphComprehension`(0.853), `SentenceCompletion`(0.927), `WordMeaning`(0.903) | **언어 능력** | **Factor 2** |
| **RC3** | `VisualPerception`(0.756), `Cubes`(0.768), `PaperFormBoard`(0.617) | **공간 지각 능력** | **Factor 1** |
| **RC2** | `Addition`(0.967), `CountingDots`(0.886), `Code`(0.625) | **수리/계산 속도** | **Factor 3** |
| **RC4** | `WordRecognition`(0.730), `NumberRecognition`(0.802), `FigureRecognition`(0.588) | **시각적 기억력** | **Factor 4** |
| **RC5** | `PaperFormBoard`(0.523), `ObjectNumber`(0.497), `FigureWord`(0.831) | **연관 기억력?** | **Factor 5** |

*   **결과 비교 및 해석**:
    1.  **매우 유사한 요인 구조**: 요인의 순서(RC1, RC2 등)는 조금 바뀌었지만, **변수들이 묶이는 방식은 최대우도법(ML)의 결과와 거의 동일합니다.** '언어 능력', '공간 지각', '수리 속도', '시각 기억'이라는 핵심 요인들이 두 방법 모두에서 일관되게 나타났습니다.
    2.  **구조의 안정성 확인**: 이는 우리가 발견한 5-요인 구조가 특정 분석 방법에만 의존하는 우연한 결과가 아니라, 데이터 자체가 내포하고 있는 **매우 안정적이고 신뢰할 만한 구조**라는 것을 강력하게 뒷받침합니다.
    3.  **5번째 요인의 변화**: 5번째 요인에 묶이는 변수들은 두 방법 간에 약간의 차이를 보입니다. 이는 5번째 요인이 다른 요인들에 비해 상대적으로 약하거나 불안정한 요인일 수 있음을 시사합니다.

*   **Communality (공통성)**:
    *   `pc.rot$communality`의 결과는 회전 전인 `pc$communality`의 결과와 **완전히 동일합니다.**
    *   **핵심**: 요인 회전은 요인 적재량의 구조(해석)를 바꿀 뿐, 모델이 각 변수를 설명하는 총량(공통성)을 바꾸지는 않습니다.

### 최대우도법(ML) vs. 주축인자법(PAF) 최종 비교

| 구분 | **최대우도법 (ML)** (`factanal`) | **주축인자법 (PAF)** (`principal`) |
| :--- | :--- | :--- |
| **장점** | - **모델 적합도 검정(카이제곱 검정) 가능**<br>- 통계적으로 가장 우수한 모델을 찾을 수 있음 | - 데이터의 분포 가정에 덜 민감함<br>- 안정적인 요인 구조를 보여주는 경향이 있음 |
| **단점** | - 데이터가 다변량 정규분포를 따른다는 가정이 필요함<br>- 데이터가 작거나 가정을 위배하면 결과가 불안정할 수 있음 | - 통계적인 모델 적합도 검정 기능이 없음 (p-value 제공 안 함)<br>- 탐색적 목적에 더 적합함 |
| **이번 분석 결과** | 5개의 요인이 통계적으로 적합함을 p-value로 확인 | 최대우도법과 매우 유사한 5-요인 구조를 보여줌으로써, 발견된 요인 구조의 신뢰도를 높여줌 |

### 종합 결론

1.  **추출 방법 간의 교차 검증**: 요인 추출 방법으로 **주축인자법(PAF)**을 사용한 결과, 앞서 **최대우도법(ML)**으로 찾았던 5-요인 구조(언어, 공간지각, 수리속도, 시각기억 등)가 거의 동일하게 재현되었습니다.
2.  **결과의 신뢰성 확보**: 서로 다른 원리를 가진 두 분석 방법에서 일관된 결과가 나왔다는 것은, 이 5-요인 구조가 **매우 안정적이고 신뢰할 수 있다**는 강력한 증거가 됩니다.
3.  **방법론적 차이 이해**: 요인분석에서는 최대우도법을 통해 통계적으로 최적인 요인 개수를 찾고, 주축인자법과 같은 다른 방법으로 그 결과가 일관되게 나타나는지 교차 검증하는 분석 전략이 매우 효과적입니다.


---


<img width="2561" height="1494" alt="image" src="https://github.com/user-attachments/assets/4fa9f097-f108-4fff-95ea-7f1b4adf9d1d" />


* 본 시각화는 주축인자법(PAF) 기반 Promax 회전 후, 두 주요 요인(RC1과 RC3)에 대한 변수들의 위치를 직관적으로 보여줍니다.
* 특히 언어 요인과 공간 지각 요인이 서로 명확히 구분된 클러스터 구조를 보이고 있음은, 해당 요인 구조의 명료성 및 안정성을 보여주는 강력한 증거입니다.
* 단, RC2, RC4, RC5는 이 시각화에 포함되지 않았기 때문에, 전체 요인 구조 해석을 위해서는 **다른 요인쌍 조합(RC1 vs RC2, RC2 vs RC4 등)**도 함께 살펴보는 것이 권장됩니다.
