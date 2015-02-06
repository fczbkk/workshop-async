module.exports = (grunt) ->

  require('load-grunt-tasks') grunt

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    coffee:
      default:
        expand: true
        flatten: false
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'build'
        ext: '.js'

    watch:
      default:
        options:
          atBegin: true
        files: ['src/**/*.coffee']
        tasks: ['coffee']

    nodemon:
      default:
        script: 'build/server/index.js'
        watch: 'build/server'

    concurrent:
      default:
        tasks: ['nodemon', 'watch']
        options:
          logConcurrentOutput: true

    grunt.registerTask 'default', ['concurrent']
