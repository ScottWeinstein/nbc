fs = require 'fs'
Trainer = require('./lib/nbc')

trainer = new Trainer('/tmp/nbc/trainDir')
trainingData = trainer.trainDirectory()
fs.writeFileSync 'output/classifier.json', JSON.stringify(trainingData, null, "  "), 'utf8'
d = (new Date()).toISOString()
trainer.classifyDirectory(trainingData, '/tmp/nbc/logs', "/tmp/nbc/classifed-#{d}")
