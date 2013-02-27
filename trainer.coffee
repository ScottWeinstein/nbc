fs = require 'fs'
Trainer = require('./lib/nbc')

trainer = new Trainer('/tmp/nbc/trainDir')
td = trainer.trainDirectory()
fs.writeFileSync 'output/classifier_diag.json', JSON.stringify(td.diag, null, "  "), 'utf8'
fs.writeFileSync 'output/classifier.json', JSON.stringify(td.trainingData, null, "  "), 'utf8'
d = (new Date()).toISOString()
trainer.classifyDirectory(td.trainingData, '/tmp/nbc/logs', "/tmp/nbc/classifed-#{d}")
