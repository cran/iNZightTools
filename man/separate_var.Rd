% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/separate_var.R
\name{separate_var}
\alias{separate_var}
\title{Separate columns}
\usage{
separate_var(data, var, by, names, into = c("cols", "rows"))
}
\arguments{
\item{data}{dataset}

\item{var}{name of variable to be separated}

\item{by}{a string as delimiter between values (separate by delimiter) or
integer(s) as number of characters to split by (separate by position),
the length of \code{by} should be \code{1} unless \code{by} is integer
and \code{into = "cols"}; if \code{by} is a non-integer numeric vector
its values will be rounded down to the nearest integer}

\item{names}{for \code{into = "cols"}, a character vector of output column
names; use \code{NA} if there are components that you don't want to
appear in the output; the number of non-\code{NA} elements determines
the number of new columns in the result}

\item{into}{whether to split into new rows or columns}
}
\value{
Separated dataset
}
\description{
Separate columns
}
\author{
Zhaoming Su
}
