metaFun <- function(type, name, fun, labels = NULL) {
    if (!is.character(type) || length(type) != 1) {
        stop("type must be a character string of length 1")
    }
    if (!is.character(name) || length(name) != 1) {
        stop("name must be a character string of length 1")
    }
    if (!is.function(fun)) {
        stop("fun should be, well, a function ...")
    }

    ## check for renaming: x=y (x is a function of y)
    if (grepl(".+=.+", name)) {
        rename <- strsplit(name, "=")[[1]]
        name <- rename[1]
        rename <- rename[2]
    } else {
        rename <- NULL
    }

    structure(
        list(
            type = type,
            name = name,
            rename = rename,
            fun = fun,
            labels = labels
        ),
        class = "inzmetafun"
    )
}

## Accessors:
getname <- function(x, original = TRUE) {
    name <- if (original && rename(x)) {
        x$rename
    } else {
        x$name
    }
}

rename <- function(x) !is.null(x$rename)

getrename <- function(x) x$rename

gettype <- function(x, abbr = FALSE) {
    if (abbr) {
        return(
            switch(x$type,
                "integer" = "i",
                "numeric" = "n",
                "factor" = "c",
                "multi" = "c"
            )
        )
    }
    x$type
}
