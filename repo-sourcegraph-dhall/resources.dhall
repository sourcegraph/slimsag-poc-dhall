let schema = ./resources.schema.dhall

in {
    Frontend = ./frontend.dhall,
    IndexedSearch = ./indexed-search.dhall
} : schema.Services