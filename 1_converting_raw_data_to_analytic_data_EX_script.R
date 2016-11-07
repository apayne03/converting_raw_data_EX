library(tidyverse)

# Loading & inspecting the raw data:

raw_data <- read_csv(file = "rawData.csv") 
## Then View(raw_data) in console -> notice there are "NA", "-999" and "-888" for missing values



# Command to remove the problematic missing values codes:

raw_data <- read_csv(file = "rawData.csv", na=c("","NA","-999","-888"))
## Then View(raw_data) in console --> notice the -999 and -888 have been removed successfully



# Handling categorical variables to factors - you MUST tell R which variables are categorical:

## Command to create a data set with just categorical variables
categorical_variables <- select(raw_data, group, gender)


## Command that tells R they are categorical by turning them to factors (using as.factor):

categorical_variables$group <- as.factor(categorical_variables$group)

categorical_variables$gender <- as.factor(categorical_variables$gender)
levels(categorical_variables$gender) <-list("Male"=1, "Female"=2)




# Handling Item Data:

## 1 - Checking items for out of range values

### First step is to breakout the scale items into separate data frames:
affective_commitment_items <- select(raw_data, AC1, AC2, AC3, AC4, AC5)
agreeableness_items <- select(raw_data, A1, A2, A3, A4, A5)
extroversion_items <- select(raw_data, E1, E2, E3, E4, E5)

### Second step is to check for out of value ranges in each set of items:
psych::describe(extroversion_items)
psych::describe(affective_commitment_items) # should be 1 to 7, notice there is a 9
psych::describe(agreeableness_items) # should be 1 to 5, notice there is a 7

### Third step is to fix the out of range values in each set of items by turning them into missing:

agreeableness_items
is_bad_value <- agreeableness_items<1 | agreeableness_items>5 # View(is_bad_value)
agreeableness_items[is_bad_value] <- NA # View(agreeableness_items) to confirm it worked
agreeableness_items

affective_commitment_items
is_bad_value <- affective_commitment_items<1 | affective_commitment_items>7
affective_commitment_items[is_bad_value] <- NA
affective_commitment_items

### Fourth step is to flip any reverse-key items - mutate command

agreeableness_items <- mutate(agreeableness_items, A5=6-A5) # note that the scoring key was 1 to 5
agreeableness_items # if the scoring had been 0 to 4, command would be: agreeableness_items <- mutate(agreeableness_items, A5=4-A5)

affective_commitment_items <- mutate(affective_commitment_items, AC4=8-AC4)
affective_commitment_items <- mutate(affective_commitment_items, AC5=8-AC5)

### Fifth step is to obtain scale scores

agreeableness <- psych::alpha(as.data.frame(agreeableness_items),check.keys = FALSE)$scores
extroversion <- psych::alpha(as.data.frame(extroversion_items),check.keys = FALSE)$scores
affective_commitment <- psych::alpha(as.data.frame(affective_commitment_items),check.keys = FALSE)$scores



# Combine everything into analytic_data

analytic_data <- cbind(categorical_variables, agreeableness, extroversion, affective_commitment)
analytic_data


# Save analytic_data as .RData and .CSV

save(analytic_data,file = "study1_analytic_data.RData")   # saving as .RData
write_csv(analytic_data,path = "study1_analytic_data.csv")    # saving as a .CSV


# Save analytic_data as .SAV (SPSS)

library(haven)
write_sav(analytic_data,path = "study1_analytic_data.sav")
