chai = require('chai')
chai.should()

describe "NBC", () ->
    nbc = require('./lib/BayesianClassifierCore')
    describe "classification", () ->
        trainer = new nbc()
    
        trainingData = trainer.getEmptyTrainingData()

        it 'Must train documents', () ->
            trainer.trainDocument trainingData, 'osx', "OS X Mountain Lion makes the Mac even better. And with so many new features, now the Mac works even better with iPhone, iPad, and iPod touch.".split(' ')
            trainer.trainDocument trainingData, 'osx', "Many people are going to hate Apple’s decision to turn the way scrolling works on its head, but here at Cult of Mac, we not only love it… we think it’s the future. But it’ll take some getting used to. Here’s our primer on how to start training yourself to use Lion’s “reverse scrolling” right now, today, under".split(' ')
            trainer.trainDocument trainingData, 'osx', "Reverse Scrolling” is actually truer to the Macintosh OS desktop metaphor created by Apple back in the early 80s.".split(' ')
            trainer.trainDocument trainingData, 'win', "Windows RT (codenamed Windows on ARM) is a special Microsoft Windows operating system designed to run on mobile devices utilizing the ARM architecture, such as tablets. Unlike Windows 8, Windows RT is only distributed as a pre-loaded operating system on devices produced by participating OEMs. Windows RT officially launched alongside Windows 8 on October 26, 2012 with the release of several Windows RT-powered tablets by various manufacturers, along with an RT version of Surface, the first device capable of running Windows manufactured and sold directly by Microsoft".split(' ')
            trainingData = trainer.simplifyTrainingData trainingData

            trainingData.priors.should.deep.equal 
                osx: -0.2876820724517808
                win: -1.3862943611198906

                trainingData.unknownWord.should.deep.equal
                    osx: -5.493061443340548
                    win: -5.420534999272286

                trainingData.likelihood.osx.Mountain.should.equal -4.799914262780603
                trainingData.likelihood.win["OEMs."].should.equal -4.727387818712341


        it 'Must compute P(D|C)', () ->
            res = trainer.getClassificationProb trainingData, 'osx', 'steve jobs made osx awesome'.split(' ')
            res.should.deep.equal 
                class: 'osx'
                logprob: -27.75298928915452

            res = trainer.getClassificationProb trainingData, 'win', 'steve jobs made osx awesome'.split(' ')
            res.should.deep.equal 
                class: 'win'
                logprob: -28.48896935748132


        it 'Must compute P(C|D)', () ->
            res = trainer.classifyDocument trainingData, 'steve jobs made osx awesome'.split(' ')
            res.should.equal 'osx'
        