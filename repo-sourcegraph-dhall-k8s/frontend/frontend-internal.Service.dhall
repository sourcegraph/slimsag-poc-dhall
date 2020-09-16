let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/1.18/package.dhall

in  kubernetes.Service::{
    , metadata = kubernetes.ObjectMeta::{
      , labels = Some
        [ { mapKey = "app", mapValue = "sourcegraph-frontend" }
        , { mapKey = "app.kubernetes.io/component", mapValue = "frontend" }
        , { mapKey = "deploy", mapValue = "sourcegraph" }
        , { mapKey = "sourcegraph-resource-requires"
          , mapValue = "no-cluster-admin"
          }
        ]
      , name = Some "sourcegraph-frontend-internal"
      }
    , spec = Some kubernetes.ServiceSpec::{
      , ports = Some
        [ kubernetes.ServicePort::{
          , name = Some "http-internal"
          , port = 80
          , targetPort = Some
              (< Int : Natural | String : Text >.String "http-internal")
          }
        ]
      , selector = Some
        [ { mapKey = "app", mapValue = "sourcegraph-frontend" } ]
      , type = Some "ClusterIP"
      }
    }
