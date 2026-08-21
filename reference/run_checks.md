# Executer un ensemble de regles sur un projet

Executer un ensemble de regles sur un projet

## Usage

``` r
run_checks(project, rules = default_rules())
```

## Arguments

- project:

  Un
  [`mecore::me_project`](https://rdrr.io/pkg/mecore/man/me_project.html).

- rules:

  Liste de `me_check_rule` (par defaut :
  [`default_rules()`](https://aristarquepeniel40-lab.github.io/mecheck/reference/default_rules.md)).

## Value

Un `me_check_report`.
