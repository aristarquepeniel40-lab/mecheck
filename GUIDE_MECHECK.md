# Guide d'intégration — `mecheck`

Même processus que les quatre précédents : testé réellement, `mecore`
installé au préalable. Aucun bug trouvé cette fois non plus — les 4
règles se sont déclenchées correctement du premier coup sur des cas
volontairement problématiques.

## 1. Pré-requis

`mecheck` dépend de `mecore` uniquement (contrairement à `mereport`, il
n'a pas besoin de `medata`/`meindicator` pour fonctionner, mais le
walking skeleton s'en sert pour construire un cas de test réaliste —
assure-toi qu'ils sont installés si tu veux le lancer tel quel).

## 2. Installation

```r
setwd("chemin/vers/mecheck")
devtools::document()
devtools::load_all(".")
source("walking_skeleton.R")   # doit afficher "TOUS LES TESTS MECHECK PASSENT."
devtools::test()
devtools::check()
```

## 3. Pourquoi ce package existe (rappel de conception)

Quand on a construit `me_metadata` (session precedente), on a
deliberement EXCLU la coherence `end_date >= start_date` du validator
de la classe — decision documentee en ARCHITECTURE.md §2.4 ("classe de
structure pure"), avec la note : *"cette coherence est deplacee vers
une fonction separee, potentiellement dans mecheck"*. C'est exactement
ce qui est implemente ici, dans `default_rules()`.

`medata::quality_report()` verifiait la qualite d'UN dataset isole
(completude, typage). `mecheck::run_checks()` verifie les relations
ENTRE les objets d'un projet complet — un niveau au-dessus.

## 4. Ce que fait ce package (V1 minimale)

- `me_check_rule` — une regle = nom + fonction + severite indicative.
- `default_rules()` — 4 regles integrees :
  - `dates_coherentes` (le callback vers `me_metadata`, voir §3)
  - `indicateurs_labels_uniques`
  - `indicateurs_datasets_presents` (un indicateur ne doit jamais
    referencer un dataset absent de `project@datasets`)
  - `logframe_complet` (reutilise `mecore::me_validate()` sur le
    logframe, mais capture l'erreur au lieu de la laisser remonter)
- `run_checks(project, rules = default_rules())` → `me_check_report`,
  **ne leve jamais d'erreur** — produit un constat complet meme si
  plusieurs regles echouent a la fois (contrairement a
  `mecore::me_validate()`, qui s'arrete a la premiere violation).
- `has_failures(report)` — TRUE/FALSE rapide pour un usage en pipeline
  (ex. bloquer un `mereport::generate_report()` si `has_failures()`).

## 5. Sortie réelle du walking skeleton (testée ici)

```
Cas 1 (projet propre) : OK - Controle qualite 'Projet propre' : 4/4 regles respectees. Aucun probleme detecte.
Cas 2 (dates incoherentes) detecte : OK - end_date (2026-01-01) est anterieure a start_date (2026-12-31)
Cas 3 (labels dupliques) detecte : OK - label(s) d'indicateur en double : Meme label
Cas 4 (dataset reference absent) detecte : OK - l'indicateur 'Indicateur suspect' reference le dataset 'dataset_absent', absent de project@datasets

TOUS LES TESTS MECHECK PASSENT.
```

## 6. Piste d'intégration future (non implémentée ici)

`mereport::generate_report()` pourrait appeler `mecheck::run_checks()`
avant de rendre un rapport, et avertir (ou bloquer) si `has_failures()`
est vrai. Volontairement laissé de côté pour l'instant — modifier
`mereport` maintenant reviendrait à travailler sur deux packages à la
fois, contrairement à la règle du §4.
