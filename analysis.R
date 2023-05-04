---
title: "Untitled"
output: html_document
date: "2023-05-04"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r}

df_windows = read.csv("./csv_files/windows_data.csv")


head(df_windows)


```

```{r}

df_mac = read.csv("./csv_files/mac_data.csv")

head(df_mac)

```

```{r}

#TODO: Setting up a new column called Row, where we'll introduce the notion of Keyword word "similarity", look at the Python code, for now this is sorta part 2 of R conversion so it's unnecessary.
df_mac$Row = 0
df_windows$Row = 0

df_mac
df_windows

```

```{r}
library(tidyverse)

# get rid of all the values between 60 and 99 

df_mac_slice <- df_mac[2:3]


# this isn't a good way of doing it, but get the total key strokes from the key_count and divide each row to see how much it represents our data for "likelihood"


tots <- sum(df_mac_slice$Keycount)

df_mac_slice$Keycount <- (df_mac_slice$Keycount / tots)*100


df_mac_slice$Keycount <- round(df_mac_slice$Keycount, 2)



df_mac_sliced <- df_mac_slice[order(-df_mac_slice$Keycount),][0:10, ]

p<-ggplot(data=df_mac_sliced, aes(x=Keyname, y=Keycount)) +  geom_bar(stat="identity")

p
```

```{r}
# Get a slice of the data frame
df_windows_slice <- df_windows[2:3]

# Filter out values between 60 and 99
df_windows_slice <- df_windows_slice[!(df_windows_slice$Keycount >= 60 & df_windows_slice$Keycount <= 99), ]

# Normalize key count values
tots <- sum(df_windows_slice$Keycount)
df_windows_slice$Keycount <- (df_windows_slice$Keycount / tots) * 100
df_windows_slice$Keycount <- round(df_windows_slice$Keycount, 2)

# Select top 10 keys by key count
df_windows_sliced <- df_windows_slice[order(-df_windows_slice$Keycount), ][1:10, ]

# Create the plot
p <- ggplot(data = df_windows_sliced, aes(x = Keyname, y = Keycount)) + geom_bar(stat = "identity")
p
```

```{r}
df_mac_sliced
df_windows_sliced
```

```{r}
# Merge the two data frames into one
df_both <- rbind(transform(df_mac_sliced, OS = "Mac"), transform(df_windows_sliced, OS = "Windows"))

# Create the stacked bar plot
p <- ggplot(data = df_both, aes(x = Keyname, y = Keycount, fill = OS)) +
  geom_bar(stat = "identity", position = "stack") + coord_flip() +
  labs(x = "Key Name", y = "Key Count", fill = "Operating System") +
  ggtitle("Comparison of Key Usage between Mac and Windows") +
  theme(plot.title = element_text(hjust = 0.5))
p
```
