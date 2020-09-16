let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/1.18/package.dhall

in kubernetes.Service::{
    , metadata = kubernetes.ObjectMeta::{
      , annotations = Some
        [ { mapKey = "prometheus.io/port", mapValue = "6060" }
        , { mapKey = "sourcegraph.prometheus/scrape", mapValue = "true" }
        ]
      , labels = Some
        [ { mapKey = "app", mapValue = "sourcegraph-frontend" }
        , { mapKey = "app.kubernetes.io/component", mapValue = "frontend" }
        , { mapKey = "deploy", mapValue = "sourcegraph" }
        , { mapKey = "sourcegraph-resource-requires"
          , mapValue = "no-cluster-admin"
          }
        ]
      , name = Some "sourcegraph-frontend"
      }
    , spec = Some kubernetes.ServiceSpec::{
      , ports = Some
        [ kubernetes.ServicePort::{
          , name = Some "http"
          , port = 30080
          , targetPort = Some (< Int : Natural | String : Text >.String "http")
          }
        ]
      , selector = Some
        [ { mapKey = "app", mapValue = "sourcegraph-frontend" } ]
      , type = Some "ClusterIP"
      }
    }
