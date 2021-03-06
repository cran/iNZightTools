% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/standardize_var.R
\name{standardizeVars}
\alias{standardizeVars}
\title{Standardize the data of a numeric variable}
\usage{
standardizeVars(.data, vars, names = paste(sep = ".", vars, "std"))
}
\arguments{
\item{.data}{a dataframe with the columns to standardize}

\item{vars}{a character vector of the numeric variables in \code{.data}
to standardize}

\item{names}{names for the created variables}
}
\value{
the original dataframe containing new columns of the standardized
        variables with tidyverse code attached
}
\description{
Centre then divide by the standard error of the values in a numeric variable
}
\examples{
standardized <- standardizeVars(iris, var = c("Sepal.Width", "Petal.Width"))
cat(code(standardized))
head(standardized)

}
\seealso{
\code{\link{code}}
}
\author{
Owen Jin, Tom Elliott
}
