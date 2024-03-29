% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inzdf.R
\name{filter}
\alias{filter}
\alias{filter.inzdf_db}
\title{Filter}
\usage{
\method{filter}{inzdf_db}(.data, ..., table = NULL, .preserve = FALSE)
}
\arguments{
\item{.data}{A data frame, data frame extension (e.g. a tibble), or a
lazy data frame (e.g. from dbplyr or dtplyr). See \emph{Methods}, below, for
more details.}

\item{...}{<\code{\link[rlang:args_data_masking]{data-masking}}> Expressions that
return a logical value, and are defined in terms of the variables in
\code{.data}. If multiple expressions are included, they are combined with the
\code{&} operator. Only rows for which all conditions evaluate to \code{TRUE} are
kept.}

\item{table}{name of the table to use, defaults to first in list}

\item{.preserve}{ignored}
}
\description{
Filter

Filter inzdf
}
