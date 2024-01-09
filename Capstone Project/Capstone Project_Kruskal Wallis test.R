# 0. Set working directory and load data
setwd("~/Desktop/JH/PSU/23 Fall/STAT 470w/Case Study 3")
knitr::opts_chunk$set(echo = TRUE)

library(vroom)
library(tidyverse)
library(dplyr)
library(reshape2)
library(tidyr)
library(ggplot2)
library(stringr)
library(car)
library(gt)
library(dunn.test)
library(PMCMRplus)

Intonation <-  vroom("Intonation.csv", col_types = c(numPoints = "i"))


# 1. Data Preprocessing

# 1.1 Extract those characters from filenames (A or B)
df <- Intonation %>%
  mutate(FileName = gsub(".*_(A|B)_.*", "\\1", FileName))

# 1.2 Remove Pt9time column (NA)
df <- df %>% select(-Pt9Time)

# 1.3 Add Columns - syllable.x.ptNum 
calculate_ptNum <- function(start, end, ptTimes) {
  sum(ptTimes >= start & ptTimes <= end, na.rm = TRUE) # start와 end 사이에 있는 ptTimes의 개수를 카운트합니다.
}

df <- df %>%
  rowwise() %>%
  mutate(
    syllable.1.ptNum = calculate_ptNum(syllableStart.1, syllableEnd.1, c(Pt1Time, Pt2Time, Pt3Time, Pt4Time, Pt5Time, Pt6Time, Pt7Time, Pt8Time)),
    syllable.2.ptNum = calculate_ptNum(syllableStart.2, syllableEnd.2, c(Pt1Time, Pt2Time, Pt3Time, Pt4Time, Pt5Time, Pt6Time, Pt7Time, Pt8Time)),
    syllable.3.ptNum = calculate_ptNum(syllableStart.3, syllableEnd.3, c(Pt1Time, Pt2Time, Pt3Time, Pt4Time, Pt5Time, Pt6Time, Pt7Time, Pt8Time)),
    syllable.4.ptNum = calculate_ptNum(syllableStart.4, syllableEnd.4, c(Pt1Time, Pt2Time, Pt3Time, Pt4Time, Pt5Time, Pt6Time, Pt7Time, Pt8Time)),
    syllable.5.ptNum = calculate_ptNum(syllableStart.5, syllableEnd.5, c(Pt1Time, Pt2Time, Pt3Time, Pt4Time, Pt5Time, Pt6Time, Pt7Time, Pt8Time)),
    syllable.6.ptNum = calculate_ptNum(syllableStart.6, syllableEnd.6, c(Pt1Time, Pt2Time, Pt3Time, Pt4Time, Pt5Time, Pt6Time, Pt7Time, Pt8Time)),
    syllable.7.ptNum = calculate_ptNum(syllableStart.7, syllableEnd.7, c(Pt1Time, Pt2Time, Pt3Time, Pt4Time, Pt5Time, Pt6Time, Pt7Time, Pt8Time))
  ) %>%
  ungroup() 


# 2. EDA section

# 2.1. Change the dataset into long format
df_long <- df %>%
  pivot_longer(
    cols = starts_with("syllable."), 
    names_to = "Syllable", 
    names_prefix = "syllable\\.",  
    values_to = "ptNum"
  ) %>%
  mutate(Syllable = str_replace(Syllable, "\\D+", ""), 
         Syllable = paste("Syllable", Syllable)) 

# 2.2. Figure 1 - Bar Plot
ggplot(df_long, aes(x = Syllable, y = ptNum)) +
  geom_bar(stat = "identity") +
  labs(title = "Bar Plot of Pitch Points per Syllable", x = "Syllable", y = "Pitch Points") +
  theme_minimal()


# 2.3. Figure 2
df_summary <- df_long %>%
  group_by(FileName, Syllable) %>%
  summarise(TotalPtNum = sum(ptNum, na.rm = TRUE)) %>%
  ungroup()

ggplot(df_summary, aes(x = FileName, y = TotalPtNum, fill = Syllable)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(title = "Bar Plot of Total Pitch Points per Syllable by FileType", x = "File Type", y = "Total Pitch Points") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")



# 2.4. Figure 3 - Updated to Bar Plot
df_summary2 <- df_long %>%
  group_by(Sex, Syllable) %>%
  summarise(TotalPtNum = sum(ptNum, na.rm = TRUE)) %>%
  ungroup()

ggplot(df_summary2, aes(x = Sex, y = TotalPtNum, fill = Syllable)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(title = "Bar Plot of Pitch Points per Syllable by Sex", x = "Sex", y = "Pitch Points") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")


# 2.5. Figure 4 - Updated to Bar Plot
df_summary3 <- df_long %>%
  group_by(FinalSyll, Syllable) %>%
  summarise(TotalPtNum = mean(ptNum, na.rm = TRUE)) %>%
  ungroup()

ggplot(df_summary3, aes(x = FinalSyll, y = TotalPtNum, fill = Syllable)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(title = "Bar Plot of Mean Pitch Points by Final Syllable Type", x = "FinalSyll", y = "Mean Pitch Points") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")



# 3. Point Estimation

# Calculate mean and standard deviation
summary_stats <- long_df %>%
  group_by(Syllable) %>%
  summarise(
    Mean = mean(ptNum),
    SD = sd(ptNum),
    n = n()
  )

# Function to calculate 95% CI
conf_int <- function(mean, sd, n, conf_level = 0.95) {
  error_margin <- qt(conf_level + (1 - conf_level) / 2, df = n - 1) * sd / sqrt(n)
  lower_bound <- mean - error_margin
  upper_bound <- mean + error_margin
  return(c(lower_bound, upper_bound))
}

# Calculate 95% CI
summary_stats <- summary_stats %>%
  rowwise() %>%
  mutate(
    CI_Lower = conf_int(Mean, SD, n)[1],
    CI_Upper = conf_int(Mean, SD, n)[2],
    CI = sprintf("(%0.3f, %0.3f)", CI_Lower, CI_Upper)
  ) %>%
  ungroup() %>%
  select(-CI_Lower, -CI_Upper) 

# Print summary table
summary_stats %>%
  knitr::kable(
    digits = 3,
    caption = "Point Estimates with 95% Confidence Intervals",
    booktabs = TRUE,
    align = "c"
  ) %>%
  kableExtra::kable_styling(
    font_size = 12,
    latex_options = c("HOLD_position")
  )


# 4. Parametric Assumption check

# 4.1 Create ANOVA model
model1 <- aov(ptNum ~ Syllable, data = df_long)
summary(model1)


# 4.2 Gaussian -> residuals follow normal distribution
qq_plot <- car::qqPlot(
  x = model1$residuals,
  distribution = "norm",
  envelope = 0.95,
  id = FALSE,
  pch = 20,
  ylab = "Residuals"
)
title(main = "QQ Plot: Gaussian Assumption")


# 4.3 Homoscedasticity (Equal Variance Residual)
ggplot(
  data = data.frame(
    residuals = model1$residuals,
    fitted = model1$fitted.values
  ),
  mapping = aes(x = fitted, y = residuals)
) +
  geom_point(size = 2) +  
  geom_smooth(method = "loess", se = FALSE, color = "blue") +  
  theme_bw() +  
  labs(
    title = "Residuals vs Fitted Values",
    x = "Fitted Values",
    y = "Residuals"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold")
  )

# 5. Kruskal-Wallis test
kruskal_result <- kruskal.test(ptNum ~ Syllable, data=df_long)

kruskal_df <- data.frame(
  Test = "Kruskal-Wallis",
  Chi_Squared = kruskal_result$statistic,
  Degrees_of_Freedom = kruskal_result$parameter,
  p_value = 0
)

# Format the p-value
kruskal_df$p_value <- format(kruskal_df$p_value, digits = 4)

kruskal_table <- gt(kruskal_df) %>%
  tab_header(
    title = "Kruskal-Wallis Test Result",
    subtitle = ""
  ) %>%
  fmt_number(
    columns = everything(),
    decimals = 3
  )

# Print the table
print(kruskal_table)







