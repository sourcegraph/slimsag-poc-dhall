let IndexedSearcherContainer = {
    Image = "sourcegraph/indexed-searcher",
    Requests = {
        CPU = 0.5,
        Memory = "2g"
    },
    Limits = {
        CPU = 2.0,
        Memory = "4g"
    },
    HealthCheck = Some {
        Path = "/healthz",
        Port = 6070,
        InitialDelaySeconds = 0,
        TimeoutSeconds = 5
    }
} : (./schema.dhall).Container

let SearchIndexerContainer = {
    Image = "sourcegraph/search-indexer",
    Requests = {
        CPU = 8.0,
        Memory = "8g"
    },
    Limits = {
        CPU = 4.0,
        Memory = "4g"
    },
    HealthCheck = None (./schema.dhall).HealthCheck
} : (./schema.dhall).Container

in {
    Name = "indexed-search",
    Containers = [ IndexedSearcherContainer, SearchIndexerContainer ]
} : (./schema.dhall).Service
