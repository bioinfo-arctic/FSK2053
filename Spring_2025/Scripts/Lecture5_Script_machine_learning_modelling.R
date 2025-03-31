#install.packages("tidymodels")
#install.packages("ranger")

library(tidymodels)
library(tidyverse)

url <- "https://raw.githubusercontent.com/bioinfo-arctic/FSK2053/edd2d547ad9c955d5523541b61420f57e31c32cf/Spring_2023/data/database_salmon_lice_outbreaks.csv"

# dat <- read_csv("G:/My Drive/UiT_projects/Teaching/FSK2053 Data Science and Bioinformatics Daniel/Data/database_salmon_lice_outbreaks.csv")
dat <- read_csv(url)
dat

names(dat)
# There are too many zeros in the data. Let's do some histograms:
ggplot(dat) +
  geom_histogram(aes(x = temperature))

# ggplot(dat) +
#   geom_density(aes(x = temperature))

ggplot(dat) +
  geom_histogram(aes(x = phosphorus))

ggplot(dat) +
  geom_histogram(aes(x = nitrogen))

ggplot(dat) +
  geom_histogram(aes(x = salinity))

ggplot(dat) +
  geom_histogram(aes(x = dinoflagellates))

ggplot(dat) +
  geom_histogram(aes(x = diatoms))

# The missing data have been encoded as zeros! We will convert them to missing data again in all the variables affected.
# To do that, we use the mutate_at() function to specify which variables we want to apply our mutating function to
# and we use the if_else() function to specify what to replace the value with if the condition is true or false.

dat_clean <- dat %>%
  mutate_at(vars(temperature, chlorophyll, phosphorus, nitrogen, salinity), 
            function(.var) { 
              if_else(condition = (.var == 0), # if true (i.e. the entry is 0)
                      true = as.numeric(NA),  # replace the value with NA
                      false = .var # otherwise leave it as it is
              )
            })
dat_clean

# Check that it worked
ggplot(dat_clean) +
  geom_histogram(aes(x = nitrogen))

dat_clean$nitrogen %>% sort()

###############################
#### Split into train/test sets
###############################

# First, let’s split our dataset into training and testing data. 
# The training data will be used to fit our model and tune its parameters, 
# The testing data will be used to evaluate our final model’s performance.

set.seed(234589)

sample(x = 1:5, 1, replace = F)

# split the data into trainng (75%) and testing (25%)
salmonlice_split <- initial_split(dat_clean, prop = 3/4)
# The printed output tells us how many observations we have in the training set, the testing set, and overall: <train/test/total>:
salmonlice_split

# The training and testing sets can be extracted from the “split” object using the training() and testing() functions. 
# Although, we won’t actually use these objects in the pipeline (we will be using the salmonlice_split object itself).
# extract training and testing sets
salmonlice_train <- training(salmonlice_split)
salmonlice_test <- testing(salmonlice_split)

# At some point we’re going to want to do some parameter tuning, and to do that we’re going to want to use cross-validation.
# So we can create a cross-validated version of the training set in preparation for that moment using vfold_cv().
# create CV object from training data
salmonlice_cv <- vfold_cv(salmonlice_train)

###############################
#####  Define a recipe
###############################

# Recipes allow you to specify the role of each variable as an outcome or predictor variable (using a “formula”),
# and any pre-processing steps you want to conduct (such as normalization, imputation, PCA, etc).

# Creating a recipe has two parts (layered on top of one another using pipes %>%):
#   1. Specify the formula (recipe()): specify the outcome variable and predictor variables
#   2. Specify pre-processing steps (step_zzz()): define the pre-processing steps, such as imputation, creating dummy variables, scaling, and more

# Define the recipe
salmonlice_recipe <- 
  # which consists of the formula (outcome ~ predictors)
  recipe(salmon_lice_outbreak ~ past_virus_outbreaks + temperature + chlorophyll + phosphorus + 
           nitrogen + salinity + dinoflagellates + diatoms, 
         data = dat_clean) %>%
  # and some pre-processing steps
  step_normalize(all_numeric()) %>%
  step_impute_knn(all_predictors())

# salmonlice_recipe <- 
#   # which consists of the formula (outcome ~ predictors)
#   recipe(salmon_lice_outbreak ~ ., 
#          data = dat_clean) %>%
#   # and some pre-processing steps
#   step_normalize(all_numeric()) %>%
#   step_impute_knn(all_predictors())

# Actually, since we are using all variables in the dataset, we could have written our formula much more efficiently
# using the formula short-hand where . represents all of the variables in the data: 
# outcome ~ . will fit a model that predicts the outcome using all other columns.

# In the recipe steps above we used the functions all_numeric() and all_predictors() as arguments to the pre-processing steps.
# These are called “role selections”, and they specify that we want to apply the step to “all numeric” variables or “all predictor variables”. 
# The list of all potential role selectors can be found by typing ?selections into your console.

salmonlice_recipe

# If you want to extract the pre-processed dataset itself, you can first prep() the recipe for a specific dataset 
# and juice() the prepped recipe to extract the pre-processed data. 
# This isn’t actually necessary for the pipeline, since this will be done under the hood when the model is fit, 
# but sometimes it’s useful anyway.

salmonlice_train_preprocessed <- salmonlice_recipe %>%
  # apply the recipe to the training data
  prep(salmonlice_train) %>%
  # extract the pre-processed training dataset
  juice()

salmonlice_train_preprocessed

###############################
###### Specify the model
###############################
# So far we’ve split our data into training/testing, and we’ve specified our pre-processing steps using a recipe.
# The next thing we want to specify is our model (using the parsnip package).
# There are a few primary components that you need to provide for the model specification
#    1. The model type: what kind of model you want to fit, set using a different function depending on the model, such as rand_forest() for random forest, logistic_reg() for logistic regression, svm_poly() for a polynomial SVM model etc. 
#    2. The arguments: the model parameter values (now consistently named across different models), set using set_args().
#    3. The engine: the underlying package the model should come from (e.g. “ranger” for the ranger implementation of Random Forest), set using set_engine().
#    4. The mode: the type of prediction - since several packages can do both classification (binary/categorical prediction) and regression (continuous prediction), set using set_mode().

# For instance, if we want to fit a random forest model as implemented by the ranger package
# for the purpose of classification and we want to tune the mtry parameter (the number of randomly selected variables to be considered at each split in the trees), 
# then we would define the following model specification:

#! tune
#! importance
  rf_model <- 
  # specify that the model is a random forest
  rand_forest() %>%
  # specify that the `mtry` parameter needs to be tuned
  set_args(mtry = tune()) %>%
  # select the engine/package that underlies the model
  set_engine("ranger", importance = "impurity") %>%
  # choose either the continuous regression or binary classification mode
  set_mode("classification") 

rf_model
# If you want to be able to examine the variable importance of your final model later, 
# you will need to set importance argument when setting the engine. 
# For ranger, the importance options are "impurity" or "permutation".

# As another example, the following code would instead specify a logistic regression model from the glm package.

lr_model <- 
  # specify that the model is a logistic regression
  logistic_reg() %>%
  # select the engine/package that underlies the model
  set_engine("glm") %>%
  # choose either the continuous regression or binary classification mode
  set_mode("classification") 

# Note that this code doesn’t actually run the fitting the model. Like the recipe, it just outlines a description of the model. 
# Moreover, setting a parameter to tune() means that it will be tuned later in the tune stage of the pipeline
# (i.e. the value of the parameter that yields the best performance will be chosen). 
# You could also just specify a particular value of the parameter if you don’t want to tune it e.g. using set_args(mtry = 4).

###################################
# Put it all together in a workflow
###################################
# We’re now ready to put the model and recipes together into a workflow. 
# You initiate a workflow using workflow() (from the workflows package) and then you can add a recipe and add a model to it.

# set the workflow
rf_workflow <- workflow() %>%
  # add the recipe
  add_recipe(salmonlice_recipe) %>%
  # add the model
  add_model(rf_model)

# Note that we still haven’t yet implemented the pre-processing steps in the recipe nor have we fit the model.
# We’ve just written the framework. 
# It is only when we tune the parameters or fit the model that the recipe and model frameworks are actually implemented.

###################################
# Tune the parameters
###################################

# Since we had a parameter that we designated to be tuned (mtry), we need to tune it 
# (i.e. choose the value that leads to the best performance) before fitting our model.
# If you don’t have any parameters to tune, you can skip this step.

# Note that we will do our tuning using the cross-validation object (salmonlice_cv).
# A cross-validation is a statistical method used to estimate the skill of a machine learning model on unseen data. 
# It is used to protect against overfitting and to assess how the results 
# of a statistical analysis will generalize to an independent dataset.

# Cross-validation is particularly useful when tuning model parameters, 
# such as the mtry parameter in Random Forest. By evaluating different values
# of mtry across multiple folds of the data, you can assess how changes to this 
# parameter affect the model's ability to generalize to new data. 
# The value of mtry that results in the best average performance across 
# the folds is typically chosen as the optimal parameter for the final model.

# To do this, we specify the range of mtry values we want to try, and then we add a tuning layer to our workflow using tune_grid() (from the tune package)
# Note that we focus on two metrics: accuracy and roc_auc (from the yardstick package).
# specify which values eant to try


#! Meaning of mtry
#! why pass a expand grid to tunegrid?

#install.packages("ranger")
library(ranger)
rf_grid <- expand.grid(mtry = c(3, 4, 5))
# extract results
rf_tune_results <- rf_workflow %>%
  tune_grid(resamples = salmonlice_cv, #CV object
            grid = rf_grid, # grid of values to try
            metrics = metric_set(accuracy, roc_auc) # metrics we care about
  )

# You can tune multiple parameters at once by providing multiple parameters to the expand.grid() function,
# e.g. expand.grid(mtry = c(3, 4, 5), trees = c(100, 500)).

# It’s always a good idea to explore the results of the cross-validation.
# collect_metrics() is a really handy function that can be used in a variety of circumstances to extract any metrics 
# that have been calculated within the object it’s being used on.
# In this case, the metrics come from the cross-validation performance across the different values of the parameters.

# print results
rf_tune_results %>%
  collect_metrics()
# We can see in the table that across both accuracy and AUC, mtry = 4 yields the best performance.

###################################
#### Finalize the workflow
###################################
# We want to add a layer to our workflow that corresponds to the tuned parameter,
# i.e. sets mtry to be the value that yielded the best results. 
# If you didn’t tune any parameters, you can skip this step.
# We can extract the best value for the accuracy metric by applying the select_best() function to the tune object.

param_final <- rf_tune_results %>%
  select_best(metric = "roc_auc")
param_final

# Then we can add this parameter to the workflow using the finalize_workflow() function.

param_final$mtry <- 8

rf_workflow <- rf_workflow %>%
  finalize_workflow(param_final)

######################################
### Evaluate the model on the test set
######################################
# Now we’ve defined our recipe, our model, and tuned the model’s parameters, we’re ready to actually fit the final model.
# Since all of this information is contained within the workflow object, we will apply the last_fit() function to our workflow
# and our train/test split object. 
# This will automatically train the model specified by the workflow using the training data, 
# and produce evaluations based on the test set.

rf_fit <- rf_workflow %>%
  # fit on the training set and evaluate on test set
  last_fit(salmonlice_split)
rf_fit

# Since we supplied the train/test object when we fit the workflow, the metrics are evaluated on the test set.
# Now when we use the collect_metrics() function, it extracts the performance of the final model
# (since rf_fit now consists of a single final model) applied to the test set.

test_performance <- rf_fit %>% collect_metrics()
test_performance

# You can also extract the test set predictions themselves using the collect_predictions() function.
# Note that there are 192 rows in the predictions object below which matches the number of test set observations
# (just to give you some evidence that these are based on the test set rather than the training set).

# generate predictions from the test set
test_predictions <- rf_fit %>% collect_predictions()
test_predictions

# We can generate summaries and store them as a confusion matrix. And we can generate plots

# generate a confusion matrix
test_predictions %>% 
  conf_mat(truth = salmon_lice_outbreak, estimate = .pred_class)

# We can also plot distributions of the predicted probability distributions for each class.

test_predictions %>%
  ggplot() +
  geom_density(aes(x = .pred_pos, fill = salmon_lice_outbreak), 
               alpha = 0.5)

# If you want to use your model to predict the response for new observations, you need to use the fit() function 
# on your workflow and the dataset that you want to fit the final model on (e.g. the complete training + testing dataset).

final_model <- fit(rf_workflow, dat_clean)

# The final_model object contains a few things including the ranger object trained with the parameters established through the workflow 
# contained in rf_workflow based on the data in dat_clean (the combined training and testing data).

final_model

# If we wanted to predict the possibility of a salmon lice outbreak for a new data point, 
# we can use the normal predict() function.

# For instance, below we define the data for a new facility

new_facility <- tribble(~past_virus_outbreaks, ~temperature,	~chlorophyll,	~phosphorus,	~nitrogen,	~salinity,	~dinoflagellates,	~diatoms,
                        1, 9.5, 70, 31, 102, 28.2, 0.67, 47)
new_facility

# The predicted status of this new facility is “positive”.
predict(final_model, new_data = new_facility)

######################################
#### Variable importance
######################################
# If you want to extract the variable importance scores from your model, you need to extract the model object from the fit() object
# (which for us is called final_model). 
# The function that extracts the model is extract_fit_parsnip().

ranger_obj <- extract_fit_parsnip(final_model)

# Another option was using the pull_workflow_fit() function (now deprecated)
# ranger_obj_2 <- pull_workflow_fit(final_model)$fit

# Then you can extract the variable importance from the ranger object itself 
# variable.importance is a specific object contained within ranger output - this will need to be adapted for the specific object type of other models.

var_importance <- ranger_obj$fit$variable.importance
var_importance

#! variable importance coming from impurity
#! Highest value or lowest?

# And we can plot this information in a barplot:
as_tibble(var_importance) %>% mutate(names=names(var_importance)) %>% 
  ggplot(aes(x=reorder(names,value))) + geom_bar(stat="identity",aes(y=value),fill="blue") +
  coord_flip() +
  xlab("independent variable") +
  ylab("Variable importance, random forest") 

# Note: if we want to see the pairwise correlations between all the predictor variables, we can use the following: 
library("PerformanceAnalytics")
chart.Correlation(dat_clean[,-9], histogram=TRUE, pch=19)

#! autocorrelation problem

