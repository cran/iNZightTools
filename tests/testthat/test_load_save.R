cas <- smart_read("cas500.csv")
not_a_df <- 1:10
rda <- file.path(tempdir(), "my_files.rda")
on.exit(unlink(rda))

save(cas, iris, not_a_df, file = rda)

test_that("Load returns list of data frames", {
    res <- load_rda(rda)
    expect_type(res, "list")
    expect_equal(names(res), c("cas", "iris"))
    expect_equal(res$iris, iris)
    expect_equal(res$cas, cas)
})

test_that("Load has valid code", {
    expect_equal(
        code(load_rda(rda)),
        sprintf("load('%s')", rda),
        ignore_attr = TRUE
    )
})

test_that("Save writes file with correct name", {
    fp <- chartr("\\", "/", file.path(tempdir(), "irisdata.rda"))
    on.exit(unlink(fp))
    x <- save_rda(iris, fp, "my_iris")
    expect_true(x)
    expect_equal(
        code(x),
        sprintf("save(my_iris, file = '%s')", fp),
        ignore_attr = TRUE
    )
    load(fp)
    expect_equal(my_iris, iris)
})
