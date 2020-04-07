# author: Qi Yang
# date: 2020-03-16

"This script knits the final report to .pdf and .html.

Usage: knit.R --rmd_path=<rmd_path>
" -> doc

# Load library
library(docopt)

# Main command
opt <- docopt(doc)

main <- function(rmd_path) {
  rmarkdown::render(rmd_path,
                    c("html_document", "pdf_document"))
  print("The final report is knitted to .html and .pdf documents in the same docs folder as .Rmd.")
}

#' @param rmd_path is the path to the .rmd file of the final report. 
#' The knitted html and pdf will also be in the same folder as the .Rmd file.
#' @example rmarkdown::render(docs/finalreport.Rmd, c("html_document", "pdf_document"))

main(opt$rmd_path)