##
##
##    Workshop #1: Navigating R
##
##    Objective:  Become familiar with how to navigate RStudio, use different types
##                of data objects (e.g. numbers, vectors, data tables), 
##                
##    Authors:    Calvin J. Munson
##
##    Date:       Feb. 10th-14th, 2020
##
##
##



# 1. How to write, run, and save code -------------------------------------
#
#

# This is your workspace! Here you can write code, comments, etc, and save it for later

# Comments are an excellent way to keep track of your work and record what you were thinking when writing that line of code. Describing your approach also helps other people to understand your thought process, helping replicate your results
# To record a comment, simply put a "#" before a line. This tells R that anything coming after this symbol is not code.

This is not how to record comments; R will think that this is a line of code! Note the error message that appears. Also note that a red x appears on the line, and the words get underlined in red. R is giving you a sign that something is wrong!

# To execute a line of code, you can either click the "Run" button in the top right, or "Command + Return" for Mac users (Control + Enter for PC)

# To add another, line simply press "Enter/Return"





# 2. How R handles various data types -------------------------------------
#
#


# * 2.1 Numbers! ----------------------------------------------------------


# I like to think of R as a calculator with a TON of features. For instance, what happens when you add two numbers together in your code? 

3 + 2

5 - 2

3*9

8/2

# You can execute many complex equations quite simply. Just like a graphing calculator

# Use parenthesis just as you would when performing mathematical equations

(3 + 19)/(3^2 + 2)

# Each open parenthesis must also have a closing parenthesis in order for the code to run!

# You can highlight and then click the run code or command + enter to run specific parts of an equation

sin((5^2 + 35)/6)




## A key concept in R is how to store data into "data objects". This can be accomplished using the "<-" or the "=" operators

x <- 5
x

x = 5
x

y <- 10

x + y
z <- x + y
z


# This can be particularly helpful if we have a value that occurs multiple times in our code

# Say we went on a road trip and wanted to calculate your average speed, as well as gas you used
# The trip took 15 hours, and you traveled 1000 miles. Your fancy electric car gets 80 miles to the gallon (mpg), and gas costs $3.00 per gallon

miles <- 1000
hours <- 15
mpg <- 80
cost_of_gas <- 3.00

# What was your average speed throughout the trip?
miles/hours
mph <- miles/hours

# You can use numbers to perform operations on objects that represent numbers too!
# Convert miles per hour to kilometers per hour
mph*1.6
# kilometers per second
mph*1.6/(60*60)

# How many gallons of gas did you consume?
miles/mpg
gallons <- miles/mpg

# How much will that trip cost you in terms of gas?
gallons*cost_of_gas

# How do these results (average speed, total gallons) change when you change the initial parameters?

# How much will you pay for gas if you instead take a truck that gets 20 mpg? 

# Easy-to-make error:
# What happens if you spell something wrong? Capitalize something accidentally?

Gallons
galons


# * 2.2 Characters! -------------------------------------------------------

# So those were numbers, but how do we deal with characters in R? This is particularly helpful when thinking about non-numeric data. For instance, if we want to understand how gas mileage changes with car manufacturer, then we have a mix of numbers (gas mileage) and characters (manufacturer). We'll get more into this sort of question later when we start working with data tables and data analysis.

# To designate something as characters, rather than as a data object, use ""

# This line of code outputs just the word "gallons":
"gallons"

# Whereas this line outputs what we stored earlier as a data object. Important distinction!
gallons

# Without the quotation marks, gallons is simply a placeholder for the value we assigned it earlier. With the quotation marks, it is read as a group of characters, even if you put numbers in it

2 + 2
"2" + 2



# * 2.3 Vectors -----------------------------------------------------------

# You can string together various data objects to create "vectors" of data. This is essentially a string of information that you can apply functions to
# This is accomplished using the c() function. Remember the commas!
# Here we introduce our first function too: length(), which tells you the length of a vector of numbers/characters

names <- c("Calvin", "Rancel", "Olivia", "Calvin")
names

length(names)
# In this case, our vector called "names" is the arguement to the function length(). All functions have arguements, which are the components that are required by the function in order to create output

# unique() tells us how many unique values are present - in this case, we have 4 total variables, but only 3 unique ones!
unique(names)


# We can also do math with vectors!
grades <- c(94, 92, 99, 89)
grades

# You can access every function's "Help" page in R! In a line of code, just type a ? or ?? before the function:
?mean()

mean(grades)
max(grades)
min(grades)
sum(grades)


# Things can be done multiple ways in R
# Let's say that you are keeping track of your expenses on groceries each week.
# Each number represents the money you spent at Publix for 5 consecutive weeks.
# What are TWO ways that you can calculate the average amount of money you've spent per week?

groceries <- c(40, 50, 90, 35, 63)

# 1.
mean(groceries)

# 2. 
total_groceries <- sum(groceries)
total_weeks <- length(groceries)

total_groceries/total_weeks




# 3. Packages and the "tidyverse" ----------------------------------

# As you can see, there are easier ways to do things, and there are more
# complicated ways to do things.
# R is totally open source, which means that anyone can contribute their 
# own code/software/functions within R. These bundles of code and functions
# are called "packages"
# One such popular suite of packages is known as the "tidyverse", led by Hadley Wickham
# Similar to how mean(x) is more efficient than sum(x)/length(x), packages within the tidyverse seek to make data analysis, data wrangling, and data visualization more "tidy". I will teach this set of workshops using the tidyverse, as it tends to be a much more intuitive way to learn coding.



# 4. So! Many! Error messages!!! ------------------------------------------
#
#

# Error messages are a constant companion in R - they will never go away!
# Common errors are forgetting to add commas, closed parenthesis, or quotation marks, and especially misspelling the names of variables or functions.
# The good news is that RStudio has an incredible online presence - if you've run into a problem with your code, chances are that someone else has too.
# StackOverflow, the CRAN website, and other websites host all sorts of questions/answers/discussions regarding R code.
# And if you want to do a specific thing in R (e.g. make a certain graph, run a certain analysis), googling it will almost always yield results and example code that you can modify to accomplish your goal!
# Just copy/paste your error messages into Google - it will help! 



