rm(list=ls())

library(data.table)
set.seed(9001)

train <- fread('./project/volume/data/raw/Stat_380_train.csv')
test <- fread('./project/volume/data/raw/Stat_380_test.csv')

# just cleaning up my data and creating test and train set
train[is.na(train$DepDelay)]$DepDelay <- 0
test[is.na(test$DepDelay)]$DepDelay <- 0

# grouped means 
avg_Price <- mean(train$SalePrice)


# group the mean SalePrice by Building Type
Type_Price <- train[,.(SalePrice = mean(SalePrice)), 
                    by = .(BldgType)] 

# subset the data 
test <- left_join(test, Type_Price, by = 'BldgType')

fwrite(train,'./project/volume/data/interim/train.csv')
fwrite(test,'./project/volume/data/interim/test.csv')



