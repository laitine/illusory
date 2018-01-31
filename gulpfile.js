var gulp = require('gulp');
var browserSync = require('browser-sync');
var csso = require('gulp-csso');

gulp.task('default', ['build'], function() {
  browserSync({
        server: {
            baseDir: "./dist"
        }
    });

  gulp.watch('./src/img/*.png', ['img', browserSync.reload]);
  gulp.watch('./src/*.html', ['html', browserSync.reload]);
  gulp.watch('./src/js/*.pde', ['js', browserSync.reload]);
  gulp.watch('./src/css/*.css', ['css', browserSync.reload]);

  console.log("Local illusory running at http://localhost:3000");
});

gulp.task('processingjs', function() {
  return gulp.src('./node_modules/processing-js/processing.min.js')
    .pipe(gulp.dest('./dist'));
});

gulp.task('js', ['processingjs'], function() {
  return gulp.src('./src/js/*.pde')
    .pipe(gulp.dest('./dist'));
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
    .pipe(gulp.dest('./dist'));
});

gulp.task('build', ['js', 'css', 'html', 'img']);
