#' Regles de controle par defaut
#'
#' Inclut notamment la coherence `end_date >= start_date`, deliberement
#' EXCLUE du validator de `mecore::me_metadata` (voir ARCHITECTURE.md
#' §2.4 : `me_metadata` est une classe de structure pure). C'est ici,
#' pas dans `mecore`, que cette coherence est verifiee.
#'
#' @return Liste de `me_check_rule`.
#' @export
default_rules <- function() {
  list(
    me_check_rule(
      name = "dates_coherentes",
      severity = "error",
      check_fn = function(project) {
        m <- project@metadata
        if (length(m@end_date) && length(m@start_date) && m@end_date < m@start_date) {
          return(sprintf(
            "end_date (%s) est anterieure a start_date (%s)",
            format(m@end_date), format(m@start_date)
          ))
        }
        NULL
      }
    ),
    me_check_rule(
      name = "indicateurs_labels_uniques",
      severity = "warning",
      check_fn = function(project) {
        labels <- vapply(project@indicators, function(i) i@label, character(1))
        doublons <- labels[duplicated(labels)]
        if (length(doublons) > 0) {
          return(sprintf("label(s) d'indicateur en double : %s", paste(unique(doublons), collapse = ", ")))
        }
        NULL
      }
    ),
    me_check_rule(
      name = "indicateurs_datasets_presents",
      severity = "error",
      check_fn = function(project) {
        noms_projet <- vapply(project@datasets, function(d) d@name, character(1))
        problemes <- character(0)
        for (ind in project@indicators) {
          for (d in ind@datasets) {
            if (!(d@name %in% noms_projet)) {
              problemes <- c(problemes, sprintf(
                "l'indicateur '%s' reference le dataset '%s', absent de project@datasets",
                ind@label, d@name
              ))
            }
          }
        }
        if (length(problemes) > 0) return(paste(problemes, collapse = " ; "))
        NULL
      }
    ),
    me_check_rule(
      name = "logframe_complet",
      severity = "warning",
      check_fn = function(project) {
        if (is.null(project@logframe)) return(NULL)
        tryCatch({
          mecore::me_validate(project@logframe)
          NULL
        }, error = function(e) conditionMessage(e))
      }
    )
  )
}

#' Executer un ensemble de regles sur un projet
#'
#' @param project Un `mecore::me_project`.
#' @param rules Liste de `me_check_rule` (par defaut : `default_rules()`).
#' @return Un `me_check_report`.
#' @export
run_checks <- function(project, rules = default_rules()) {
  if (!S7::S7_inherits(project, mecore::me_project)) {
    mecore::me_validation_error("`project` doit etre un mecore::me_project")
  }

  lignes <- lapply(rules, function(r) {
    msg <- r@check_fn(project)
    data.frame(
      rule = r@name, severity = r@severity,
      status = if (is.null(msg)) "OK" else "ECHEC",
      message = if (is.null(msg)) "" else msg,
      stringsAsFactors = FALSE
    )
  })

  me_check_report(project_name = project@name, results = do.call(rbind, lignes))
}
