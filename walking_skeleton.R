library(mecore)
library(mecheck)
library(S7)

# --- Cas 1 : projet propre (toutes les regles doivent passer) ---
meta_ok <- me_metadata(
  project_name = "Projet propre", organization = "o", country = "c", donor = "d", manager = "m",
  start_date = as.Date("2026-01-01"), end_date = as.Date("2026-12-31"),
  version = "0.1", description = "d", objectives = "o", sdgs = character(0)
)
d1 <- me_dataset(name = "d1", data = data.frame(age = c(20, 22)), metadata = meta_ok)
ind1 <- me_indicator(label = "Age moyen", formula = ~ mean(age), datasets = list(d1), value = 21, unit = "annees")
p_ok <- me_project(name = "Projet propre", metadata = meta_ok, datasets = list(d1), indicators = list(ind1), logframe = NULL)

rapport_ok <- run_checks(p_ok)
stopifnot(!has_failures(rapport_ok))
cat("Cas 1 (projet propre) : OK -", me_describe(rapport_ok), "\n")
print(rapport_ok@results)

# --- Cas 2 : dates incoherentes ---
meta_bad_dates <- me_metadata(
  project_name = "Projet dates KO", organization = "o", country = "c", donor = "d", manager = "m",
  start_date = as.Date("2026-12-31"), end_date = as.Date("2026-01-01"),  # inversees
  version = "0.1", description = "d", objectives = "o", sdgs = character(0)
)
p_bad_dates <- me_project(name = "Projet dates KO", metadata = meta_bad_dates, datasets = list(), indicators = list(), logframe = NULL)
rapport_dates <- run_checks(p_bad_dates)
stopifnot(has_failures(rapport_dates))
ligne <- rapport_dates@results[rapport_dates@results$rule == "dates_coherentes", ]
stopifnot(ligne$status == "ECHEC")
cat("\nCas 2 (dates incoherentes) detecte : OK -", ligne$message, "\n")

# --- Cas 3 : labels d'indicateurs dupliques ---
ind_dup1 <- me_indicator(label = "Meme label", formula = ~ mean(age), datasets = list(d1), value = 1, unit = "u")
ind_dup2 <- me_indicator(label = "Meme label", formula = ~ sd(age), datasets = list(d1), value = 2, unit = "u")
p_dup <- me_project(name = "Projet doublons", metadata = meta_ok, datasets = list(d1), indicators = list(ind_dup1, ind_dup2), logframe = NULL)
rapport_dup <- run_checks(p_dup)
ligne_dup <- rapport_dup@results[rapport_dup@results$rule == "indicateurs_labels_uniques", ]
stopifnot(ligne_dup$status == "ECHEC")
cat("Cas 3 (labels dupliques) detecte : OK -", ligne_dup$message, "\n")

# --- Cas 4 : indicateur reference un dataset absent du projet ---
d_orphelin <- me_dataset(name = "dataset_absent", data = data.frame(x = 1), metadata = meta_ok)
ind_orphelin <- me_indicator(label = "Indicateur suspect", formula = ~x, datasets = list(d_orphelin), value = 1, unit = "u")
p_orphelin <- me_project(name = "Projet orphelin", metadata = meta_ok, datasets = list(d1), indicators = list(ind_orphelin), logframe = NULL)
rapport_orph <- run_checks(p_orphelin)
ligne_orph <- rapport_orph@results[rapport_orph@results$rule == "indicateurs_datasets_presents", ]
stopifnot(ligne_orph$status == "ECHEC")
cat("Cas 4 (dataset reference absent) detecte : OK -", ligne_orph$message, "\n")

cat("\nTOUS LES TESTS MECHECK PASSENT.\n")
