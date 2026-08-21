# Changelog

## mecheck 1.0.0

Première version stable.

### Fonctionnalités

- `me_check_rule`/[`default_rules()`](https://aristarquepeniel40-lab.github.io/mecheck/reference/default_rules.md)
  — 4 règles de contrôle intégrées : `dates_coherentes`,
  `indicateurs_labels_uniques`, `indicateurs_datasets_presents`,
  `logframe_complet`.
- [`run_checks()`](https://aristarquepeniel40-lab.github.io/mecheck/reference/run_checks.md)
  — ne lève jamais d’erreur, produit un constat complet même si
  plusieurs règles échouent simultanément (contrairement à
  [`mecore::me_validate()`](https://rdrr.io/pkg/mecore/man/me_validate.html)).
- [`has_failures()`](https://aristarquepeniel40-lab.github.io/mecheck/reference/has_failures.md)
  — vérification rapide pour usage en pipeline.
- [`me_describe()`](https://rdrr.io/pkg/mecore/man/me_describe.html)
  enregistré sur `me_check_report`.

### Notes de conception

- La règle `dates_coherentes` implémente la vérification
  `end_date >= start_date` explicitement exclue du validator de
  [`mecore::me_metadata`](https://rdrr.io/pkg/mecore/man/me_metadata.html)
  (classe de structure pure, voir `ARCHITECTURE.md` §2.4).
