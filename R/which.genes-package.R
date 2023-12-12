#' Which Genes Are They? -- A tool to query gene information.
#' 
#' 'which.genes' is a tool for querying gene information by
#'   either gene symbols, aliases, or IDs.
#' 
#' Functions:
#' - `download_data()`
#' 
#' Classes:
#' 
#' S3 methods:
#' 
#' @importFrom data.table ":=" "%chin%" .GRP .SD data.table fread fwrite setcolorder setnames
#' @importFrom jsonlite fromJSON toJSON read_json write_json
#' @importFrom magrittr "%>%" "%T>%"
#' @importFrom stringr str_extract_all
#' 
#' @docType package
#' @keywords internal
"_PACKAGE"

# Make sure data.table knows we are using it
.datatable.aware = TRUE
