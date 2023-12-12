download_file = function(url, dest) {
  system2("wget", c("-t", "0", url, "-O", dest))
}

write_tsv = function(d.f, file, append = FALSE, row.names = TRUE) {
  utils::write.table(d.f, file, append = append, quote = FALSE, sep = "\t", row.names = row.names, col.names = NA) %>%
    suppressWarnings()
}
