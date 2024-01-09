library(dplyr)
library(ggplot2)
library(gridExtra)
library(corrplot)
library(GGally)
library(MASS)

# 1.0. Read data 
df <- read.table("~/Desktop/JH/portfolio/Case Study 2/Emergency Room Visit.txt", quote="\"", comment.char="")

# 1.1. Change Column name
colnames(df) <- c("ID", "TotalCost", "Age", "Gender", "Interventions",
                  "Drug", "ERVisits", 
                  "Heart_Disease",
                  "Other_Diseases",
                  "Duration")

# 1.2. Factorize - "Gender"
vars_to_factor <- c("Gender")
df[vars_to_factor] <- lapply(df[vars_to_factor], as.factor)

# 1.3. Remove ID column -> To change Heart_Disease column as binary factor (+ Mostly 0~1)
df$ID <- NULL

## 2.  EDA section 
# 2.0 Check type
mean_er <- mean(df$ERVisits) # 3.425
var_er <- var(df$ERVisits) # 6.956  

# 2.1. Distribution of ERvisits - Histogram
hist(df$ERVisits, main = "Emergency Room Visits Distribution", xlab = "Number of ER Visits", breaks = seq(-0.5, max(df$ERVisits) + 0.5, by = 1))

# 2.2. Correlation matrix graph
other_vars <- setdiff(names(df), "ERVisits")
df <- df[, c(other_vars, "ERVisits")]

ggcorr(df, nbreaks = 6, label = TRUE, 
       label_round = 2, 
       label_size = 3, color = "grey50") + 
  ggtitle("Correlation Matrix Heatmap ")

## 2.3.1 Scatter plots of ERVisits vs. Other numeric variables
ggplot(df, aes(x = TotalCost, y = ERVisits)) +
  geom_point(position=position_jitter(width=0.3, height=0.3)) + 
  geom_smooth(method = "lm", color = "red") +  
  labs(x = "TotalCost", y = "ERVisits", title = "ERVisits vs TotalCost Scatter Plot") +
  theme_minimal()

ggplot(df, aes(x = TotalCost, y = ERVisits)) +
  geom_point(position=position_jitter(width=0.3, height=0.3)) + 
  geom_smooth(method = "lm", color = "red") +  
  labs(x = "TotalCost", y = "ERVisits", title = "ERVisits vs TotalCost Scatter Plot") +
  theme_minimal()

ggplot(df, aes(x = Interventions, y = ERVisits)) +
  geom_point(position=position_jitter(width=0.3, height=0.3)) +  
  geom_smooth(method = "lm", color = "red") +  
  labs(x = "Intervention", y = "ERVisits", title = "ERVisits vs Intervention Scatter Plot") +
  theme_minimal()

ggplot(df, aes(x = Drug, y = ERVisits)) +
  geom_point(position=position_jitter(width=0.3, height=0.3)) + 
  geom_smooth(method = "lm", color = "red") + 
  labs(x = "Drug", y = "ERVisits", title = "ERVisits vs Drug Scatter Plot") +
  theme_minimal()

## 2.3.2 Boxplots 
ggplot(df, aes(x = as.factor(Gender), y = ERVisits)) +
  geom_boxplot() +
  labs(title = "ERVisits by Gender", x = "Gender (0 = Female, 1 = Male)", y = "ERVisits") 

ggplot(df, aes(x = as.factor(Heart_Disease), y = ERVisits)) +
  geom_boxplot() +
  labs(title = "ERVisits by Number of Heart Disease", x = "Number of Heart Disease", y = "ERVisits") 

######################################################################################################################################################

# Modeling

# 3.2. Min-Max scailing for numeric variables
min_max_scaling <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}
selected_vars <- c("TotalCost","Age", "Interventions","Drug", "Other_Diseases","Duration")
df[selected_vars] <- lapply(df[selected_vars], min_max_scaling)

# 3.3. Poisson model and stepwise selection
model.pois<-glm(ERVisits~., family=poisson, data=df) 
step_model1 <- stepAIC(model.pois, direction = "both")
summary(step_model1)

# 3.4. Negative binomial model and stepwise selection
model.nb<-glm.nb(ERVisits~., data=df) 
step_model2 <- stepAIC(model.nb, direction = "both")
summary(step_model2)

# 3.5. goodness of fit - LRT : Result interpretation - help
library(lmtest)
lrtest(step_model1,step_model2)

# 3.6.  Check VIF
library(car)
vif(step_model2)

# 3,8 Check Assumption - residuals
plot(resid(model.pois, type = "pearson") ~ fitted.values(model.pois), 
     ylab = "Pearson Residuals", xlab = "Fitted Values",
     main = "Residuals vs Fitted Values")
abline(h = 0, col = "red")


######################################################################################################################################################

# Model Chart

## Possion Regression
model.pois<-glm(ERVisits~., family=poisson, data=df) 
summary(model.pois)

step_model1 <- stepAIC(model.pois, direction = "both")
summary(step_model1)

# Extract coefficients and relevant statistics from the model
model_summary <- summary(step_model1)$coefficients

model_df <- as.data.frame(model_summary)


colnames(model_df) <- c("Estimate", "Std. Error", "z value", "Pr(>|z|)")

knitr::kable(model_df, 
             caption = "Summary of Poisson Regression Model",
             digits = c(4, 4, 4, 8),  # Setting 8 decimal places for p-value
             align = c('l', 'c', 'c', 'c', 'c')) %>%
  kableExtra::kable_styling(font_size = 12, 
                            latex_options = c("HOLD_position", "scale_down"))

model_summary <- summary(step_model1)

model_df <- as.data.frame(model_summary$coefficients)

colnames(model_df) <- c("Estimate", "Std. Error", "z value", "Pr(>|z|)")

model_df$"Pr(>|z|)" <- sprintf("%.3f", model_df$"Pr(>|z|)")

# Round the values to at most three digits after the decimal place
model_df$Null_Deviance <- ifelse(row.names(model_df) == "(Intercept)", round(model_summary$null.deviance, 3), "")
model_df$Residual_Deviance <- ifelse(row.names(model_df) == "(Intercept)", round(model_summary$deviance, 3), "")
model_df$AIC <- ifelse(row.names(model_df) == "(Intercept)", round(model_summary$aic, 3), "")
model_df$Dispersion <- ifelse(row.names(model_df) == "(Intercept)", round(model_summary$dispersion, 3), "")

kable_output <- knitr::kable(model_df, 
                             caption = "Summary of Poisson Regression Model",
                             digits = c(3, 3, 3, 3, 3, 3, 3, 3),  # Setting 3 decimal places for the mentioned values
                             align = c('l', 'c', 'c', 'c', 'c', 'c', 'c', 'c')) %>%
  kableExtra::kable_styling(font_size = 12, 
                            latex_options = c("HOLD_position", "scale_down")) %>%
  kableExtra::column_spec(column = 5:8, border_left = TRUE)

kable_output

## Negative Binomial Regression
model.nb<-glm.nb(ERVisits~., data=df)
summary(model.nb)

step_model2 <- stepAIC(model.nb, direction = "both")
summary(step_model2)

model_summary_nb <- summary(step_model2)

model_df_nb <- as.data.frame(model_summary_nb$coefficients)

colnames(model_df_nb) <- c("Estimate", "Std. Error", "z value", "Pr(>|z|)")

model_df_nb$"Pr(>|z|)" <- sprintf("%.3f", model_df_nb$"Pr(>|z|)")

# Round the values to at most three digits after the decimal place
model_df_nb$Null_Deviance <- ifelse(row.names(model_df_nb) == "(Intercept)", sprintf("%.3f", model_summary_nb$null.deviance), "")
model_df_nb$Residual_Deviance <- ifelse(row.names(model_df_nb) == "(Intercept)", sprintf("%.3f", model_summary_nb$deviance), "")
model_df_nb$AIC <- ifelse(row.names(model_df_nb) == "(Intercept)", sprintf("%.3f", model_summary_nb$aic), "")
model_df_nb$Theta <- ifelse(row.names(model_df_nb) == "(Intercept)", sprintf("%.3f", model_summary_nb$theta), "")
model_df_nb$Std_Err_Theta <- ifelse(row.names(model_df_nb) == "(Intercept)", sprintf("%.3f", sqrt(model_summary_nb$dispersion)), "")

kable_output_nb <- knitr::kable(model_df_nb, 
                                caption = "Summary of Negative Binomial Regression Model",
                                digits = c(3, 3, 3, 3, 3, 3, 3, 3, 3),  # Setting 3 decimal places for the mentioned values
                                align = c('l', 'c', 'c', 'c', 'c', 'c', 'c', 'c', 'c')) %>%
  kableExtra::kable_styling(font_size = 12, 
                            latex_options = c("HOLD_position", "scale_down")) %>%
  kableExtra::column_spec(column = 5:9, border_left = TRUE) 

kable_output_nb



# Run the likelihood ratio test
lrt_result <- lrtest(step_model1, step_model2)

lrt_stats <- data.frame(
  Model = c("Poisson Model", "NB Model", "Likelihood Ratio Test"),
  Df = c(7, 8, 1),
  LogLik = c(-1627.0, -1610.3, NA),
  Chisq = c(NA, NA, 33.454),
  Pr = c(NA, NA, 0)
)

lrt_stats$Df <- sprintf("%d", lrt_stats$Df)
lrt_stats$LogLik <- sprintf("%.2f", lrt_stats$LogLik)
lrt_stats$Chisq <- sprintf("%.4f", lrt_stats$Chisq)
lrt_stats$Pr <- sprintf("%.4f", lrt_stats$Pr)

lrt_table <- knitr::kable(lrt_stats, 
                          caption = "Likelihood Ratio Test Results",
                          align = c('l', 'c', 'c', 'c', 'c')) %>%
  kableExtra::kable_styling(font_size = 12, 
                            latex_options = c("HOLD_position", "scale_down"))

lrt_table


# VIF result table
vif_results <- vif(step_model2)

vif_df <- as.data.frame(vif_results)
colnames(vif_df) <- c("VIF")
kable_output <- knitr::kable(vif_df, 
                             caption = "VIF for Model Predictors",
                             digits = 3, 
                             align = c('l', 'c')) %>%
  kableExtra::kable_styling(font_size = 12)

kable_output



