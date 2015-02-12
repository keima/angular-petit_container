gulp = require "gulp"
p = require("gulp-load-plugins")()
browserSync = require "browser-sync"
bowerFiles = require "main-bower-files"
runSequence = require 'run-sequence'
rimraf = require "rimraf"

config =
  dir: "./app/"
  index: "./app/index.html"
  js: "./app/js/**/*.js"
  css: "./app/css/**/*.css"
  dist: "./dist/"

gulp.task "inject", ->
  bower = gulp.src bowerFiles(), {read: false}
  source = gulp.src [config.js, config.css], {read: false}

  return gulp.src config.index
  .pipe p.inject bower, {name: 'bower', relative: true}
  .pipe p.inject source, {relative: true}
  .pipe gulp.dest config.dir

gulp.task "copy", ["copy-bower", "copy-json"]

gulp.task "copy-bower", ->
  return gulp.src config.dir + "bower_components/**"
  .pipe gulp.dest config.dist + "bower_components/"

gulp.task "copy-json", ->
  return gulp.src config.dir + "json/**"
  .pipe gulp.dest config.dist + "json/"

gulp.task "minify", ["minify-js", "minify-html"]

gulp.task "minify-js", ->
  # とはいいつつ今は何もしない
  return gulp.src config.js
  .pipe gulp.dest config.dist + "js/"

gulp.task "minify-html", ->
  # とは言いつつ（ｒｙ
  return gulp.src config.index
  .pipe gulp.dest config.dist

gulp.task "clean", (cb) ->
  rimraf(config.dist, cb);

gulp.task "build", (cb) -> runSequence(
  "clean", "inject", "minify", "copy",
  cb
)
