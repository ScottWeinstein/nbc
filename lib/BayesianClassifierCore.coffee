# <script src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_SVG" type="text/javascript"></script>

class BayesianClassifierCore
    # #Training
    getEmptyTrainingData: () ->
        docCounts:  {}
        wordCounts: {}
        classWords: {}
        priors:     {}


    # During training we collect more info than we need, this will discard the unneeded data and
    # pre-compute the laplace smoothed logliklihood of each word per Class
    simplifyTrainingData: (trainingData) ->
        allWordCount = @sumValues trainingData.docCounts

        # Figure out P(C)
        for klass, count of trainingData.classWords
            trainingData.priors[klass] = 
                prob: trainingData.docCounts[klass] / allWordCount
                logprob: Math.log(trainingData.docCounts[klass]) - Math.log(allWordCount)

        trainingData.numberOfWords = (1 for key, ign of trainingData.wordCounts).length

        td = 
            priors: {}
            likelihood: {}
            unknownWord: {}

        for key, val of trainingData.priors
            td.priors[key] = val.logprob

        # compute P(D|C)
        for k, kw of trainingData.classWords
            td.likelihood[k] = {}
            # The formula we're computing is
            # <p><span class="math">\( \ln(\frac{num(W_n,C_c) + 1}{num(W,C_c) + \left | V \right |+1}) \)</span></p>
            denom = Math.log(@sumValues(kw) + trainingData.numberOfWords + 1)
            for word, count of kw
                td.likelihood[k][word] = Math.log(count + 1) - denom

            td.unknownWord[k] = 0-denom
        td

    # for each word, count it's occurrence in it's Class, `klass`, and in the entire dictionary
    trainDocument: (td, klass, words) ->
        if !td.docCounts[klass]?
            td.docCounts[klass] = 0 
            td.classWords[klass] = {}

        td.docCounts[klass]++
        kw = td.classWords[klass]
        for word in words
            td.wordCounts[word] = 0 if !td.wordCounts[word]?
            kw[word] = 0 if !kw[word]?

            td.wordCounts[word]++
            kw[word]++


    # #Classification
    # Get the words for a doc
    # compute the `P(C|D)`
    # get the Class which has the greatest `P(C|D)`
    classifyDocument: (classiferData, words) ->
        probs = (@getClassificationProb(classiferData, klass, words) for klass, ign of classiferData.priors)
        l = probs.reduce ((memo,item) -> if item.logprob > memo.logprob then item else memo), logprob:-Number.MAX_VALUE
        l.class


    # For a Document, `words`, and a Class, `klass` compute the following
    # <p><span class="math">\(\ln(P(C_{klass})) + \sum \ln(P(Words_n|C_{klass}))\)</span></p>
    # though note that the actual individual probabilities have been computed, and this is mostly a lookup task
    getClassificationProb: (classiferData, klass, words) ->
        ll = classiferData.likelihood[klass]
        getLikelihood = (w) -> if ll[w]? then ll[w] else classiferData.unknownWord[klass]
        likelihood = @sum(getLikelihood(w) for w in words)
        "class": klass
        logprob: (classiferData.priors[klass] + likelihood)

    # utils
    sum: (l) -> l.reduce ((a,b) -> a+b), 0
    sumValues: (o) ->
        s = 0
        s += val for key, val of o
        s

module.exports = BayesianClassifierCore
