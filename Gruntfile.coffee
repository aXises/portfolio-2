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
    concat:
      build:
        dist:
          src: ['public/javascripts/*.js']
    uglify:
      build:
        files: [
          expand: true
          cwd: 'public/javascripts'
          src: ['*.js', '!*min.js']
          dest: 'public/javascripts/'
          rename: (dest, src) ->
            return dest + '/' + src.replace '.js', '.min.js'
        ]
    watch:
      coffee:
        files: ['public/coffeescripts/*.coffee', 'routes/coffeescripts/*.coffee']
        tasks: ['default']

  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['coffee', 'concat', 'uglify']
  grunt.registerTask 'heroku', ['coffee', 'concat', 'uglify']