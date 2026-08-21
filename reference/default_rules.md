# Regles de controle par defaut

Inclut notamment la coherence `end_date >= start_date`, deliberement
EXCLUE du validator de
[`mecore::me_metadata`](https://rdrr.io/pkg/mecore/man/me_metadata.html)
(voir ARCHITECTURE.md §2.4 : `me_metadata` est une classe de structure
pure). C'est ici, pas dans `mecore`, que cette coherence est verifiee.

## Usage

``` r
default_rules()
```

## Value

Liste de `me_check_rule`.
