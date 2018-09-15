install.packages("vtreat")
library("vtreat")
library("readr")

# read training set from data file
train <- read_csv("C:/Users/User/Desktop/Titanic/data_before_processing.csv")

# convert numeric columns that should be interpreted as categorical
cols <- c("SibSp", "Parch", "FamilySize", "Pclass")

# create a copy of training set
data <- train
# extract last name from data
data$LastName <- sapply(strsplit(data$Name, ","), `[`, 1)
data[cols] <- lapply(data[cols], as.character)

vars <- setdiff(colnames(data),c('PassengerId'))
# apply vtreat cross validation to develop treatments
cfe <- vtreat::mkCrossFrameCExperiment(data, vars, 'Survived', '1')
# store treatment plan
treatments <- cfe$treatments
# store treatment summary
treatmentSummary <- treatments$scoreFrame
# get treated trained data set
dTrainTreated <- cfe$crossFrame
dTrainTreated$PassengerId <- data$PassengerId

# export treated set to csv
write.csv(dTrainTreated, file = "C:/Users/User/Desktop/Titanic/dTrainTreated.csv")

# read test set from data file
test <- read_csv("C:/Users/User/Desktop/Titanic/scoring_before_processing.csv")
test[cols] <- lapply(test[cols], as.character)
test$LastName <- sapply(strsplit(test$Name, ","), `[`, 1)
dTestTreated <- vtreat::prepare(treatments,test)
dTestTreated$PassengerId <- test$PassengerId
# export treated test set to csv
write.csv(dTestTreated, file = "C:/Users/User/Desktop/Titanic/dTestTreated.csv")
