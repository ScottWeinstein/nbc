module.exports = (grunt) ->
  
  mathjaxUrl = 'http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_SVG'
  # Project configuration.
  grunt.initConfig
    watch:
      pres:
        files: ['pres.md']
        tasks: ['shell:dzslides']
      eq:
        files: ['equations/*.eq']
        tasks: ['shell:makeEq']
      groc:
        files: ['lib/*.coffee', 'Readme.md']
        tasks: ['shell:groc']
      stylus: 
        files: ['styles/*']
        tasks: 'stylus'
    shell:
      mkdir: 
        command: 'mkdir output'
      dzslides:
        command: "pandoc  --mathjax=#{mathjaxUrl} --css=lab49.css -t dzslides -s pres.md -o output/dzslides.html"
      makeEquations:
        command: 'coffee makeEquations.coffee'
      groc:
        command: 'groc README.md lib/nbc.coffee'
    stylus:
      compile:
        options:
          urlfunc: "url" # use embedurl('test.png') in our code to trigger Data URI embedding
        files:
          "output/lab49.css": ["styles/*.styl"] # compile and concat into single file


  
  for task in ['grunt-shell', 'grunt-contrib-watch', 'grunt-contrib-stylus']
    grunt.loadNpmTasks task

  grunt.registerTask "default", ['shell', 'stylus']
