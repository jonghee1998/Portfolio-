rm(list=ls())

library(caret)
library(data.table)
library(Metrics)
set.seed(9001)

# Load data
train <- fread('./project/volume/data/interim/train.csv')
test <- fread('./project/volume/data/interim/null_test.csv')

# Subset train and test data since we do not treat id as the predictor
train <- train[,.(cmc, rarity,colors, price)]
test <- test[,.(cmc, rarity,colors, price)]


# Compute 100 random standard normal distributions for train's each row
garbage_data <- replicate(100,rnorm(nrow(train)))
garbage_data <- data.table(garbage_data)
setnames(garbage_data,paste0("V",1:100),paste0("garbage_",1:100))

# And merge with train data
train <- cbind(train,garbage_data)


# Compute 100 random standard normal distributions for test's each row
garbage_data <- replicate(100,rnorm(nrow(test)))
garbage_data <- data.table(garbage_data)
setnames(garbage_data,paste0("V",1:100),paste0("garbage_",1:100))

# And merge with test data
test <- cbind(test,garbage_data)

# Save files
fwrite(train,'./project/volume/data/interim/train_with_trash.csv')
fwrite(test,'./project/volume/data/interim/test_with_trash.csv')

