module.exports = (grunt) ->
  
  mathjaxUrl = 'http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_SVG'
  # Project configuration.
  grunt.initConfig
    watch:
      pres:
        files: ['pres.md']
        tasks: ['shell:mkdir', 'shell:slidy', 'shell:dzslides']
      eq:
        files: ['equations/*.eq']
        tasks: ['shell:makeEq']
      groc:
        files: ['lib/*.coffee', 'Readme.md']
        tasks: ['shell:groc']
    shell:
      mkdir: 
        command: 'mkdir output'
      slidy:
        command: "pandoc --mathjax=#{mathjaxUrl}  -t slidy -s pres.md -o output/slidy.html"
        options:
          stdout: true
          stderr: true
      dzslides:
        command: "pandoc --mathjax=#{mathjaxUrl} -t dzslides -s pres.md -o output/dzslides.html"
        options:
          stdout: true
          stderr: true
      makeEquations:
        command: 'coffee makeEquations.coffee'
        options:
          stdout: true
          stderr: true
      groc:
        command: 'groc README.md lib/nbc.coffee'



  
  for task in ['grunt-shell', 'grunt-contrib-watch']
    grunt.loadNpmTasks task

  # Default task(s).
  grunt.registerTask "default", ["shell"]
