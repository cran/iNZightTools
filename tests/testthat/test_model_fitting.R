test_that("Linear model formula are generated correctly", {
    expect_equal(
        fitModel("response", "x1", "d"),
        "lm(response ~ x1, data = d)"
    )

    expect_equal(
        fitModel("response", "x1 + x2", "d", method = "other"),
        "lm(response ~ x1 + x2, data = d, method = \"other\")"
    )
})

test_that("Family and link arguments are included", {
    expect_equal(
        fitModel("response", "x1", "d", family = "binomial"),
        "glm(response ~ x1, data = d, family = binomial)"
    )
    expect_equal(
        fitModel("response", "x1", "d", family = "binomial", link = "probit"),
        "glm(response ~ x1, data = d, family = binomial(link = \"probit\"))"
    )
})

test_that("Negative binomial regression works", {
    ## Basic NegBin model
    expect_equal(
        fitModel("response", "x1", "d", family = "negbin"),
        "MASS::glm.nb(response ~ x1, data = d)"
    )

    ## Link should be added if not log
    expect_equal(
        fitModel("response", "x1", "d", family = "negbin", link = "sqrt"),
        "MASS::glm.nb(response ~ x1, data = d, link = \"sqrt\")"
    )

    ## xargs come through
    expect_equal(
        fitModel("response", "x1", "d", family = "negbin", model = FALSE),
        "MASS::glm.nb(response ~ x1, data = d, model = FALSE)"
    )

    ## Survey designs currently unsupported
    expect_error(
        fitModel("response", "x1", "d", family = "negbin", design = "survey"),
        "not yet implemented for survey designs"
    )
})

test_that("Cox PH models are generated correctly", {
    expect_equal(
        fitModel("response", "x1", "d", family = "cox", surv_params = c("time", "event")),
        "survival::coxph(survival::Surv(time, event) ~ x1, data = d, model = TRUE)"
    )

    expect_equal(
        fitModel("response", "x1 + x2", "d", family = "cox", design = "survey", surv_params = c("time", "event")),
        "survey::svycoxph(survival::Surv(time, event) ~ x1 + x2, design = svy.design)"
    )
})

test_that("Experiment not supported yet", {
    expect_error(
        fitModel("Sepal.Length", "Species", "iris", design = "experiment"),
        "Experiments are not yet implemented. \n"
    )
})
