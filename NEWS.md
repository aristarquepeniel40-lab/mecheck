# mecheck 1.0.0

Première version stable.

## Fonctionnalités

* `me_check_rule`/`default_rules()` — 4 règles de contrôle intégrées :
  `dates_coherentes`, `indicateurs_labels_uniques`,
  `indicateurs_datasets_presents`, `logframe_complet`.
* `run_checks()` — ne lève jamais d'erreur, produit un constat complet
  même si plusieurs règles échouent simultanément (contrairement à
  `mecore::me_validate()`).
* `has_failures()` — vérification rapide pour usage en pipeline.
* `me_describe()` enregistré sur `me_check_report`.

## Notes de conception

* La règle `dates_coherentes` implémente la vérification
  `end_date >= start_date` explicitement exclue du validator de
  `mecore::me_metadata` (classe de structure pure, voir `ARCHITECTURE.md`
  §2.4).
