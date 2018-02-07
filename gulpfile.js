var gulp = require('gulp');
var browserSync = require('browser-sync');
var csso = require('gulp-csso');
var uglify = require('gulp-uglify');
var pump = require('pump');
var imagemin = require('gulp-imagemin');

gulp.task('default', ['build'], function() {
  browserSync({
        server: {
            baseDir: "./dist"
        }
    });

  gulp.watch('./src/img/*.png', ['img', browserSync.reload]);
  gulp.watch('./src/*.html', ['html', browserSync.reload]);
  gulp.watch('./src/js/*.js', ['js', browserSync.reload]);
  gulp.watch('./src/css/*.css', ['css', browserSync.reload]);

  console.log("Local illusory running at http://localhost:3000");
});

gulp.task('js:vendor', function() {
  return gulp.src('./node_modules/p5/lib/p5.min.js')
    .pipe(gulp.dest('./dist'));
});

gulp.task('js', ['js:vendor'], function(cb) {
  pump([
    gulp.src('./src/js/*.js'),
    uglify(),
    gulp.dest('./dist'),
  ], cb);
});

gulp.task('css', function() {
  return gulp.src('./src/css/*.css')
    .pipe(csso())
    .pipe(gulp.dest('./dist'));
});

gulp.task('html', function() {
  return gulp.src('./src/*.html')
    .pipe(gulp.dest('./dist'));
});

gulp.task('img', function() {
  return gulp.src('./src/img/*.png')
    .pipe(imagemin())
    .pipe(gulp.dest('./dist'));
});

gulp.task('build', ['js', 'css', 'html', 'img']);
