module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    less: 
      dev:
        options:
          paths: ['public/stylesheets/']
        files:
          'public/stylesheets/style.css': 'public/stylesheets/style.less'
    coffee:
      compileBack:
        files: [
          expand: true
          flatten: true
          cwd: 'routes/coffeescripts'
          src: ['*.coffee']
          dest: 'routes/'
          ext: '.js'
        ]
      compileFront:
        files: [
          expand: true
          flatten: true
          cwd: 'public/coffeescripts'
          src: ['*.coffee']
          dest: 'public/javascripts/'
          ext: '.js'
        ]

  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
