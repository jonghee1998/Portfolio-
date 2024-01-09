rm(list=ls())
library(caret)
library(data.table)
library(Metrics)
library(glmnet)

set.seed(9001)

# Load data
train <- fread('./project/volume/data/interim/train_with_trash.csv')
test <- fread('./project/volume/data/interim/test_with_trash.csv')
start_test <- fread('./project/volume/data/raw/start_test.csv')

# Save test data id, train and test price to use later
test_id <- start_test$id
train_y <- train$price
test_y <- test$price

# Create dummy variables to change categorical predictors into continuous predictors (1,0)
# for both test and train data
dummies <- dummyVars(price ~ ., data = train)
train <- predict(dummies, newdata = train)
train <- data.table(train)

test <- predict(dummies, newdata = test)
test <- data.table(test)

# GLMNET doesn't like data tables, so we have to convert to matrices
train <- as.matrix(train)
test <- as.matrix(test)

# Find minimum lambda using cv , and create best fit gl_model (Lasso model: alpha level 1)
gl_model <- cv.glmnet(train, train_y, alpha = 1, family="gaussian") 
bestlam <- gl_model$lambda.min

gl_model <- glmnet(train, train_y, alpha = 1, family="gaussian")


# Predict price of test data by gl_model
pred <- predict(gl_model, s = bestlam, newx = test)

# To attach the predicted price into test, change into dataframe again
test <- as.data.table(test)
test$price <- pred

# Attach id into test
test$id <- test_id

# Create submit data table of lasso model
submit <- test[,.(id,price)]

# Save files
saveRDS(gl_model, "./project/volume/models/gl_model_lasso.model")
fwrite(submit,"./project/volume/data/processed/submit_lasso.csv")

