% Finding the good stuff in log files with a Naive Bayesian Classifier
% Scott Weinstein



# Backstory
* Tens of thousands of individual log files
    * Not the ideal way to structure the data, but often we need to work with what we're given
* Most of which had irrelevant garbage
* Some had exception messages, indicating a bug in the code
* Some had error messages, indicating a poor user experience
* Sorting though the files by hand wasn't feasible

# Approaches
* A year ago I would have used some regular expressions to pick out text I thought was important
    * Boring
    * Error prone
    * Hard to maintain "now he has two problems"
* This time, armed with some machine learning theory I tried something else

# What's a Naive Bayesian Classifier?

## Let's look at each word
* **Classifier** - code that makes a prediction about data into a set of enumerated choices (as opposed to say a continuous value)
* **Bayesian** - probabilistic logic which takes advantage of Bayes' theorem
* **Naive** - academic speak for really simple - more on this later

# Where are these used?
* Most famously in spam detectors
* But useful in many document classification problems such as
    * Subject assignment
    * Authorship
    * Age determination
    * Sex determination


## Why this vs other approaches?
* Works surprisingly well
* Easy to understand
* Easy to code (no linear algebra)
* Fast run time


# Demo

# How does it work - theory 1
### Bayes theorem
$P(A | B) = \frac{P(A) \cdot   P(B | A)}{P(B)}$

### Applied to document classification
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

## Bringing it together we end up with $argmax_c P(C_c) \cdot \prod P(W_n|C_c)$


# Two things to fix before we're done 
## Unknown words
Words we haven't seen before will ruin the above formula. 
Count of the unknown word is 0 in the numerator, the whole thing is a product, and the document becomes unclassifiable

So we fix this via Laplace smoothing, by adding 1, and there are a number of ways to do this

## Floating point underflow
The product of small probabilities can hit machine precision quickly, to avoid we compute via logs

## The net formula we use is

$argmax_c \left \{  \ln(P(C_c)) + \sum \ln(P(W_n|C_c))  \right \}$
   
$argmax_c \left \{ \ln(\frac{num C_c}{num C}) + \sum \ln(\frac{num(W_n,C_c) + 1}{num(W,C_c) + \left | V \right |+1}) \right \}$

