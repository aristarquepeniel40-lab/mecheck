helper_meta <- function(start = Sys.Date(), end = Sys.Date() + 1) {
  mecore::me_metadata(
    project_name = "p", organization = "o", country = "c", donor = "d", manager = "m",
    start_date = start, end_date = end,
    version = "0.1", description = "d", objectives = "o", sdgs = character(0)
  )
}

test_that("run_checks ne remonte aucun echec sur un projet propre", {
  meta <- helper_meta()
  d <- mecore::me_dataset(name = "d1", data = data.frame(age = c(20, 22)), metadata = meta)
  ind <- mecore::me_indicator(label = "Age moyen", formula = ~ mean(age), datasets = list(d), value = 21, unit = "annees")
  p <- mecore::me_project(name = "p", metadata = meta, datasets = list(d), indicators = list(ind), logframe = NULL)
  r <- run_checks(p)
  expect_false(has_failures(r))
})

test_that("la regle dates_coherentes detecte end_date < start_date", {
  meta <- helper_meta(start = as.Date("2026-12-31"), end = as.Date("2026-01-01"))
  p <- mecore::me_project(name = "p", metadata = meta, datasets = list(), indicators = list(), logframe = NULL)
  r <- run_checks(p)
  ligne <- r@results[r@results$rule == "dates_coherentes", ]
  expect_equal(ligne$status, "ECHEC")
})

test_that("la regle indicateurs_labels_uniques detecte un doublon", {
  meta <- helper_meta()
  d <- mecore::me_dataset(name = "d1", data = data.frame(age = c(20, 22)), metadata = meta)
  i1 <- mecore::me_indicator(label = "X", formula = ~ mean(age), datasets = list(d), value = 1, unit = "u")
  i2 <- mecore::me_indicator(label = "X", formula = ~ sd(age), datasets = list(d), value = 2, unit = "u")
  p <- mecore::me_project(name = "p", metadata = meta, datasets = list(d), indicators = list(i1, i2), logframe = NULL)
  r <- run_checks(p)
  ligne <- r@results[r@results$rule == "indicateurs_labels_uniques", ]
  expect_equal(ligne$status, "ECHEC")
})

test_that("la regle indicateurs_datasets_presents detecte une reference absente", {
  meta <- helper_meta()
  d_projet <- mecore::me_dataset(name = "d1", data = data.frame(age = c(20)), metadata = meta)
  d_absent <- mecore::me_dataset(name = "absent", data = data.frame(x = 1), metadata = meta)
  ind <- mecore::me_indicator(label = "X", formula = ~x, datasets = list(d_absent), value = 1, unit = "u")
  p <- mecore::me_project(name = "p", metadata = meta, datasets = list(d_projet), indicators = list(ind), logframe = NULL)
  r <- run_checks(p)
  ligne <- r@results[r@results$rule == "indicateurs_datasets_presents", ]
  expect_equal(ligne$status, "ECHEC")
})

test_that("has_failures retourne TRUE des qu'une regle echoue", {
  meta <- helper_meta(start = as.Date("2026-12-31"), end = as.Date("2026-01-01"))
  p <- mecore::me_project(name = "p", metadata = meta, datasets = list(), indicators = list(), logframe = NULL)
  r <- run_checks(p)
  expect_true(has_failures(r))
})

test_that("run_checks refuse un objet qui n'est pas un me_project", {
  expect_error(run_checks(list()), class = "me_validation_error")
})
