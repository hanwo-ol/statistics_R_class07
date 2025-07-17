해당 R 코드는 **이변량 정규분포(Bivariate Normal Distribution)**를 따르는 데이터 `x`를 생성합니다. 
이 데이터의 분포는 주어진 평균 벡터 `mu`와 공분산 행렬 `sigma`에 의해 결정됩니다.


``` R

mu <- c(1, 1)

sigma <- matrix(c(0.04, 0.018, 0.018, 0.01), 2, 2)

x <- mvrnorm(n, mu, sigma)

plot(x, xlim=c(0, 2), ylim=c(0, 2), main="B")

```

<img width="369" height="265" alt="image" src="https://github.com/user-attachments/assets/e1a6f546-8f11-4ec8-9da7-0cc1f6d6bd54" />


### **수식 설명**

데이터 벡터 $\mathbf{x}$의 확률 밀도 함수 $f(\mathbf{x})$는 다음과 같습니다.

$$f(x_1, x_2) = \frac{1}{2\pi \sigma_1 \sigma_2 \sqrt{1-\rho^2}} \exp\left( -\frac{1}{2(1-\rho^2)} \left[ \left(\frac{x_1-\mu_1}{\sigma_1}\right)^2 - 2\rho\frac{(x_1-\mu_1)(x_2-\mu_2)}{\sigma_1\sigma_2} + \left(\frac{x_2-\mu_2}{\sigma_2}\right)^2 \right] \right)$$

이 수식은 아래 코드의 파라미터들로 구체화됩니다.

---

### **코드의 파라미터와 수식의 연결**

주어진 R 코드의 파라미터는 수식의 각 부분에 다음과 같이 해당합니다.

1.  **평균 (Mean, $\mu_1, \mu_2$)**
    코드에서 `mu <- c(1, 1)`는 각 변수($x_1, x_2$)의 기댓값(평균)을 의미합니다.
    * $\mu_1 = 1$
    * $\mu_2 = 1$

2.  **분산 (Variance, $\sigma_1^2, \sigma_2^2$) 및 공분산 (Covariance, $\sigma_{12}$)**
    코드의 `sigma` 행렬은 분산과 공분산을 정의합니다.
    * $x_1$의 분산: $\sigma_1^2 = 0.04$ (따라서 표준편차 $\sigma_1 = 0.2$)
    * $x_2$의 분산: $\sigma_2^2 = 0.01$ (따라서 표준편차 $\sigma_2 = 0.1$)
    * $x_1$과 $x_2$의 공분산: $\sigma_{12} = 0.018$

---

### **상관계수와 분포의 형태**

위 파라미터들을 이용해 **상관계수(Correlation Coefficient, $\rho$)**를 계산할 수 있습니다. 상관계수는 두 변수 간의 선형 관계의 강도를 나타냅니다.

$$\rho = \frac{\sigma_{12}}{\sigma_1 \sigma_2} = \frac{0.018}{0.2 \times 0.1} = \frac{0.018}{0.02} = 0.9$$

상관계수 $\rho=0.9$는 매우 강한 양의 선형 관계를 의미합니다. 따라서 `plot(x)`로 생성되는 산점도는 데이터 포인트들이 **오른쪽 위로 향하는 타원 형태**로 빽빽하게 모여있는 모습을 보일 것입니다. 데이터의 중심은 평균값인 (1, 1)이 됩니다.
