module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    cssmin:
      buildMain:
        src: 'public/stylesheets/style.css'
        dest: 'public/stylesheets/style.min.css'
    less:
      compile:
        options:
          paths: ['public/stylesheets/']
        files:
          'public/stylesheets/style.css': 'public/stylesheets/style.less'
          'public/stylesheets/vendors/bootstrap.css': 'bower_components/bootstrap/less/bootstrap.less'
          'public/stylesheets/vendors/ionicons.css': 'bower_components/ionicons/less/ionicons.less'
          'public/stylesheets/vendors/reset.css': 'bower_components/reset-css/reset.less'
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
          src: ['*.js']
          dest: 'public/javascripts/'
          ext: '.min.js'
        ]
    watch:
      less:
        files: 'public/stylesheets/*.less'
        tasks: ['less']
      cssmin:
        files: 'public/stylesheets/style.css'
        tasks: ['cssmin']
      coffee:
        files: ['public/coffeescripts/*.coffee', 'routes/coffeescripts/*.coffee']
        tasks: ['coffee']
      concat:
        files: 'public/javscripts/*.js'
        tasks: ['concat']
      uglify:
        files: 'public/javscripts/*.js'
        tasks: ['uglify']

  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['less', 'cssmin', 'coffee', 'concat', 'uglify']
