describe <- mecore::describe

#' @noRd
S7::method(describe, me_check_report) <- function(x, ...) {
  n_echecs <- sum(x@results$status == "ECHEC")
  n_total <- nrow(x@results)
  if (n_echecs == 0) {
    sprintf("Controle qualite '%s' : %d/%d regles respectees. Aucun probleme detecte.",
            x@project_name, n_total, n_total)
  } else {
    sprintf("Controle qualite '%s' : %d/%d regles en echec.", x@project_name, n_echecs, n_total)
  }
}
