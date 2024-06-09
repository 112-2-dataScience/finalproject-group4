# Load necessary libraries
library(tidyverse)
library(data.table)
library(randomForest)
library(themis)
library(MASS)
library(caret)
library(car)
library(dplyr)
library(ranger)

# Load the data
data <- read_csv("WA_Fn-UseC_-Telco-Customer-Churn.csv")

# Data Preprocessing
data <- data %>%
  drop_na() %>%
  distinct() 
data <- data[, -1]# Drop the customerID column
data <- data %>%
  mutate(
    MultipleLines = case_when(
      MultipleLines == "No phone service" ~ "No",
      TRUE ~ as.character(MultipleLines))
  )
data <- data %>%
  mutate(
    OnlineSecurity = case_when(
      OnlineSecurity == "No internet service" ~ "No",
      TRUE ~ as.character(OnlineSecurity)
    ))
data <- data %>%
  mutate(
    OnlineBackup = case_when(
      OnlineBackup == "No internet service" ~ "No",
      TRUE ~ as.character(OnlineBackup)
    ))
data <- data %>%
  mutate(
    DeviceProtection = case_when(
      DeviceProtection == "No internet service" ~ "No",
      TRUE ~ as.character(DeviceProtection)
    ))
data <- data %>%
  mutate(
    TechSupport = case_when(
      TechSupport == "No internet service" ~ "No",
      TRUE ~ as.character(TechSupport)
    ))
data <- data %>%
  mutate(
    StreamingTV = case_when(
      StreamingTV == "No internet service" ~ "No",
      TRUE ~ as.character(StreamingTV)
    ))
data <- data %>%
  mutate(
    StreamingMovies = case_when(
      StreamingMovies == "No internet service" ~ "No",
      TRUE ~ as.character(StreamingMovies)
    ))

data$SeniorCitizen <- as.factor(data$SeniorCitizen)
data$tenure <- as.numeric(data$tenure)
data$MonthlyCharges <- as.numeric(data$MonthlyCharges)
data$TotalCharges <- as.numeric(data$TotalCharges)
data$gender <- as.factor(data$gender)
data$Partner <- as.factor(data$Partner)
data$Dependents <- as.factor(data$Dependents)
data$PhoneService <- as.factor(data$PhoneService)
data$MultipleLines <- as.factor(data$MultipleLines)
data$InternetService <- as.factor(data$InternetService)
data$OnlineSecurity <- as.factor(data$OnlineSecurity)
data$OnlineBackup <- as.factor(data$OnlineBackup)
data$DeviceProtection <- as.factor(data$DeviceProtection)
data$TechSupport <- as.factor(data$TechSupport)
data$StreamingTV <- as.factor(data$StreamingTV)
data$StreamingMovies <- as.factor(data$StreamingMovies)
data$Contract <- as.factor(data$Contract)
data$PaperlessBilling <- as.factor(data$PaperlessBilling)
data$PaymentMethod <- as.factor(data$PaymentMethod)
data$Churn <- as.factor(data$Churn)# Convert necessary columns to factors and numeric


set.seed(111)
new_data <- smotenc(data, "Churn", k =5,  over_ratio = 1)# Oversampling

set.seed(111)
step_train_index <- createDataPartition(new_data$Churn, p = 0.8, list = FALSE)
step_train_data <- new_data[step_train_index,]
step_test_data <- new_data[-step_train_index,]

## 設置交叉驗證使用的超參數
set.seed(111)
xg_control <- trainControl(method = "cv", number = 10)
xg_grid <- expand.grid(
  nrounds = c(100, 150),             
  max_depth = c(6, 8),               
  eta = c(0.1, 0.3),                 
  gamma = c(0, 0.1),                 
  colsample_bytree = c(0.8, 1.0),    
  subsample = c(0.8, 1.0),           
  min_child_weight = c(1, 3)         
)

# Train the model 
set.seed(111)
xgb_model <- train(
  Churn ~ Dependents + tenure + PhoneService + MultipleLines + 
    InternetService + OnlineSecurity + OnlineBackup + TechSupport + StreamingTV +
    StreamingMovies + Contract + PaperlessBilling + PaymentMethod,
  data = step_train_data,
  method = "xgbTree",
  trControl = xg_control,
  tuneGrid = xg_grid
)

## train data
train_predictions <- predict(xgb_model, newdata = step_train_data)
train_conf_matrix <- confusionMatrix(train_predictions, step_train_data$Churn)
print(train_conf_matrix)


# test data
xg_prediction <- predict(xgb_model, step_test_data, type = "raw")
xg_confusion_matrix <- confusionMatrix(xg_prediction, step_test_data$Churn)
print(xg_confusion_matrix)