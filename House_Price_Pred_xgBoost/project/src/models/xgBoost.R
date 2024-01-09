#- load in libraries
rm(list = ls())
library(data.table)
library(caret)
library(Metrics)
library(xgboost)
library(Matrix)
#advanced methods of hyperparameter tuning discussed here:
#https://rpubs.com/jeandsantos88/search_methods_for_hyperparameter_tuning_in_r

# Load data
test <- fread("./project/volume/data/interim/test.csv")
train <- fread("./project/volume/data/interim/train.csv")


#----------------------------------#
#      Prep Data for Modeling      #
#----------------------------------#
y.train <- train$SalePrice
y.test <- test$SalePrice

# Create dummy for prediction
dummies <- dummyVars(SalePrice~ ., data = train)
x.train <- predict(dummies, newdata = train)
x.test <- predict(dummies, newdata = test)

# notice that I've removed label=departure delay in the dtest line
dtrain <- xgb.DMatrix(x.train,label=y.train,missing=NA)
dtest <- xgb.DMatrix(x.test,missing=NA)


# Initialize my table
hyper_perm_tune <- NULL
#----------------------------------#
#     Use cross validation         #
#----------------------------------#

# Tune Parameter
param <- list(  objective           = "reg:linear", #reg:squarederror default, reg:linear
                gamma               = 1,   # 
                booster             = "gbtree",
                eval_metric         = 'rmse', # defaults to
                eta                 = 0.01,   # default eta of 
                max_depth           = 9,      # default is 6
                subsample           = 1.0,
                colsample_bytree    = 1.0,    #think of this like 
                tree_method =   'hist' #dependent on sample size
)


XGBfit <- xgb.cv(params = param,
                nfold = 5,
                nrounds = 10000,
                missing = NA,
                data = dtrain,
                print_every_n = 1,
                early_stopping_rounds = 25)   # training stops when no improvement



best_tree_n <- unclass(XGBfit)$best_iteration
new_row <- data.table(t(param))
new_row$best_tree_n <- best_tree_n

test_error <- unclass(XGBfit)$evaluation_log[best_tree_n,]$test_rmse_mean
new_row$test_error <- test_error
hyper_perm_tune <- rbind(new_row, hyper_perm_tune)

#----------------------------------#
# fit the model to all of the data #
#----------------------------------#
watchlist <- list( train = dtrain)


# Fit full model
XGBfit <- xgb.train( params = param,
                   nrounds = best_tree_n,
                   missing = NA,
                   data = dtrain,
                   watchlist = watchlist,
                   print_every_n = 1)


SalePrice<- predict(XGBfit, newdata = dtest)
Id <- test$Id

# Check rmse
rmse(y.test,SalePrice)

# Save data
submit <- data.frame(Id, SalePrice)
fwrite(submit,"./project/volume/data/processed/submit_xgBoost.csv")

