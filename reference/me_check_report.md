# Rapport de controle qualite

Rapport de controle qualite

## Usage

``` r
me_check_report(
  project_name = character(0),
  results = (function (.data = list(), row.names = NULL) 
 {
     if (is.null(row.names))
    {
         list2DF(.data)
     }
     else {
         out <- list2DF(.data,
    length(row.names))
attr(out, "row.names") <- row.names
         out
     }

    })()
)
```

## Arguments

- project_name:

  Nom du projet controle.

- results:

  Un `data.frame` avec colonnes `rule`, `severity`, `status` (`"OK"` ou
  `"ECHEC"`), `message`.
