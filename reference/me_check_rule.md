# Regle de controle qualite

Une regle est une fonction qui prend un
[`mecore::me_project`](https://rdrr.io/pkg/mecore/man/me_project.html)
et retourne `NULL` (regle respectee) ou un message `character` decrivant
le probleme. Contrairement a
[`mecore::me_validate()`](https://rdrr.io/pkg/mecore/man/me_validate.html),
une regle `mecheck` ne LEVE jamais d'erreur — elle produit un constat,
pour permettre un audit complet meme si plusieurs regles echouent a la
fois.

## Usage

``` r
me_check_rule(
  name = character(0),
  check_fn = function() NULL,
  severity = character(0)
)
```

## Arguments

- name:

  Nom court de la regle (ex. "dates_coherentes").

- check_fn:

  Fonction `function(project) -> NULL | character(1)`.

- severity:

  `"error"` ou `"warning"` — indicatif seulement, n'a pas d'effet sur
  l'execution (voir
  [`run_checks()`](https://aristarquepeniel40-lab.github.io/mecheck/reference/run_checks.md)).
