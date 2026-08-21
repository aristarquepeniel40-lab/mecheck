# mecheck

[![R-CMD-check](https://github.com/aristarquepeniel40-lab/mecheck/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/aristarquepeniel40-lab/mecheck/actions/workflows/R-CMD-check.yaml)

**Contrôle qualité pour l’écosystème
[MEverse](https://github.com/aristarquepeniel40-lab/mecore).**

Vérifie la cohérence d’un
[`mecore::me_project`](https://rdrr.io/pkg/mecore/man/me_project.html)
**dans son ensemble** : cohérence des dates, unicité des labels
d’indicateurs, présence des datasets référencés, complétude du cadre
logique. Complémentaire à
[medata](https://github.com/aristarquepeniel40-lab/medata) (qui vérifie
un dataset isolé) : `mecheck` vérifie les relations *entre* les objets
d’un projet.

Ne lève jamais d’erreur — produit un constat complet même si plusieurs
règles échouent en même temps, pour un audit exhaustif plutôt qu’un
arrêt à la première anomalie.

## Installation

``` r

install.packages("remotes")
remotes::install_github("aristarquepeniel40-lab/mecore")   # dependance
remotes::install_github("aristarquepeniel40-lab/mecheck")
```

## Exemple rapide

``` r

library(mecore)
library(mecheck)

meta <- me_metadata(project_name = "p", organization = "o", country = "c", donor = "d",
  manager = "m", start_date = as.Date("2026-01-01"), end_date = as.Date("2026-12-31"),
  version = "0.1", description = "d", objectives = "o", sdgs = character(0))

p <- me_project(name = "p", metadata = meta, datasets = list(), indicators = list(), logframe = NULL)

rapport <- run_checks(p)
print(rapport@results)
cat(me_describe(rapport), "\n")

if (has_failures(rapport)) {
  # decider quoi faire : avertir, bloquer une publication, etc.
}
```

## Fait partie de l’écosystème MEverse

[mecore](https://github.com/aristarquepeniel40-lab/mecore) (fondations)
· [medata](https://github.com/aristarquepeniel40-lab/medata) ·
[meindicator](https://github.com/aristarquepeniel40-lab/meindicator) ·
**mecheck** (ce dépôt) ·
[mereport](https://github.com/aristarquepeniel40-lab/mereport) (intègre
`mecheck` en option, voir `generate_report(..., check = TRUE)`)

## Licence

MIT — voir
[`LICENSE`](https://aristarquepeniel40-lab.github.io/mecheck/LICENSE).
