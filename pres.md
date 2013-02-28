% Finding the good stuff in log files with a Naive Bayesian Classifier
% Scott Weinstein



# Back story
* Tens of thousands of individual log files
    * Not the ideal way to structure the data, but often we need to work with what we're given
* Most of which had irrelevant garbage
* Some had exception messages, indicating a bug in the code
* Some had error messages, indicating a poor user experience
* Sorting though the files by hand wasn't feasible, at least not desirable

# Approaches
* Regular expressions to pick out text I thought was important
    * Boring
    * Error prone
    * Hard to maintain "now he has two problems"
* An ML approach, by choosing a few by hand and then letting the program classify the rest

# What's a _Naive Bayesian Classifier_?

## Let's look at each word
* **Classifier** - code that makes a prediction about data into a set of enumerated choices (as opposed to say a continuous value)
* **Bayesian** - probabilistic logic which takes advantage of Bayes' theorem
* **Naive** - academic speak for really simple - more on this later

# Where are these used?
* Most famously in spam detectors
* But useful in many document classification problems such as
    * Subject assignment
    * Authorship
    * Age or sex determination
    * sentiment

## Why this vs other approaches?
* Works surprisingly well
* Easy to understand
* Easy to code - no linear algebra or graph structures needed
* Fast run time


# Demo

# How does it work
### Bayes theorem

We'll take this as a given, describing how to compute a conditional probability
$P(A | B) = \frac{P(A) \cdot   P(B | A)}{P(B)}$

### Applied to document classification

Here we're setting up the basic structure of how we'll do classification
$P(class | document) = \frac{P(class) \cdot P(document | class)}{P(document)}$

### To classify a document we choose the _class_ which gives the highest probability
$Max\left \{  P(C_1 | D),  P(C_2 | D), \cdots  P(C_n | D) \right \}$
$=Max\left \{  \frac{P(C_1) \cdot P(D | C_1)}{P(D)},  \frac{P(C_2) \cdot P(D | C_2)}{P(D)}, \cdots  \frac{P(C_n) \cdot P(D | C_n)}{P(D)} \right \}$


### we can drop the denominator, as it's the same across each

$=Max\left \{  P(C_1) \cdot P(D | C_1) , \cdots P(C_n) \cdot P(D | C_n) \right \}$


And if $P(C_X)$ is just  $\frac{number \ docs \ of \ Class_n}{total \ number \ docs}$  it's clear what Bayes theorem gives us, the likelihood, $P(D|C_X)$ is proportional to the frequency of the class

# OK, that's great and all 

## but how do we figure out $P(D|C_X)$?
* We need to make some simplifying assumptions
    * That the order of words doesn't matter
    * Given a class, the probability of each word is independent
        * this is the naive part, in that it's obviously not true
        * but it makes the computation easy, and it works

# Computing $P(D|C_X)$
1. Given the simplifying assumptions, re-write as $P(W_1, W_2, \cdots, W_n| C_X)$
2. re-write as $P(W_1| C_X) \cdot P(W_2| C_X) \cdot P(W_n| C_X)$
3. And to compute $P(W_n| C_X)$ is again just the ratio 
4. the number times $W_n$ in $C_X$ over the total number of words in $C_X$ 

## we end up with $argmax_c P(C_c) \cdot \prod P(W_n|C_c)$


# Two things to fix before we're done 
## Unknown words
Words we haven't seen before will _ruin_ the above formula. 
The count of an unknown word will put a $0$ in the numerator. As the whole thing is a product, the probability for each class becomes $0$ and the document becomes unclassifiable

So we fix this via _Laplace smoothing_, by adding $1$ to all values

## Floating point underflow
The product of small probabilities can hit machine precision quickly, to avoid this we compute in 

## The net formula we use is

$argmax_c \left \{  \ln(P(C_c)) + \sum \ln(P(W_n|C_c))  \right \}$
   
$argmax_c \left \{ \ln(\frac{num C_c}{num C}) + \sum \ln(\frac{num(W_n,C_c) + 1}{num(W,C_c) + \left | V \right |+1}) \right \}$

# Questions?