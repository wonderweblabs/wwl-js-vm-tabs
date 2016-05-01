gulp            = require('gulp')
browserifyInc   = require('browserify-incremental')
coffeeify       = require('coffeeify')
fs              = require('fs')
hamlify         = require('hamlify')
_               = require('lodash')
mkdirp          = require('mkdirp')
path            = require('path')
runSequence     = require('run-sequence').use(gulp)
source          = require('vinyl-source-stream')
buffer          = require('gulp-buffer')
hamlc           = require('gulp-haml-coffee')
notify          = require('gulp-notify')
rename          = require('gulp-rename')
rimraf          = require('gulp-rimraf')
sass            = require('gulp-sass')
sourcemaps      = require('gulp-sourcemaps')
util            = require('gulp-util')
vulcanize       = require('gulp-vulcanize')

# require cmi
cmi = require('cmi/gulp/tasks')(gulp, {
  notify:   gulp.env.notify || false
  destPath: 'bower_components'
  sassPath: [
    'bower_components',
    'bower_components/bourbon/app/assets/stylesheets',
    'bower_components/neat/app/assets/stylesheets',
    'node_modules/cmi/src/var',
    'css/var'
  ]
})

gulp.task 'build', (cb) ->
  runSequence(
    'clean',
    'cmi-build',
    'vulcanize-haml',
    'vulcanize',
    'sass',
    'coffee-ensure-cache-file',
    'coffee',
    cb
  )

gulp.task 'watch', ->
  gulp.start('build')

  gulp.watch [
    'lib/**/*.coffee',
    'lib/**/*.hamlc',
    'build/**/*.coffee',
    'build/**/*.hamlc'
  ], ['coffee']

  gulp.watch [
    'css/**/*.sass',
    'build/**/*.sass',
  ], ['sass']

gulp.task 'clean', ->
  gulp.src([
    'bower_components/app',
    'build/**/*.css',
    'build/**/*.js',
    'build/webcomponents.html',
    'tmp',
  ], { read: false })
  .pipe(rimraf())

# ------------------------------------------------------------------------------------
# vulcanize

gulp.task 'vulcanize-haml', ->
  stream = gulp.src('build/webcomponents.haml')
  stream = appendError(stream, "Vulcanize Error - Backend")
  stream = stream.pipe(hamlc({ js: false }))
  stream = stream.pipe(rename('webcomponents.html'))
  stream = stream.pipe(gulp.dest('bower_components/app'))
  stream = appendNotify(stream, "Haml", 'Done compiling')

gulp.task 'vulcanize', ->
  stream = gulp.src('bower_components/app/webcomponents.html')
  stream = appendError(stream, "Vulcanize Error - Browser")
  stream = stream.pipe(vulcanize({
    inlineScripts:  true
    inlineCss:      true
    stripComments:  false
    excludes:       []
    stripExcludes:  []
  }))
  stream = stream.pipe(rename('webcomponents.html'))
  stream = stream.pipe(gulp.dest('build'))
  stream = appendNotify(stream, "Vulcanize", 'Done compiling')

# ------------------------------------------------------------------------------------
# coffee

gulp.task 'coffee', (cb) ->
  runSequence(
    'coffee-nocmi',
    'coffee-cmi',
    cb
  )

gulp.task 'coffee-nocmi', ->
  stream = buildBrowserify(['build/index-nocmi.coffee'], {
    debug:      true
    extensions: [".coffee", ".js", ".json"]
    cacheFile:  'tmp/browserify.json'
    paths: [
      'node_modules',
      'bower_components'
    ]
  })
  stream = appendError(stream, 'Coffee Error')
  stream = stream.pipe(source('index-nocmi.js'))
  stream = stream.pipe(buffer())
  stream = stream.pipe(gulp.dest('build'))
  stream = appendNotify(stream, "Coffee", 'Done compiling')

gulp.task 'coffee-cmi', ->
  stream = buildBrowserify(['build/index-cmi.coffee'], {
    debug:      true
    extensions: [".coffee", ".js", ".json"]
    cacheFile:  'tmp/browserify.json'
    paths: [
      'node_modules',
      'bower_components'
    ]
  })
  stream = appendError(stream, 'Coffee Error')
  stream = stream.pipe(source('index-cmi.js'))
  stream = stream.pipe(buffer())
  stream = stream.pipe(gulp.dest('build'))
  stream = appendNotify(stream, "Coffee", 'Done compiling')

gulp.task 'coffee-ensure-cache-file', ->
  if _.isString('tmp/browserify.json')
    try
      fs.accessSync('tmp/browserify.json', fs.R_OK)
    catch e
      mkdirp.sync(path.dirname('tmp/browserify.json'), { mode: (0o755 & (~process.umask())) })
      fs.writeFileSync('tmp/browserify.json', JSON.stringify({
        modules: {}
        packages: {}
        mtimes: {}
        filesPackagePaths: {}
        dependentFiles: {}
      }, null, 2))

# ------------------------------------------------------------------------------------
# sass

gulp.task 'sass', (cb) ->
  runSequence(
    'sass-nocmi',
    'sass-cmi',
    cb
  )

gulp.task 'sass-nocmi', ->
  stream = gulp.src('build/index-nocmi.sass')
  stream = appendError(stream, "Sass Error")
  stream = stream.pipe(sourcemaps.init())
  stream = stream.pipe(sass({
    indentedSyntax:   true
    errLogToConsole:  true
    includePaths: [
      'css',
      'bower_components',
      'bower_components/bourbon/app/assets/stylesheets',
      'bower_components/neat/app/assets/stylesheets',
      'node_modules',
      'node_modules/cmi/src/var'
    ]
  }).on('error', sass.logError))
  stream = stream.pipe(sourcemaps.write())
  stream = stream.pipe(rename('index-nocmi.css'))
  stream = stream.pipe(gulp.dest('build'))
  stream = appendNotify(stream, "Sass", 'Done compiling')

gulp.task 'sass-cmi', ->
  stream = gulp.src('build/index-cmi.sass')
  stream = appendError(stream, "Sass Error")
  stream = stream.pipe(sourcemaps.init())
  stream = stream.pipe(sass({
    indentedSyntax:   true
    errLogToConsole:  true
    includePaths: [
      'css',
      'bower_components',
      'bower_components/bourbon/app/assets/stylesheets',
      'bower_components/neat/app/assets/stylesheets',
      'node_modules',
      'node_modules/cmi/src/var'
    ]
  }).on('error', sass.logError))
  stream = stream.pipe(sourcemaps.write())
  stream = stream.pipe(rename('index-cmi.css'))
  stream = stream.pipe(gulp.dest('build'))
  stream = appendNotify(stream, "Sass", 'Done compiling')


# ------------------------------------------------------------------------------------
# helper methods

appendError = (stream, title) ->
  stream.on 'error', (error) ->
    util.log.bind(util, "#{title} - #{error.toString()}")
    util.log(error)

    notify.onError({
      title:    title
      message:  error.toString()
    })(error)

    @emit('end')

appendNotify = (stream, title, message) ->
  stream.pipe(notify({
    title:    title
    message:  message
  }))

buildBrowserify = (files, config) ->
  stream = browserifyInc(files, _.extend(browserifyInc.args, config))
  stream = stream.transform(hamlify, { global: true })
  stream = stream.transform(coffeeify, {
    sourceMap:  true
    global:     true
  })
  stream.require('jquery',              { expose: 'jquery' } )
  stream.require('underscore',          { expose: 'underscore' } )
  stream.require('backbone',            { expose: 'backbone' } )
  stream.require('backbone.marionette', { expose: 'backbone.marionette' } )
  stream = appendError(stream, 'Curo Coffee Error')
  stream = stream.bundle()
  stream