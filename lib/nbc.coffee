# <script src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_SVG" type="text/javascript"></script>
fs = require 'fs'
mkdirp = require('mkdirp')
colors = require('colors')
BayesianClassifierCore = require('./BayesianClassifierCore')

class BayesianClassifier extends BayesianClassifierCore
    constructor: (@trainingDir) ->

    # #Training
    # Iterate through each dir==Class, and each file in each dir counting docs and words per class
    trainDirectory: (trainingDir=@trainingDir) ->
        trainingData = @getEmptyTrainingData()

        files = fs.readdirSync trainingDir
        for file in files when file isnt '.DS_Store'
            sfiles = fs.readdirSync "#{trainingDir}/#{file}"
            for docFile in sfiles when docFile isnt '.DS_Store'
                @trainDocument trainingData, file, getFilteredWordFromDoc("#{trainingDir}/#{file}/#{docFile}")

        ret =
            trainingData: @simplifyTrainingData(trainingData)
            diag: trainingData

        allWordCount = @sumValues trainingData.docCounts
        console.log("Trained #{allWordCount} documents".green)
        return ret


    # remove empty and words which are just numbers
    filterWord = (word) ->
        return false if word is ''
        return false if word.match /^-?\d+$/
        true

    getFilteredWordFromDoc = (docPath) ->
        text = fs.readFileSync docPath, 'utf8'
        text.split(/\s|<|>|,|\. |=/).filter filterWord


    # #Classification
    classifyDirectory: (classiferData, testDir, resultsDir) ->
        files = fs.readdirSync testDir
        console.log("Classifing #{files.length} documents".yellow)
        summary = {}        
        for file in files when file isnt '.DS_Store'
            srcFile = "#{testDir}/#{file}"
            klass = @.classifyDocument classiferData, getFilteredWordFromDoc(srcFile)
            summary[klass] = 1 + if summary[klass]? then summary[klass] else 0 
            destDir = "#{resultsDir}/#{klass}"
            mkdirp.sync destDir
            fs.symlinkSync(srcFile, "#{destDir}/#{file}")
        for k, cnt of summary   
            console.log("#{cnt} #{k}".green)


module.exports = BayesianClassifier
