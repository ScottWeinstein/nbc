fs = require 'fs'
_ = require 'underscore'

class BaysianTrainer
    constructor: (@trainingDir) ->

    filterWord = (word) ->
        return false if word is ''
        return false if word.match /^-?\d+$/
        true


    getFilteredWordFromDoc = (docPath) ->
        text = fs.readFileSync docPath, 'utf8'
        text.split(/\s|<|>|,|\. |=/).filter filterWord


    trainDocument = (td, klass, docPath) ->
        td.docCounts[klass]++
        kw = td.classWords[klass]
        for word in getFilteredWordFromDoc docPath 
            td.wordCounts[word] = 0 if !td.wordCounts[word]?
            kw[word] = 0 if !kw[word]?

            td.wordCounts[word]++
            kw[word]++


    sum = (l) -> l.reduce ((a,b) -> a+b), 0


    getClassificationProb = (classiferData, klass, words) ->
        kw = classiferData.classWords[klass]
        logVocab = Math.log(sum(_.values(kw)) + classiferData.numberOfWords)
        partials = for w in words
            cnt = if kw[w]? then kw[w] else 0
            Math.log(cnt + 1) - logVocab  
        likely = @sum partials
        # return    
        klass: klass
        logprob: (likely + classiferData.priors[klass].logprob)
        prob: Math.exp(likely + classiferData.priors[klass].logprob)
    

    classifyDocument = (classiferData, docPath) ->
        words = getFilteredWordFromDoc docPath
        probs = (getClassificationProb classiferData, klass, words for klass in _.keys(classiferData.docCounts))
        console.log probs
        l = probs.reduce ((memo,item) -> if item.logprob > memo.logprob then item else memo), logprob:-Number.MAX_VALUE
        l.class

    trainDirectory: (trainingDir=@trainingDir) ->
        trainingData = 
            docCounts:  {}
            wordCounts: {}
            classWords: {}
            priors:     {}

        files = fs.readdirSync trainingDir
        for file in files
            trainingData.docCounts[file] = 0 
            trainingData.classWords[file] = {}
        for file in files
            sfiles = fs.readdirSync "#{trainingDir}/#{file}"
            for docFile in sfiles
                trainDocument trainingData, file, "#{trainingDir}/#{file}/#{docFile}"

        allWordCount = sum _.values(trainingData.docCounts)
        for klass, count of trainingData.classWords
            trainingData.priors[klass] = 
                prob: trainingData.docCounts[klass] / allWordCount
                logprob: Math.log(trainingData.docCounts[klass]) - Math.log(allWordCount)

        #console.log trainingData.priors
        trainingData.numberOfWords = _.keys(trainingData.wordCounts).length
        return trainingData


    classifyDirectory = (classiferData, testDir) ->
        files = fs.readdirSync testDir
        for file in files
            klass = classifyDocument classiferData, "#{testDir}/#{file}"
            console.log "mv #{testDir}/#{file} #{testDir}/#{klass}/#{file}"

module.exports = BaysianTrainer

# classiferData = trainData trainingDir
# classifyDirectory classiferData, evalDir
