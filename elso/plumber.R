#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
source('/home/mihaly/R_codes/plumber/stock_data.R')

#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.


#* example to csv output
#* @get /mtcars_to_csv
getIrisCsv <- function(req, res) {
  filename <- filename <- paste0(tempfile(),'.csv')
  write.csv(iris, filename, row.names = FALSE)
  include_file(filename, res, "text/csv")
}


#* example to csv stock
#* @get /stock_to_csv
getIrisCsv <- function(req, res) {
  filename <- filename <- paste0(tempfile(),'.csv')
  write.csv(get_stocks(), filename, row.names = FALSE)
  include_file(filename, res, "text/csv")
}



#* example to html output
#* @param n_bins number of bins
#* @get /html_example
getIrisCsv <- function(req, res, n_bins) {
  filename <- paste0(tempfile(),'.html')
  rmarkdown::render('report.Rmd', output_file = paste0(filename,'.html'),
                    params = list(n=n_bins),
                    envir = new.env(parent = globalenv())
  )
  include_file(paste0(filename,'.html'), res, "text/html")
}


