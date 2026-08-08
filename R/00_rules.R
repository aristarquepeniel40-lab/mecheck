#' Regle de controle qualite
#'
#' Une regle est une fonction qui prend un `mecore::me_project` et
#' retourne `NULL` (regle respectee) ou un message `character` decrivant
#' le probleme. Contrairement a `mecore::me_validate()`, une regle
#' `mecheck` ne LEVE jamais d'erreur — elle produit un constat, pour
#' permettre un audit complet meme si plusieurs regles echouent a la fois.
#'
#' @param name Nom court de la regle (ex. "dates_coherentes").
#' @param check_fn Fonction `function(project) -> NULL | character(1)`.
#' @param severity `"error"` ou `"warning"` — indicatif seulement, n'a
#'   pas d'effet sur l'execution (voir `run_checks()`).
#' @export
me_check_rule <- S7::new_class(
  "me_check_rule",
  package = "mecheck",
  properties = list(
    name     = S7::class_character,
    check_fn = S7::class_function,
    severity = S7::class_character
  )
)

#' Rapport de controle qualite
#'
#' @param project_name Nom du projet controle.
#' @param results Un `data.frame` avec colonnes `rule`, `severity`,
#'   `status` (`"OK"` ou `"ECHEC"`), `message`.
#' @export
me_check_report <- S7::new_class(
  "me_check_report",
  package = "mecheck",
  properties = list(
    project_name = S7::class_character,
    results      = S7::class_data.frame
  )
)

#' Le rapport contient-il au moins un echec ?
#'
#' @param report Un `me_check_report`.
#' @return `TRUE`/`FALSE`.
#' @export
has_failures <- function(report) {
  stopifnot(S7::S7_inherits(report, me_check_report))
  any(report@results$status == "ECHEC")
}
