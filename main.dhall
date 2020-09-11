{-
let resources = ./resources.dhall : (./schema.dhall).Type

let config 

in resources with All-In-One.Deployment.jaeger.apiVersions = "FOOBAR"

-}

