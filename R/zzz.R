.onLoad = function(libname, pkgname) {
  old = options()
  new = function() {
    list(
      which.genes.datadir = system.file("extdata", package = "which.genes")
    )
  }
  toset = !(names(new()) %in% names(old))
  if (any(toset)) options(new()[toset])
  invisible()
}
