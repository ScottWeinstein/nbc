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
    pkg: grunt.file.readJSON("package.json")
    # uglify:
    #   options:
    #     banner: "/*! <%= pkg.name %> <%= grunt.template.today(\"yyyy-mm-dd\") %> */\n"

    #   build:
    #     src: "src/<%= pkg.name %>.js"
    #     dest: "build/<%= pkg.name %>.min.js"
    shell:
      mkdir: 
        command: 'mkdir output'
      # s5:
      #   command: 'pandoc -t s5 -s pres.md -o output/s5.html' #--self-contained
      #   options:
      #     stdout: true
      #     stderr: true
      slidy:
        command: "pandoc --mathjax=#{mathjaxUrl}  -t slidy -s pres.md -o output/slidy.html"
        options:
          stdout: true
          stderr: true
      # slideous:
      #   command: 'pandoc -t slideous -s pres.md -o output/slideous.html'
      #   options:
      #     stdout: true
      #     stderr: true
      dzslides:
        command: "pandoc --mathjax=#{mathjaxUrl} -t dzslides -s pres.md -o output/dzslides.html"
        options:
          stdout: true
          stderr: true
      # beamer:
      #   command: 'pandoc -t beamer -s pres.md -o output/beamer.pdf'
      #   options:
      #     stdout: true
      #     stderr: true
      makeEquations:
          command: 'coffee makeEquations.coffee'
          options:
            stdout: true
            stderr: true


  
  for task in ['grunt-shell', 'grunt-contrib-watch']
    grunt.loadNpmTasks task

  # Default task(s).
  grunt.registerTask "default", ["shell"]
