rm(list=ls())
library(caret)
library(data.table)
library(Metrics)


set.seed(9001)

test <- fread('./project/volume/data/interim/test.csv')
train <- fread('./project/volume/data/interim/train.csv')

test <- test[,-2]
train <- train[,-2]

#saving my actual depdelay somewhere because I'm going to overwrite them
train_y <- train$SalePrice
test_y <- test$SalePrice

# my goal is to predict SalePrice

# y = bo +b1x+ ....    where y is SalePrice and x are other variables
# in R the = is usually replace with a ~

dummies <- dummyVars(SalePrice ~ ., data = train)
dummies
# following I use the "dummies" object to create a data.frame but then I
# convert the data.frame to a data.table
train <- predict(dummies, newdata = train)
train <- data.table(train)

test <- predict(dummies, newdata = test)
test <- data.table(test)

# appending the original data back
train$SalePrice <- train_y

#finally create the linear model
# "DepDelay~" read as "DepDelay as predicted by" 
fit <- lm(SalePrice ~., data = train)

# model assessment
summary(fit)

# save my linear model somewhere
# saveRDS(dummies,"./project/volume/models/DepDelay_linear_model.dummies")
# saveRDS(fit,"./project/volume/models/fit_lm.model")

test$Pred_SalePrice <- predict(fit,newdata = test)

rmse(test_y,test$Pred_Saleprice)


SalePrice <- test$Pred_SalePrice
Id <- test$Id

submit <- data.frame(Id, SalePrice)

# 
fwrite(submit,"./project/volume/data/processed/submit_lm.csv")

