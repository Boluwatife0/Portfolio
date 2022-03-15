glass <- read.csv("~/Downloads/glass.data", header=FALSE)
 View(glass)

# assigning column names as the header
colnames(glass) <- c("Id number","RI","Na","Mg", "Al", "Si", "K", "Ca", "Ba", "Fe", "Type_of_glass")
glass

#remove the column with the unnecessary indexes
glass$`Id number` <- NULL
glass

library(tidyverse)
glimpse(glass)

# any missing values in the dataframe?
sum(is.na(glass))


head(glass)
summary(glass)
str(glass)
class(glass)

# central tendency
summary(glass$Type_of_glass)
boxplot(glass$RI) # we have around 14 values as outliers for the refractive index (RI)

#spread
hist(glass$RI)
plot(density(glass$Type_of_glass), main = "Type of glass Spread")

?density

# plot
library(ggplot2)
#plot for discrete values using ggplot
type_plot <- ggplot(glass, aes(Type_of_glass))
type_plot <- type_plot + geom_bar()
type_plot

#plot for continuous values using ggplot
Na_plot <- ggplot(glass, aes(Na, Type_of_glass))
Na_plot
Na_plot + geom_point()
Na_plot + geom_jitter()


#plot of the distribution of each type of glass
glass$Type_of_glass <- as.factor(glass$Type_of_glass)
ggplot(glass, aes(x = Type_of_glass, colour = Type_of_glass)) + 
  geom_density(aes(group = Type_of_glass, fill = Type_of_glass), alpha = 0.3) +
  labs(title = "Distribution of each Type")

#correlation of each type of glass
corrGlass <- round(cor(glass[1:9]), 3)
corrplot(corrGlass, method = "color", tl.col = "black", tl.cex = 0.65)

# setting the seed number means that when you re-run the model, you wil get the same result.
set.seed(100)

#Data Splitting
#we will split the glass dataset into 2 parts, one part will be the training set which we will use to create a training model.
#Then we will use the training model to predict the class label in the 20% of the testing set.
# Performs stratified random split of the data set
# each type of glass will be assigned a unique ID, contains 80%(0.8) of original ds
TrainingIndex <- createDataPartition(glass$Type_of_glass, p=0.8, list = FALSE) # Class label here is Type_of_glass
TrainingSet <- glass[TrainingIndex,] #Training Set contains 80%
TestingSet <- glass [-TrainingIndex,] #Test Set contains 20%

#scatterplots of both training sets
plot(TrainingSet , col = "blue")
plot(TestingSet , col = "red")

#Build Training model
Model <- train(Type_of_glass ~ ., data = TrainingSet,
                  method = "svmPoly", #polynomial Kernel
                  na.action = na.omit,# where there a missing value it will omit it
                  preProcess=c("scale", "center"), #before building model, for each variable it will compute mean value and subtract each value of each row with mean value of each column, for each variable we have a mean value of 0, scale data to mean centering
               # so the resulting mean when you compute it for the second time will equal to 0
                  trControl= trainControl(method= "none"),
                  tuneGrid = data.frame(degree=1,scale=1,C=1)
)

#Build CV (Cross Validation) Model
Model.cv <- train(Type_of_glass ~ ., data = TrainingSet,
                  method = "svmPoly", #polynomial Kernel
                  na.action = na.omit,# where there a missing value it will omit it
                  preProcess=c("scale", "center"), #before building model, will compute mean value and subtract each value of each row with mean value of each column, for each variable we have a mean value of 0, scale data to mean centering
                  trControl= trainControl(method="cv", number=10),
                  tuneGrid = data.frame(degree=1,scale=1,C=1)
)
# A training model will use the training set to build the model. we will use the 80% subset
#to build a training model.
#we will then apply the training model to predict the class label in the testing set, the external set

# we will set the K fold to be a 10 fold cross validation 
# for cross validation, 174 Types of glass will be divided into 10 sub groups, each subgroup will contain
# which represents the 20%
#so each subgroup will contain 17 types of glass
# when you take out one of the 10 subgroup remaining 9 left, we will use the 9 to create a training model
# and use that training model to predict the class class label for the 17 type of glass.
# This process will then be iterate over the other 9 subgroups for testing and prediction.

#Apply model for prediction
Model.training <-predict(Model, TrainingSet) # Apply model to make prediction on 174 types of glass of Training set
Model.testing <-predict(Model, TestingSet)# Apply model to make prediction on 40 types of glass of Testing set
Model.cv <-predict(Model.cv, TrainingSet)#Perform cross-validation

# Model performance (Displays confusion matrix and statistics)
Model.training.confusion <- confusionMatrix(Model.training, TrainingSet$Type_of_glass)
Model.testing.confusion <- confusionMatrix(Model.testing, TestingSet$Type_of_glass)
Model.cv.confusion <- confusionMatrix(Model.cv, TrainingSet$Type_of_glass)

print(Model.training.confusion)
print(Model.testing.confusion)
print(Model.cv.confusion)

# Feature importance
Importance <- varImp(Model)
plot(Importance)
plot(Importance, col = "red")

# we can see from the feature of importance that Aluminium (Al) was the most consistently important variable in the output of the predictions
# For headlamps, Mg (Magnesium) and Al were the 2 most important variables contributing to the output of the prediction.
#For tableware, vehicle_windows_float_processed and building_windows_float_processed, Barium (Ba) did not influence the prediction result

