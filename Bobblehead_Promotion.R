#' ---	
#' title: "Bobblehead_Promotion"	
#' author: "Godfred Somua-Gyimah"	
#' date: "March 18, 2017"	
#' output: html_document	
#' ---	
#' 	
#' 	
knitr::opts_chunk$set(echo = TRUE)	
#' 	
#' 	
#' # # PROBLEM	
#' 	
#' The management of the Los Angeles Dodgers want to know if the sale of bobbleheads can help attract additional fans to the park. Using Major League Baseball data from the 2012 season, advise management on the following questions:	
#' 	
#' Questions: 	
#' (1) Do bobblehead promotions have a positive effect on attendance?	
#' (2) If they do, how big is this positive effect?	
#' (3) Will the increased revenues associated with tickets and concessions cover the fixed and variable costs of putting on the promotion?	
#' 	
#' 	
#' 	
#' The following R packages will be used: 	
#' 	
#' - dpyr: data transformation	
#' - lattice: plotting	
#' - stargazer: report format	
#' - car: regression	
#' - MASS: statistics	
#' 	
#' 	
#' \newpage	
#' 	
#' # 1. Read in Dataset	
#' 	
# Clean the environment	
rm(list = ls())	
# Read data file	
df <- read.csv("dodgers.csv")	
	
#' 	
#' 	
#' # 2. Undertand Data	
#' 	
#' 	
# Show head	
head(df)	
	
#' 	
#' 	
# Show the structure of the data frame	
str(df)	
	
#' 	
#' 	
#' 	
# Show summary statistics	
summary(df)	
	
#' 	
#' 	
#' # 3. Exploratory Data Analysis	
#' 	
#' ## 3.1. Attendance by Day of Week	
#' 	
#' We want to draw a box plot of attendance grouped by the day of week.	
#' 	
#' First, we define an ordered day-of-week variable by recoding the day_of_week column.	
#' 	
#' 	
# Define an ordered day-of-week variable for plots and data summaries	
df$ordered_day_of_week[df$day_of_week == 'Monday'] <- 1	
df$ordered_day_of_week[df$day_of_week == 'Tuesday'] <- 2	
df$ordered_day_of_week[df$day_of_week == 'Wednesday'] <- 3	
df$ordered_day_of_week[df$day_of_week == 'Thursday'] <- 4	
df$ordered_day_of_week[df$day_of_week == 'Friday'] <- 5	
df$ordered_day_of_week[df$day_of_week == 'Saturday'] <- 6	
df$ordered_day_of_week[df$day_of_week == 'Sunday'] <- 7	
	
#' 	
#' 	
#' Then, we transform the ordered day-of-week variable as factor.	
#' 	
df$ordered_day_of_week <- factor(df$ordered_day_of_week, levels=1:7,	
labels=c("Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"))	
	
#' 	
#' 	
#' Showing the head of the updated data frame.	
#' 	
#' 	
head(df)	
#' 	
#' 	
#' Now, drawing the box plot.	
#' 	
#' 	
# Box plot of attendance by day of week	
plot(df$ordered_day_of_week, df$attend/1000,	
     xlab = "Day of Week",	
     ylab = "Attendance (thousands)",	
     col = "violet")	
#' 	
#' 	
#' 	
# Frequency table of bobblehead promotions by day of week	
table(df$bobblehead,df$ordered_day_of_week)	
	
#' 	
#' 	
#' From the frequency table, we find that most bobblehead promotions occured on Tuesdays.	
#' 	
#' ## 3.2. Attendance by Month	
#' 	
#' Similarly, we can visualize attendance by month.	
#' 	
#' First, we need an ordered month variable for plots and data summaries. Of course, we can use the similar code in section 3.1. However, R provides many options to do the same task. Now, let's use the recode function in dplyr package to create the ordered month variable.	
#' 	
#' 	
# Define an ordered month variable for plots and data summaries	
	
df$ordered_month <- dplyr::recode(as.character(df$month), 	
                                  APR=4, MAY=5, JUN=6, JUL=7, AUG=8, SEP=9, OCT=10)	
	
	
df$ordered_month <- factor(df$ordered_month, levels=4:10,	
labels = c("April", "May", "June", "July", "Aug", "Sept", "Oct"))	
#' 	
#' 	
#' 	
head(df)	
#' 	
#' 	
#' 	
# Box plot of attendance by by month 	
plot(df$ordered_month,df$attend/1000,	
     xlab = "Month", 	
     ylab = "Attendance (thousands)",	
     col = "light blue")	
	
#' 	
#' 	
#' ## 3.3. Plot the Relationship between Attendance and Weather	
#' 	
#' 	
#' 	
# Load the lattice library for plotting	
library(lattice)	
	
# Draw the scatter plot (lattice) of attendance vs. temperature conditioning on day/night and skies.	
xyplot(attend/1000 ~ temp | skies + day_night,	
       data = df, groups = fireworks,	
       pch = c(21,24),aspect = 1, cex = 1.2,	
       col = c("black","black"), fill = c("black","red"),	
       layout = c(2, 2), type = c("p","g"),	
       strip=strip.custom(strip.levels=TRUE,strip.names=FALSE, style=1),	
       xlab = "Temperature (Degrees Fahrenheit)",	
       ylab = "Attendance (thousands)",	
       key = list(space = "right",	
                  text = list(c("Fireworks","No Fireworks"),	
                              col = c("black","black")),	
                  points = list(pch = c(24,21),	
                                col = c("black","black"),	
                                fill = c("red","black"))))	
	
#' 	
#' 	
#' ## 3.4. Plot Attendance by Visiting Team	
#' 	
#' 	
# Draw the plot of attendance vs. visiting team	
	
bwplot(opponent ~ attend/1000, data = df, groups = day_night,	
       xlab = "Attendance (thousands)",	
       panel = function(x, y, groups, subscripts, ...){	
         panel.grid(h = (length(levels(df$opponent)) - 1), v = -1)	
         panel.stripplot(x, y, groups = groups, 	
                         subscripts = subscripts, 	
                         cex = c(2,2.75),	
                         pch = c(1,20),	
                         col = "darkblue")	
         },	
       key = list(space = "top", 	
                  text = list(c("Day","Night"),col = "black"),	
                  points = list(pch = c(1,20),	
                                cex = c(2,2.75), 	
                                col = "darkblue")))	
	
#' 	
#' 	
#' # 4. Regression Analysis	
#' 	
#' ## 4.1. Fit a Linear Regression Model	
#' 	
# Specify a simple model with bobblehead entered last	
my.model <- {attend ~ bobblehead + ordered_month + ordered_day_of_week}	
	
# Fit the linear regression model	
my.model.fit <- lm(my.model, data = df)	
	
# Show the summary of the fitted model	
summary(my.model.fit)	
	
#' 	
#' Therefore, it appears that bobbleheads have a high and positive effecton attendance. 	
#' 	
#' 	
#' Using the stargazer package to explore this further: 	
#' 	
#' 	
# install.packages("stargazer") #Install stargazer package, do this only once	
library(stargazer)	
stargazer(my.model.fit, type = "text", star.cutoffs = c(0.05, 0.01, 0.001),	
          title="Multiple Linear Regression", digits=3)	
#' 	
#' 	
#' 	
#' 	
#' 	
#' The above regression result already shows that bobblehead promotion has significant effect on attendance.	
#' 	
#' Another way to do the hypothesis is to do the anova test.	
#' 	
#' 	
# tests statistical significance of the bobblehead promotion	
# type I anova computes sums of squares for sequential tests	
anova(my.model.fit)	
#' 	
#' 	
#' 	
	
cat("\n","Estimated Effect of Bobblehead Promotion on Attendance: ",	
round(my.model.fit$coefficients[length(my.model.fit$coefficients)],	
digits = 0),"\n",sep="")	
	
#' 	
#' 	
#' ## 4.2. Regression Diagnostic	
#' 	
#' To assess the validity of the regression model, we do the following diagnostic procedures.	
#' 	
#' ### 4.2.1. Linearity Check	
#' 	
#' Since all predictors are categorical variables (factors), we don't need to check linearity. Linearity check makes sense only when both independent and dependent variables are ratio data.	
#' 	
#' ### 4.2.2. Homoscedasticity Check	
#' 	
#' 	
library(car)	
# non-constant error variance test	
ncvTest(my.model.fit)	
#' 	
#' We can reject the null hypothesis that the errors have a non-constant variance (p < 0.05).	
#' 	
#' 	
# plot studentized residuals 	
residualPlots(my.model.fit)	
	
#' 	
#' 	
#' ### 4.2.3. Normality Check	
#' 	
#' One of the assumptions of linear regression analysis is that the residuals are normally distributed. It is important to meet this assumption for the p-values for the t-tests to be valid.	
#' 	
#' 	
# Normality of Residuals	
# qq plot for studentized resid	
qqPlot(my.model.fit, main="QQ Plot")	
#' 	
#' 	
#' 	
# distribution of studentized residuals	
library(MASS)	
sresid <- studres(my.model.fit) 	
hist(sresid, freq=FALSE,main="Distribution of Studentized Residuals")	
xfit<-seq(min(sresid),max(sresid),length=40) 	
yfit<-dnorm(xfit) 	
lines(xfit, yfit)	
#' 	
#' 	
#' Both the above Q-Q plot and histogram look normal. Based on these graphs, the residuals from this regression model appear to conform to the normality assumption. 	
#' 	
#' ### 4.2.4. Multi-collinearity Check	
#' 	
vif(my.model.fit) # variance inflation factors	
#' 	
#' 	
#' As a general rule of thumb: the smaller VIF the better. VIF > 5 would have serious multi-collinearity problem.	
