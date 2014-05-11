gulp = require('gulp')
shell = require('gulp-shell')
browserify = require('gulp-browserify')
rename = require('gulp-rename')
coffee = require('gulp-coffee')
uglify = require('gulp-uglify')
handlebars = require('gulp-compile-handlebars')

paths =
  buildScripts: './scripts/app.js'

# JavaScript Tasks
gulp.task 'build-html', ->
  gulp.src('./src/**/*.html')
      .pipe(gulp.dest('./dist/'))

  # gulp.src('./src/**/*.hbs')
  #     .pipe(handlebars(paths))
  #     .pipe(rename({extname: '.html'}))
  #     .pipe(gulp.dest('./dist/'))

gulp.task 'build-scripts', ->
  gulp.src('src/scripts/app.coffee', { read: false })
      .pipe browserify
        transform: ['coffeeify']
        extensions: ['.coffee']
      .pipe(rename('app.js'))
      .pipe(gulp.dest('./dist/scripts/'))
      .pipe(rename({suffix: '.min'}))
      .pipe(uglify())
      .pipe(gulp.dest('./dist/scripts/'))

# Test Tasks

gulp.task 'test-coffee2js', ->
  gulp.src('./spec/**/*.coffee')
      .pipe(coffee({bare: true}))
      .pipe(gulp.dest('./spec/'))

gulp.task 'unit-tests', shell.task('testem ci')

gulp.task 'ci', ['test-coffee2js', 'unit-tests']

# General Tasks

gulp.task 'watch', ->
  gulp.watch './spec/**/*.coffee', ['test-coffee2js']
  gulp.watch './src/**/*.coffee', ['build-scripts']

gulp.task 'default', ['build-scripts'], ->
  console.log "finished"
