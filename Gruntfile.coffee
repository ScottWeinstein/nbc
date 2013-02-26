module.exports = (grunt) ->
  
  # Project configuration.
  grunt.initConfig
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
        command: 'pandoc -t slidy -s pres.md -o output/slidy.html'
        options:
          stdout: true
          stderr: true
      # slideous:
      #   command: 'pandoc -t slideous -s pres.md -o output/slideous.html'
      #   options:
      #     stdout: true
      #     stderr: true
      dzslides:
        command: 'pandoc -t dzslides -s pres.md -o output/dzslides.html'
        options:
          stdout: true
          stderr: true
      # beamer:
      #   command: 'pandoc -t beamer -s pres.md -o output/beamer.pdf'
      #   options:
      #     stdout: true
      #     stderr: true




  
  # Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks "grunt-shell"
  
  # Default task(s).
  grunt.registerTask "default", ["shell"]