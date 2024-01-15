JongHee Lee's Project Portfolio

## 안녕하세요. 예비 데이터 분석가 이종희의 프로젝트 포트폴리오입니다.
기술: R, Python, SAS 

R - 통계분석, 머신러닝과 기반한 예측,분류 모델 만들기


Python - 딥러닝에 기반한 예측 모델 만들기


SAS - 기초 데이터 관리 코드


## 통계분석

1. 리그오브레전드 게임 2022 세계대회 사용된 챔피언 분석 
     - 기간: 2022.12 ~
     - 참여인원: 3
     - 언어: R
     - 담당역할: EDA (Table 1,2,3, Figure 2), ANOVA 가정 확인
     - 프로젝트 소개:
       
             1. 세계대회에 참여한 4가지 지역 (한국, 중국, 미국, 서유럽) 중 특정 챔피언이 한번만 선택된 곳이 가장 많은 지역 찾기
             2, 역할군에 따른 특정 챔피언이 한번만 선택된 경우의 차이 확인 
             3. 동부 지역 (한국, 중국) 과 서부 지역 (미국, 서유럽) 중 특정 챔피언이 한번만 선택된 경우의 특이점 찾기

          - 70개의 데이터가 사용되었으며, 대회에 참가한 한국과 중국의 20명의 플레이어와 북미와 EU의 15명의 플레이어입니다. 각 플레이어는 다섯 가지 역할 중 하나를 가지고 대회 전체 기간 동안 해당 역할을 유지합니다.
          - two-way factorial ANOVA model을 사용하여 분석을 진행하였습니다.
          - 세 가지 종합 연구 질문에 대한 ANOVA 분석 결과, 역할이 통계적으로 유의미한 영향을 미치는 것으로 나타났습니다. 특히, 역할은 고유한 챔피언 플레이 횟수의 약 15%를 설명하는 효과 크기를 보였습니다.
          - 지역 및 지역과 역할의 상호 작용은 통계적으로 유의미한 영향을 미치지 않았습니다.
          - Benjamini-Hochberg 방법을 사용한 사후 비교에서, 미드 라인 플레이어는 서포트와 탑 라인에 비해 유의미하게 덜 다양한 챔피언을 사용하며, 특히 탑 라인 플레이어가 더 많은 고유한 챔피언을 선택할 확률은 76.7%입니다.
            
      
2. 비모수 통계 이론과 실습 
     - 기간: 2022.12 ~
     - 참여인원: 3
     - 언어: R
     - 담당역할: 관련자료 조사, 데이터 로드, Mood Median Test 결과 정리
     - 프로젝트 소개: 비모수통계 분석방법 중 중앙값을 활용한 테스트 실제 데이터에 활용 
          - Wilcoxon Rank Sum test, Permutation test 등 비모수 통계에 쓰이는 분석으로 Mood Median Test를 채택하였습니다.
          - 35개의 데이터를 통해 3가지 식당에 대한 평가를 바탕으로 평점이 높은 식당이 유의미한지 분석한 결과, 적어도 한가지 식당이 다른 식당들과 다른 평가를 받고 있다는 점을 확인하였습니다.

                    
3. 2022 MLB 모평균 타율 예측 
     - 기간: 2023.04 ~
     - 참여인원: 2
     - 언어: R
     - 담당역할: EDA, 데이터 전처리, 모평균 예측
     - 프로젝트 소개: 표본추출법의 여러 방법중 하나인 One Stage Clustering sampling method를 사용하여 자유주제에 적용
          - 131개의 데이터를 팀에 따른 31개의 군집으로 나누어 모평균 추정을 성공적으로 진행하였습니다. 


4. Emergency Room Visit 횟수 분석 
     - 기간: 2023.10 ~
     - 참여인원: 2
     - 언어: R
     - 담당역할: EDA, 각 음절에 대한 구간추정, ANOVA 가정 확인
     - 프로젝트 소개: 응급실 방문 횟수에 영향을 주는 요소 찾기
          - Stepwise Regression 과 Negative Binomial Regression 모델의 비교를 통해 응급실 방문 횟수에 영향을 주는 5가지의 요소와 패턴을 찾아내었습니다.

            
5. Capstone Project - 6음절 영어문장에 발생하는 유의미한 성조 변화 분석 
     - 기간: 2023.12 ~
     - 참여인원: 2
     - 언어: R
     - 담당역할: 데이터 로드, EDA, 각 음절에 대한 구간추정, ANOVA 가정 확인
     - 프로젝트 소개: 32개의 변수로 이루어진 95개의 샘플 데이터를 바탕으로 6음절 문장에 대한 성조 패턴 발견
          - EDA, 구간추정, Kruskal Wallis test를 통해 첫음절과 끝음절에서 성조변화가 두드러지게 발생하는 결과를 확인하였습니다.


            
     
## Kaggle 프로젝트

Following this directory structure
```
|--project_name                           <- Project root level that is checked into github
  |--project                              <- Project folder
    |--volume
    |   |--data
    |   |   |--external                   <- Data from third party sources
    |   |   |--interim                    <- Intermediate data that has been transformed
    |   |   |--processed                  <- The final model-ready data
    |   |   |--raw                        <- The original data dump
    |   |
    |   |--models                         <- Trained model files that can be read into R or Python
    |
    |--required
    |   |--requirements.r                 <- The required libraries for reproducing the R environment
    |
    |
    |--src
    |   |
    |   |--features                       <- Scripts for turning raw and external data into model-ready data
    |   |   |--build_features.r
    |   |
    |   |--models                         <- Scripts for training and saving models
    |   |   |--train_model.r
```


1. MTG Card Price Prediction 
     - 기간: 2022.09 ~ 2022.10
     - 참여인원: 1
     - 언어: R
     - 리더보드 결과: 7/38 
     - 프로젝트 소개: Lasso, Ridge 규제에 기반한 MTG 게임 카드 가격 예측모델 생성 
          - 전처리 과정을 거친 후 7006개의 train 데이터를 학습하여 369개의 test 데이터에 대한 가격 예측을 진행하였습니다.
          -  cv.glmnet 함수를 이용한 회귀모델이 사용되었습니다.
          -  lasso, ridge 규제를 사용한 각각의 회귀모델 결과, ridge 규제를 사용한 모델의 예측결과가 더 정확하게 나타났음을 확인했습니다.


2. House Price Prediction 
     - 기간: 2022.10 ~ 2022.11
     - 참여인원: 1
     - 언어: R
     - 리더보드 결과: 7/38 
     - 프로젝트 소개: xgBoost 기반 머신러닝을 사용한 집값 예측모델 생성
          - 전처리 과정을 거친 후 10000개의 train 데이터를 학습하여 4998개의 test 데이터에 대한 가격 예측을 진행하였습니다.
          -  xgb.DMatrix, xgb.cv, xgb.train 함수를 사용해 형식 변환, 모델 fit, 학습을 진행하였습니다.
          -  xgBoost 모델에 사용된 파라미터는 최적의 값으로 튜닝하였습니다.
          -  10000번의 학습을 바탕으로 최종 예측값을 찾았습니다. (early stop = 25)
      
            
3. Breed Identification 
     - 기간: 2022.11
     - 참여인원: 1
     - 언어: R
     - 리더보드 결과: 14/40 
     - 프로젝트 소개: PCA, t-SNE를 사용하여 차원축소된 데이터를 GMM 모델을 통해 종 3가지의 종으로 분류모델 생성
          - 전처리 과정을 거친 2500개의 데이터를 PCA를 통해 차원축소를 진행하고, t-SNE를 통해 추가 차원축소를 진행하였습니다.
          -  GMM 함수를 활용하여 분류 규칙을 수립했으며, 이때 클러스터의 수는 3으로 설정되었습니다.
          -  수립된 분류 규칙을 바탕으로, 3가지의 종을 성공적으로 분류하였습니다.
       
            
4. Reddit Post Classification
     - 기간: 2022.12
     - 참여인원: 1
     - 언어: R
     - 리더보드 결과: 6/38 
     - 프로젝트 소개: 임베딩된 데이터를 바탕으로 xgBoost를 사용해 Reddit에 올라온 포스트를 10개의 카테고리로 분류
          - 전처리 과정을 거친 후, 200개의 train 데이터를 바탕으로 20553개에 test 데이터에 대한 분류를 진행하였습니다. 이때 train 데이터와 test는 임베딩된 데이터가 함께 사용되었습니다.
          - 512차원으로 임베딩된 기존의 데이터를 t-SNE를 통해 차원축소를 진행하였습니다. 정확도를 높이기 위해 다른 perplexity를 적용하여 8번 진행하였습니다.
          - xgBoost의 최적의 파라미터를 찾기 위해 loop을 사용하였습니다.
          - 발견된 파라미터를 바탕으로 1400번의 학습을 통해 10개의 카테고리로 분류를 성공적으로 진행하였습니다.


            
## Dacon 경진대회
1. 2023 NH 투자증권 빅데이터 경진대회
     - 기간: 2023.09 ~ 2023.10
     - 참여인원: 3
     - 언어: Python
     - 툴: Google Colab
     - 소개: 해외 주식 데이터를 이용한 국내/해외 종목 관계 분석 (1040명 참여)
     - 프로젝트 목적: LSTM과 스태킹 기법을 통한 특정 상장기업에 대한 다음날 수정종가 예측 (미국주식)
     - 담당역할: 자료조사, 데이터 수집 (주가 데이터, 경제지표 데이터), 데이터 가공, 보간법 적용, 기술적 분석 LSTM 모델, 기본적 분석 LSTM 모델, 앙상블 모델 생성
     - 프로젝트 설명:
       
       1. 증권분석을 위한 기술적 분석, 기본적 분석의 한계를 보완하여 더욱 정확한 예측 모델 만들기
       2. 오픈소스와 크롤링을 바탕으로 얻은 특정 상장기업의 10년치 미국 주식관련 지표들을 바탕으로 다음날 주가 예측 진행 (이때 시작일과 종료일, 상장 회사는 자유롭게 설정 가능)
       3. 종료일을 기준으로 다음날의 수정종가 예측을 진행
       4. 기술적 분석 - 주가 데이터와 보조지표로 SMA, EMA, 더블 볼린져, RSI, MACD, OBV 사용
       5. 기본적 분석 - 경제지표, 산업지표, 기업지표 사용
          - 경제지표: DGS, T10Y2Y, VIX, Unemployment Rate, CPI, FEDFUNDs, GDP 사용
               - 사용된 경제지표 중 일부는 분기별로 업데이트 되므로, 선형보간법과 Holt-Winter ES 기법을 사용하여 일일 데이터로 변경
          - 산업지표: Dow Jones, NASDAQ, S&P500, Russell 2000, ETF 가격 데이터 사용
          - 기업지표: 재무상태표, 포괄손익계산서, 자본변동표, 현금흐름표 사용
               - 제무재표 역시 분기별 업데이트기 때문에 선형보간법과 Holt-Winter ES 기법을 사용하여 일일 데이터로 변경
       6. 위 지표들 중 특정 상장기업과 상관계수 0.9 이상인 변수들 채택 (일부 지표는 0.8 이상)
       7. 채택된 지표들을 바탕으로 기술적 분석, 기본적 분석 기반의 LSTM 모델 각각 생성
          - 오버핏 문제를 해결하기 위해 기술적 분석은 L1, L2 규제를 각 0.0001로 설정, 기본적 분석은 L1, L2 규제를 각 0.001로 설정
          - 정확한 학습을 위해 80%의 train, 20%의 test 데이터로 분류  
       8. 생성된 LSTM 예측모델을 바탕으로 앙상블 메타 모델을 생성하여 최종 수정종가 예측
          - 메타 모델의 알고리즘은 xgBoost 기법, 최적의 파라미터를 찾기 위해 GridSearchCV 함수 사용

     - 결과 시각화
          - 기술적 분석:      
       ![image](https://github.com/jonghee1998/Portfolio-/assets/129052128/1a08dfca-cfaf-4e02-b918-7b46b61ce45a)
       ![image](https://github.com/jonghee1998/Portfolio-/assets/129052128/41327bd9-a56e-463c-9800-8203eb9012a3)

          - 기본적 분석:
       ![image](https://github.com/jonghee1998/Portfolio-/assets/129052128/a38f881d-491d-47f9-bbce-f5aeee5bda82)
       ![image](https://github.com/jonghee1998/Portfolio-/assets/129052128/5bc6d0f5-a192-4f4d-9584-583ba39feed6)

          - 메타 모델:
       ![image](https://github.com/jonghee1998/Portfolio-/assets/129052128/e564fdc7-6f8d-48a3-afeb-3f2c7d16632c)
       ![image](https://github.com/jonghee1998/Portfolio-/assets/129052128/eda5cd3a-6ca7-4f73-8291-9b937dd2458a)





                  
            
## SAS 기초 데이터 관리 코드

