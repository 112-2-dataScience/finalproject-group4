# Load necessary libraries
library(tidyverse)
library(caret)
library(randomForest)
library(ranger)
library(themis)

# Load the data
data <- read.csv("WA_Fn-UseC_-Telco-Customer-Churn.csv")

# Data Preprocessing
data <- data %>%
  # Remove records where InternetService is "No" and PhoneService is "No"
  filter(InternetService != "No", PhoneService != "No") %>%
  # Convert necessary columns to factors and numeric
  mutate(
    gender = as.factor(gender),
    SeniorCitizen = as.factor(SeniorCitizen),
    Partner = as.factor(Partner),
    Dependents = as.factor(Dependents),
    MultipleLines = as.factor(MultipleLines),
    InternetService = as.factor(InternetService),
    OnlineSecurity = as.factor(OnlineSecurity),
    OnlineBackup = as.factor(OnlineBackup),
    DeviceProtection = as.factor(DeviceProtection),
    TechSupport = as.factor(TechSupport),
    StreamingTV = as.factor(StreamingTV),
    StreamingMovies = as.factor(StreamingMovies),
    Contract = as.factor(Contract),
    PaperlessBilling = as.factor(PaperlessBilling),
    PaymentMethod = as.factor(PaymentMethod),
    Churn = as.factor(Churn),
    tenure = as.numeric(tenure),
    MonthlyCharges = as.numeric(MonthlyCharges),
    # Remove any spaces and convert to numeric
    TotalCharges = as.numeric(gsub(" ", "", TotalCharges))
  )

# Drop the customerID and PhoneService columns
data <- data %>% select(-customerID, -PhoneService)

# Handle missing values
# Remove rows with missing values
data <- na.omit(data)

# Ensure all factors have at least two levels
data <- data %>%
  mutate_if(is.factor, ~fct_drop(.))

# Oversampling
set.seed(111)
data <- smotenc(data, "Churn", k=5, over_ratio=1)

# Split the data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(data$Churn, p = .8, 
                                  list = FALSE, 
                                  times = 1)
trainData <- data[trainIndex,]
testData  <- data[-trainIndex,]

# Ensure all factors in training data have at least two levels
trainData <- trainData %>%
  mutate_if(is.factor, ~fct_drop(.))

# Define the train control with k-fold cross-validation
train_control <- trainControl(method = "cv", number = 10, search = "grid")

# Define the grid of hyperparameters to tune
tune_grid <- expand.grid(
  mtry = c(2, 3, 4, 5, 6),
  splitrule = c("gini"),
  min.node.size = c(1, 3, 5, 7, 9)
)

# Train the model using k-fold cross-validation and hyperparameter tuning
set.seed(123)
rf_model <- train(
  Churn ~ ., data = trainData,
  method = "ranger",
  trControl = train_control,
  tuneGrid = tune_grid,
  importance = 'impurity'
)

# Print the best model and its parameters
print(rf_model$bestTune)
print(rf_model)

# Predict on test data
predictions <- predict(rf_model, testData)

# Evaluate the model
confusionMatrix(predictions, testData$Churn)