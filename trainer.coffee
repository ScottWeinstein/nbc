fs = require 'fs'
Trainer = require('./lib/nbc')

trainer = new Trainer('/tmp/nbc/trainDir')
trainingData = trainer.trainDirectory()
fs.writeFileSync 'output/classifier.json', JSON.stringify(trainingData), 'utf8'

console.log(trainingData)
