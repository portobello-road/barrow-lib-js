module.exports = ( grunt ) ->

  ##
  # Aliases
  ##
  jsonFile = grunt.file.readJSON
  define = grunt.registerTask
  log = grunt.log.writeln

  ##
  # Configuration
  ##
  config =

    srcDir: 'src/'
    tstDir: 'test/'
    resDir: 'res/'
    docDir: 'docs/'
    srcFiles: ['<%= srcDir %>**/*.coffee', 'index.coffee']
    tstFiles: '<%= tstDir %>**/*.test.coffee'
    pkg: jsonFile 'package.json'

    ##
    # Tasks
    ##

    # grunt-contrib-watch
    watch:
      options:
        tasks: ['lint', 'test']
        interrupt: true
        atBegin: true
        dateFormat: ( time ) -> log "Done in #{time}ms"
      gruntfile:
        files: 'gruntfile.coffee'
        tasks: '<%= watch.options.tasks %>'
      project:
        files: ['<%= srcFiles %>', '<%= tstFiles %>']
        tasks: '<%= watch.options.tasks %>'

    # grunt-coffeelint
    coffeelint:
      options: jsonFile 'coffeelint.json'
      gruntfile: 'gruntfile.coffee'
      project: ['<%= srcFiles %>', '<%= tstFiles %>']

    mochacli:
      options:
        reporter: 'spec'
        require: ['should']
        compilers: ['coffee:coffee-script/register']
      project:
        src: ['<%= tstFiles %>']

    # grunt-codo: CoffeeScript API documentation generator
    codo:
      options:
        title: 'barrow-lib'
        debug: false
        inputs: ['<%= srcDir %>']
        output: '<%= docDir %>'

    # grunt-contrib-coffee
    coffee:
      build:
        expand: true
        ext: '.js'
        src: '<%= srcFiles %>'
        dest: '<%= libDir %>'

    # grunt-contrib-uglify
    uglify:
      build:
        files: [
          expand: true
          src: '<%= srcDir %>**/*.js'
        ]

    # grunt-contrib-clean
    clean:
      build: ['<%= srcDir %>**/*.js', 'index.js']
      docs: ['<%= docDir %>']

  ##
  # Grunt Modules
  ##

  require( 'load-grunt-tasks' )( grunt )

  define 'lint', ['coffeelint']
  define 'test', ['mochacli']
  define 'docs', ['codo']
  define 'build:dev', ['clean:build', 'lint', 'test', 'coffee:build', 'docs']
  define 'build', ['build:dev', 'uglify:build']
  define 'default', ['build']

  ##
  # Let it go
  ##
  grunt.initConfig config
