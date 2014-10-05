var gulp = require('gulp');
var browserSync = require('browser-sync');

gulp.task('default', function() {
  browserSync({
        server: {
            baseDir: "./"
        }
    });

  gulp.watch('./*.html', ['default', browserSync.reload]);
  gulp.watch('./*.pde', ['default', browserSync.reload]);
  gulp.watch('./*.css', ['default', browserSync.reload]);

  console.log("Local illusory running at http://localhost:3000");
});
