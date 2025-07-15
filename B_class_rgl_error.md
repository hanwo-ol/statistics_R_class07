rgl같은 경우는.. Rtools라는 윤활유가 필요합니다.

### \#\# 해결 방법 🛠️

아래 단계를 순서대로 따라 진행하시면 문제를 해결할 수 있습니다.

**1. Rtools 설치하기**

사용하고 계신 R 버전에 맞는 **Rtools40**을 설치해야 합니다.

  * [**Rtools40 다운로드 페이지**](https://cran.r-project.org/bin/windows/Rtools)에 접속하여 `rtools40-x86_64.exe` 설치 파일을 다운로드하고 실행하세요.
  * 설치 과정에서 **"Add rtools to system PATH"** 또는 **"시스템 PATH에 Rtools 추가"** 옵션이 있다면 반드시 체크해 주세요.

**2. R에서 Rtools 경로 설정하기**

Rtools 설치 후, R이 Rtools를 찾을 수 있도록 경로를 설정해야 합니다. RStudio를 열고 콘솔에 아래 코드를 그대로 입력하고 실행하세요.

```r
# 이 코드는 Rtools의 경로를 R 환경에 등록하는 역할을 합니다.
writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")
```

**3. RStudio 재시작하기**

가장 중요한 단계입니다. 위 코드를 실행한 후, **반드시 RStudio를 완전히 종료했다가 다시 실행해 주세요.** (열려있는 창을 모두 닫고 새로 시작)

**4. 패키지 재설치하기**

RStudio를 다시 시작한 후, 콘솔에서 원래 설치하려던 패키지를 다시 설치해 보세요.

```r
install.packages("htmlwidgets")
```

이제 Rtools가 정상적으로 인식되어 패키지 설치가 문제없이 진행되면 좋겠네요...
