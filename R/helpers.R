#' Is numeric check
#'
#' This function checks if a variable is numeric,
#' or could be considered one.
#' For example, dates and times can be treated as numeric,
#' so return \code{TRUE}.
#'
#' @param x the variable to check
#' @return logical, \code{TRUE} if the variable is numeric
#' @author Tom Elliott
#' @export
is_num <- function(x) {
    vartype(x) %in% c("num", "dt")
}

#' Is factor check
#'
#' This function checks if a variable a factor.
#'
#' @param x the variable to check
#' @return logical, \code{TRUE} if the variable is a factor
#' @author Tom Elliott
#' @export
is_cat <- function(x) {
    vartype(x) == "cat"
}

#' Is datetime check
#'
#' This function checks if a variable a date/time/datetime
#'
#' @param x the variable to check
#' @return logical, \code{TRUE} if the variable is a datetime
#' @author Tom Elliott
#' @export
is_dt <- function(x) {
    vartype(x) == "dt"
}

#' Get variable type name
#'
#' @param x vector to be examined
#' @return character vector of the variable's type
#' @author Tom Elliott
#' @export
vartype <- function(x) {
    if (inherits(x, "POSIXct") ||
        inherits(x, "yearweek") ||
        inherits(x, "yearmonth") ||
        inherits(x, "yearquarter") ||
        inherits(x, "Date") ||
        inherits(x, "times") ||
        inherits(x, "hms")) {
        return("dt")
    }

    if (is.numeric(x)) "num" else "cat"
}

#' Get all variable types from data object
#' @param x data object (data.frame or inzdf)
#' @return a named vector of variable types
#' @export
vartypes <- function(x) UseMethod("vartypes")

#' @export
vartypes.default <- function(x) stop("Unsupported data object.")

#' @export
vartypes.data.frame <- function(x) sapply(x, vartype)

#' @export
vartypes.tbl_lazy <- function(x) sapply(dplyr::collect(head(x)), vartype)

#' @export
vartypes.inzdf_db <- function(x) {
    if (!is.null(attr(x, "vartypes", exact = TRUE))) {
        return(attr(x, "vartypes", exact = TRUE))
    }

    sapply(head(x), vartype)
}


#' Check if object is a survey object (either standard or replicate design)
#'
#' @param x object to be tested
#' @return logical
#' @author Tom Elliott
#' @export
is_survey <- function(x) {
    is_svydesign(x) || is_svyrep(x)
}

#' Check if object is a survey object (created by svydesign())
#'
#' @param x object to be tested
#' @return logical
#' @author Tom Elliott
#' @export
is_svydesign <- function(x) {
    inherits(x, "survey.design")
}

#' Check if object is a replicate survey object (created by svrepdesign())
#'
#' @param x object to be tested
#' @return logical
#' @author Tom Elliott
#' @export
is_svyrep <- function(x) {
    inherits(x, "svyrep.design")
}


#' Add suffix to string
#'
#' When creating new variables or modifying the data set, we often
#' add a suffix added to distinguish the new name from the original one.
#' However, if the same action is performed twice (for example, filtering a data set),
#' the suffix is duplicated (data.filtered.filtered). This function averts this
#' by adding the suffix if it doesn't exist, and otherwise appending
#' a counter (data.filtered2).
#'
#' @param name a character vector containing (original) names
#' @param suffix the suffix to add, a length-one character vector
#' @return character vector of names with suffix appended
#' @examples
#' add_suffix("data", "filtered")
#' add_suffix(c("data.filtered", "data.filtered.reshaped"), "filtered")
#' @export
add_suffix <- function(name, suffix) {
    if (length(suffix) > 1) {
        warning("More than one suffix specified, using only the first.")
    }
    suffix <- suffix[1]

    new_name <- sapply(
        name,
        function(x) {
            if (grepl(suffix, x, fixed = TRUE)) {
                # counter (numbers after suffix)
                expr <- paste0("\\.", suffix, "[0-9]*")
                rgx <- regexpr(expr, x)
                rgn <- gsub(
                    paste0(".", suffix), "",
                    substr(x, rgx, rgx + attr(rgx, "match.length") - 1)
                )
                count <- max(1, as.integer(rgn), na.rm = TRUE) + 1
                gsub(expr, sprintf(".%s%d", suffix, count), x)
            } else {
                sprintf("%s.%s", x, suffix)
            }
        }
    )
    unname(new_name)
}

#' Make unique variable names
#'
#' Helper function to create new variable names that are unique
#' given a set of existing names (in a data set, for example).
#' If a variable name already exists, a number will be appended.
#'
#' @param new a vector of proposed new variable names
#' @param existing a vector of existing variable names
#' @return a vector of unique variable names
#' @author Tom Elliott
#' @examples
#' make_names(c("var_x", "var_y"), c("var_x", "var_z"))
#'
#' @export
make_names <- function(new, existing = character()) {
    names <- character(length(new))
    for (v in seq_along(new)) {
        if (new[v] %in% existing) {
            i <- 1
            while (paste0(new[v], i) %in% existing) i <- i + 1
            vv <- paste0(new[v], i)
        } else {
            vv <- new[v]
        }
        existing <- c(existing, vv)
        names[v] <- vv
    }
    names
}

orNULL <- function(x, y = x) {
    if (is.null(x)) NULL else y
}

#' Anti value matching
#' @rdname operator_not_in
#' @name Not In operator
#' @param x vector of values to be matched
#' @param table vector of values to match against
#' @return A logical vector of same length as 'x', indicating if each
#'         element does **not** exist in the table.
#' @export
#' @md
`%notin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

#' NULL or operator
#' @rdname operator_or_null
#' @name Or NULL operator
#' @param a an object, potentially NULL
#' @param b an object
#' @return a if a is not NULL, otherwise b
#' @export
`%||%` <- function(a, b) {
    if (is.null(a)) b else a
}


eval_code <- function(expr, env = parent.frame(2)) {
    pipe <- getOption("inzighttools.pipe", "baseR")
    expr_deparsed <- dplyr::case_when(
        pipe %in% c("dplyr", "%>%", "magrittr") ~ rlang::expr_deparse(expr),
        TRUE ~ stringr::str_replace_all(rlang::expr_deparse(expr), "%>%", "|>")
    )
    try(rlang::eval_tidy(expr, env = env)) |>
        structure(code = expr_deparsed)
}


coerce_tbl_svy <- function(expr, data) {
    if (!inherits(data, "tbl_svy")) {
        rlang::expr(!!expr %>% srvyr::as_survey())
    } else {
        expr
    }
}


check_eval <- function(x) {
    stopifnot(!is.null(attributes(x)$code))
    testthat::expect_equal(rlang::eval_tidy(
        rlang::parse_expr(paste(code(x), collapse = "\n")),
        env = parent.frame(1)
    ), x, ignore_attr = TRUE)
}


parse_datetime_order <- function(x) {
    y <- strsplit(x, "\\s+")[[1]]
    if (length(y) == 1) {
        return(x)
    }
    dplyr::case_when(
        grepl("minute", y, TRUE) ~ "M",
        grepl("(am.?pm)|(pm.?am)", y, TRUE) ~ "p",
        TRUE ~ tolower(substr(y, 1, 1))
    ) |> paste(collapse = "")
}
