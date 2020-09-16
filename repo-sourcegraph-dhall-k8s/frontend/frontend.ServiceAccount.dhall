let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/1.18/package.dhall

in kubernetes.ServiceAccount::{
    , imagePullSecrets = Some
      [ kubernetes.LocalObjectReference::{ name = Some "docker-registry" } ]
    , metadata = kubernetes.ObjectMeta::{
      , labels = Some
        [ { mapKey = "app.kubernetes.io/component", mapValue = "frontend" }
        , { mapKey = "category", mapValue = "rbac" }
        , { mapKey = "deploy", mapValue = "sourcegraph" }
        , { mapKey = "sourcegraph-resource-requires"
          , mapValue = "no-cluster-admin"
          }
        ]
      , name = Some "sourcegraph-frontend"
      }
    }
