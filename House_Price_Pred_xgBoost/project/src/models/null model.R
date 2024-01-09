rm(list=ls())

library(caret)
library(data.table)
library(Metrics)
library(tidyverse)

# Load the data
train <- fread('./project/volume/data/raw/Stat_380_train.csv')
test <- fread('./project/volume/data/raw/Stat_380_test.csv')


# grouped means 
avg_Price <- mean(train$SalePrice)


# group the mean SalePrice by Building Type
Type_Price <- train[,.(SalePrice = mean(SalePrice)), 
                    by = .(BldgType)] 


# subset the data 
test <- left_join(test, Type_Price, by = 'BldgType')


fwrite(test,'./project/volume/data/interim/test.csv') 
fwrite(train,'./project/volume/data/interim/train.csv')  

