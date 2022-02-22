library('ggvis')
library('tidyverse')
library('ggplot2')


bike_buyers = read.csv('/Users/boluogunle/Downloads/bike_buyers.csv', header=T, na.strings='')
head(bike_buyers)


class(bike_buyers)


str(bike_buyers)

summary(bike_buyers)

levels(bike_buyers$Gender)

?levels

bike_buyers$Marital.Status <- as.factor(bike_buyers$Marital.Status)
bike_buyers$Gender <- as.factor(bike_buyers$Gender)
bike_buyers$Home.Owner <- as.factor(bike_buyers$Home.Owner)
bike_buyers$Purchased.Bike <- as.factor(bike_buyers$Purchased.Bike)


str(bike_buyers)


colSums(is.na(bike_buyers))


summary(bike_buyers)


hist(bike_buyers$Income)

hist(bike_buyers$Children, breaks = 20)


hist(bike_buyers$Cars, breaks = 15)

hist(bike_buyers$Age)
# Dealing with NA values
# Since the distribution of Income and Age is left-skewed. I will impute the median values

median(na.omit((bike_buyers$Income)))
median(na.omit((bike_buyers$Age)))

bike_buyers_clean <- bike_buyers
colSums(is.na(bike_buyers_clean))

# Income replaced with Median
bike_buyers_clean$Income[is.na(bike_buyers_clean$Income)] <- 
  median(na.omit((bike_buyers$Income)))

bike_buyers_clean$Age[is.na(bike_buyers_clean$Age)] <- 
  median(na.omit((bike_buyers$Age)))

colSums(is.na(bike_buyers_clean))

# A function which calculates the maximum frequency of unique values in every column.
get_mode <- function(x) {                 
  unique_x <- unique(x)
  tabulate_x <- tabulate(match(x, unique_x))
  unique_x[tabulate_x == max(tabulate_x)]
}

# Marital Status replaced with Mode
bike_buyers_clean$Marital.Status[is.na(bike_buyers_clean$Marital.Status)] <- 
  get_mode(bike_buyers$Marital.Status)


# Gender replaced with Mode
bike_buyers_clean$Gender[is.na(bike_buyers_clean$Gender)] <- 
  get_mode(bike_buyers$Gender)

# Children replaced with Mode
bike_buyers_clean$Children[is.na(bike_buyers_clean$Children)] <- 
  get_mode(bike_buyers$Children)

# Home Owner replaced with Mode
bike_buyers_clean$Home.Owner[is.na(bike_buyers_clean$Home.Owner)] <- 
  get_mode(bike_buyers$Home.Owner)

colSums(is.na(bike_buyers_clean))


# Cars replaced with Mean
bike_buyers_clean$Cars[is.na(bike_buyers_clean$Cars)] <- 
  mean(bike_buyers$Cars, na.rm = TRUE)

write.csv(bike_buyers_clean,"bike_buyers_clean.csv", quote = FALSE, row.names = TRUE)

bike_buyers <- bike_buyers_clean

counts1 <- table(bike_buyers$Cars, bike_buyers$Gender)
barplot(counts1, main = '',
        xlab="Number of Cars",
        legend = rownames(counts1))

counts2 <- table(bike_buyers$Children, bike_buyers$Purchased.Bike)
barplot(counts2, main = '',
        xlab="Purchased Bike",
        legend = rownames(counts2))

counts3 <- table(bike_buyers$Occupation, bike_buyers$Purchased.Bike)
barplot(counts3, main = '',
        xlab="Purchased bike based on Occupation",
        legend = rownames(counts3))

plot(bike_buyers$Income, type= "p")
plot(bike_buyers$Children, type= "p")
plot(bike_buyers$Cars, type= "p")



ggplot(bike_buyers, aes(x = Age)) +
  geom_histogram()

ggplot(bike_buyers, aes(x = Children)) +
  geom_histogram()

plot(density(bike_buyers$Income), main='Income Density Spread')


ggplot(bike_buyers,
       aes(y = Age, x = Gender)) +
  geom_point()


ggplot(bike_buyers,
       aes(y = Age, x = Income)) +
  geom_point()

plot(density(bike_buyers$Age), main='Age Density Spread')
plot(density(bike_buyers$Income), main='Income Density Spread')
plot(density(bike_buyers$Cars), main='Cars Density Spread')


ggplot(bike_buyers,
       aes(y = Age, x = Education)) +
  geom_point()

ggplot(bike_buyers,
       aes(y = Income, x = Education)) +
  geom_point()

ggplot(bike_buyers,
       aes(y = Income, x = Age)) +
  geom_point()

ggplot(bike_buyers,
       aes(y = Income, x = Cars)) +
  geom_point()



p3 <- ggplot(bike_buyers,
             aes(x = Age,
                 y = Income)) + 
  theme(legend.position="top",
        axis.text=element_text(size = 6))
p4 <- p3 + geom_point(aes(color = Age),
                      alpha = 0.5,
                      size = 1.5,
                      position = position_jitter(width = 0.25, height = 0))
p4 +
  scale_x_discrete(name="Income") +
  scale_color_continuous(name="", low = "blue", high = "red")

# Trend Plot
p5 <- ggplot(bike_buyers, aes(x = Age, y = Occupation))
p5 + geom_line(aes(color = Age))

p6 <- ggplot(bike_buyers, aes(x = Age, y = Purchased.Bike))
p6 + geom_line(aes(color = Age))


(p5 <- p5 + geom_line() +
    facet_wrap(~Purchased.Bike, ncol = 10))

(p6 <- p6 + geom_line() +
    facet_wrap(~Children, ncol = 10))

(p5 <- p5 + geom_line() +
    facet_wrap(~Gender, ncol = 10))

boxplot(bike_buyers$Income, main = 'Income Boxplot')


boxplot(bike_buyers$Age, main = 'Age Boxplot')

# For multiple boxplots
boxplot(bike_buyers[,c(1,4)], main='Multiple Box plots')

OutVals = boxplot(bike_buyers$Income)$out
print(OutVals)

OutVals2 = boxplot(bike_buyers$Age)$out
print(OutVals2)

which(bike_buyers$Income %in% OutVals)

x = bike_buyers$Income [!(bike_buyers$Income %in% OutVals) ]
boxplot(x)















