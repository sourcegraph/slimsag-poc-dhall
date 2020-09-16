let schema = ./resources.schema.dhall

let FrontendContainer = {
    Image = "sourcegraph/frontend",
    Requests = {
        CPU = 2.0,
        Memory = "4g"
    },
    Limits = {
        CPU = 4.0,
        Memory = "8g"
    },
    HealthCheck = Some {
        Path = "/healthz",
        Port = 3080,
        InitialDelaySeconds = 300,
        TimeoutSeconds = 5
    }
} : schema.Container

in {
    Name = "frontend",
    Containers = {
        Frontend = FrontendContainer
    }
}
