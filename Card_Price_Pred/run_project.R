# 1. 필요 패키지 다운로드
source("./project/required/my_packages.R")


# 2. train & test dataset 생성
source("./project/src/features/splitting_data.R")

## 오버핏을 방지하기 위한 garbage 변수들 추가가
source("./project/src/features/add_trash.R")

# 3. Lasso 규제를 사용한 모델과 결과 실행 
source('./project/src/models/lasso_model.R')

# 4. Ridge 규제를 사용한 모델과 결과 실행 
source('./project/src/models/ridge_model.R')





