let ContainerResources = {
    -- CPUs to request. Examples: 0.5, 1.5
    CPU : Double,

    -- Memory to request. Examples: "0.5g", "512m"
    Memory : Text
}

let HealthCheck = {
    Path : Text,
    Port : Natural,
    InitialDelaySeconds : Natural,
    TimeoutSeconds : Natural
} 

let Container = {
    -- The Docker image for the container, excluding registry name and image tag / SHA.
    -- Example: `sourcegraph/frontend` NOT `index.docker.io/sourcegraph/frontend:insiders@sha256:...`
    Image : Text,

    -- The container's requested resources
    Requests : ContainerResources,

    -- The container's resource limits
    Limits : ContainerResources,

    -- A healthcheck describing if the container is healthy
    HealthCheck : Optional HealthCheck
}

let Service = {
    -- The name of the service, e.g. "frontend" or "indexed-search"
    Name : Text,

    -- Containers that make up this service. N replicas of this service may be deployed, which
    -- implies all of these containers would be deployed N times.
    Containers : List Container
}

let Services = {
    Frontend : Service,
    IndexedSearch : Service
}

in {
    HealthCheck = HealthCheck,
    Container = Container,
    Service = Service,
    Services = Services
}
