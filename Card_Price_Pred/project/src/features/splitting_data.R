rm(list=ls())

library(caret)
library(data.table)
library(Metrics)
library(tidyverse)
library(stringr)

# 시드 설정
set.seed(9001)

# 데이터 불러오기
card_tab <- fread('./project/volume/data/raw/card_tab.csv')
set_tab <- fread('./project/volume/data/raw/set_tab.csv')

test <- fread('./project/volume/data/raw/start_test.csv')
train <- fread('./project/volume/data/raw/start_train.csv')

# 예측에 적합한 요인으로 데이터 추출
card_tab <- card_tab[,.(id, colors, cmc, rarity, set)]
set_tab <- set_tab[,.(set,type)]

# 데이터 병합하여 가격과 관련된 하나의 데이터 테이블 생성
sample <- left_join(card_tab, set_tab, by = 'set')

# 데이터 병합하여 가격과 관련된 하나의 데이터 테이블 생성
temp <- str_split_fixed(sample$colors, " ", 2)
temp <- as.data.frame(temp)

# 데이터 조작: 예측 변수 colors
sample <- sample[,.(id, cmc, rarity)]
sample$colors <- temp$V1

# 빈 변수를 적절한 형식으로 변경
sample[sample == ""] <- NA
sample[is.na(sample$colors)]$colors <- 'Colorless'

# 훈련 및 테스트 데이터 테이블 생성
train <- left_join(train, sample, by = 'id')
test <- left_join(test, sample, by = 'id')

# 파일 저장
fwrite(train,'./project/volume/data/interim/train.csv')
fwrite(test,'./project/volume/data/interim/test.csv')


