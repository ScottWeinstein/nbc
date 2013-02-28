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
      stylus: 
        files: ['styles/*']
        tasks: 'stylus'
    shell:
      mkdir: 
        command: 'mkdir output'
      dzslides:
        command: "pandoc  --mathjax=#{mathjaxUrl} --css=lab49.css -t dzslides -s pres.md -o output/dzslides.html"
        options:
          stdout: true
          stderr: true
      # makeEquations:
      #   command: 'coffee makeEquations.coffee'
      #   options:
      #     stdout: true
      #     stderr: true
      groc:
        command: 'groc README.md lib/nbc.coffee'
    stylus:
      compile:
        # options:
          # paths: ["path/to/import", "another/to/import"]
          # urlfunc: "embedurl" # use embedurl('test.png') in our code to trigger Data URI embedding
          # use: [require("fluidity")] # use stylus plugin at compile time
          # #  @import 'foo', 'bar/moo', etc. into every .styl file
          # #  that is compiled. These might be findable based on values you gave
          # import: ["foo", "bar/moo"] #  to `paths`, or a plugin you added under `use`
        files:
          # "output/result.css": "path/to/source.styl" # 1:1 compile
          "output/lab49.css": ["styles/*.styl"] # compile and concat into single file


  
  for task in ['grunt-shell', 'grunt-contrib-watch', 'grunt-contrib-stylus']
    grunt.loadNpmTasks task

  # Default task(s).
  grunt.registerTask "default", ['shell', 'stylus']
