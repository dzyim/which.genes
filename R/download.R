#' @include utils.R
#' 
NULL

HGNC_GENE_INFO = 'https://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/json/hgnc_complete_set.json'
NCBI_GENE_INFO = 'https://ftp.ncbi.nlm.nih.gov/gene/DATA/GENE_INFO/Mammalia/Homo_sapiens.gene_info.gz'
ENSEMBL_BIOMART = '\'http://www.ensembl.org/biomart/martservice?query=<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE Query><Query virtualSchemaName = "default" formatter = "TSV" header = "0" uniqueRows = "0" count = "" datasetConfigVersion = "0.6" ><Dataset name = "hsapiens_gene_ensembl" interface = "default" ><Attribute name = "ensembl_gene_id" /><Attribute name = "external_gene_name" /><Attribute name = "chromosome_name" /><Attribute name = "band" /><Attribute name = "entrezgene_id" /><Attribute name = "hgnc_id" /><Attribute name = "hgnc_symbol" /></Dataset></Query>\''

HGNC_FILE = 'hgnc_complete_set.json.gz'
NCBI_FILE = 'Homo_sapiens.gene_info.gz'
ENSEMBL_FILE = 'ensembl.biomart.txt.gz'

#' Download gene information from HGNC, NCBI, and/or Ensembl.
#'
#' @param dir (a length-1 character vector)
#'   Directory to save the downloaded (default: path/to/extdata/)
#' @param type (a length-1 character vector)
#'   Which data to download: "hgnc", "ncbi", "ensembl", or "all" (default: "all")
#' @param force (a length-1 logical vector)
#'   Whether to overwrite the existing data (default: FALSE)
#' @return An (invisible) integer code, ‘0’ for success and
#'   non-zero for failure.
#'
#' @export
#'
download_data = function(dir, type = c("all", "hgnc", "ncbi", "ensembl"), force = FALSE) {
  type = match.arg(type)
  # old = options(timeout = 600)
  # on.exit(options(old), add = TRUE)
  switch(type,
         all = {
           download_hgnc(dir, force)
           download_ncbi(dir, force)
           download_ensembl(dir, force)
         },
         hgnc = download_hgnc(dir, force),
         ncbi = download_ncbi(dir, force),
         ensembl = download_ensembl(dir, force),
         stop(sprintf('Invalid type: "%s"', type)))
}

#' Download gene information from HGNC.
#' 
#' @param dir (a length-1 character vector) 
#'   Directory to save the downloaded (default: path/to/extdata/)
#' @param force (a length-1 logical vector) 
#'   Whether to overwrite the existing data (default: FALSE)
#' @return An (invisible) integer code, ‘0’ for success and 
#'   non-zero for failure.
#' 
download_hgnc = function(dir, force = FALSE) {
  if (missing(dir)) dir = getOption("which.genes.datadir")
  destfile = file.path(dir, HGNC_FILE)
  
  if (force || !file.exists(destfile)) {
    dest = sub("\\.[[:alnum:]]+$", "", destfile)
    status = download_file(HGNC_GENE_INFO, dest)
    if (status == 0L) {
      status = system2("gzip", c("-f", dest))
    }
    if (status == 0L) {
      logfile = file.path(dir, "history")
      write_tsv(file.info(destfile), logfile, append = TRUE)
    }
    invisible(status)
  } else {
    message("[INFO] Found local hgnc info.")
    invisible(0L)
  }
}

#' Download gene information from NCBI.
#' 
#' @param dir (a length-1 character vector) 
#'   Directory to save the downloaded (default: path/to/extdata/)
#' @param force (a length-1 logical vector) 
#'   Whether to overwrite the existing data (default: FALSE)
#' @return An (invisible) integer code, ‘0’ for success and 
#'   non-zero for failure.
#' 
download_ncbi = function(dir, force = FALSE) {
  if (missing(dir)) dir = getOption("which.genes.datadir")
  destfile = file.path(dir, NCBI_FILE)
  
  if (force || !file.exists(destfile)) {
    status = download_file(NCBI_GENE_INFO, destfile)
    if (status == 0L) {
      logfile = file.path(dir, "history")
      write_tsv(file.info(destfile), logfile, append = TRUE)
    }
    invisible(status)
  } else {
    message("[INFO] Found local ncbi info.")
    invisible(0L)
  }
}

#' Download gene information from Ensembl BioMart.
#' 
#' @param dir (a length-1 character vector) 
#'   Directory to save the downloaded (default: path/to/extdata/)
#' @param force (a length-1 logical vector) 
#'   Whether to overwrite the existing data (default: FALSE)
#' @return An (invisible) integer code, ‘0’ for success and 
#'   non-zero for failure.
#' 
download_ensembl = function(dir, force = FALSE) {
  if (missing(dir)) dir = getOption("which.genes.datadir")
  destfile = file.path(dir, ENSEMBL_FILE)
  
  if (force || !file.exists(destfile)) {
    dest = sub("\\.[[:alnum:]]+$", "", destfile)
    status = download_file(ENSEMBL_BIOMART, dest)
    if (status == 0L) {
      status = system2("sed", c("-i", "'1i gene_id\tgene_name\tchr\tband\tentrez_id\thgnc_id\thgnc_symbol'", dest))
      if (status == 0L) {
        status = system2("gzip", c("-f", dest))
      }
    }
    if (status == 0L) {
      logfile = file.path(dir, "history")
      write_tsv(file.info(destfile), logfile, append = TRUE)
    }
    invisible(status)
  } else {
    message("[INFO] Found local ensembl info.")
    invisible(0L)
  }
}
