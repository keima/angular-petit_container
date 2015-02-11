gulp = require "gulp"
p = require("gulp-load-plugins")()
browserSync = require "browser-sync"
bowerFiles = require "main-bower-files"

config =
  dir: "./app/"
  index: "./app/index.html"
  js: "./app/js/**/*.js"
  css: "./app/css/**/*.css"

gulp.task "inject", ->
  bower = gulp.src bowerFiles(), {read: false}
  source = gulp.src [config.js, config.css], {read: false}

  gulp.src config.index
  .pipe p.inject bower, {name: 'bower', relative: true}
  .pipe p.inject source, {relative: true}
  .pipe gulp.dest config.dir
