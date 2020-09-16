let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/1.18/package.dhall

in kubernetes.Role::{
    , metadata = kubernetes.ObjectMeta::{
      , labels = Some
        [ { mapKey = "app.kubernetes.io/component", mapValue = "frontend" }
        , { mapKey = "category", mapValue = "rbac" }
        , { mapKey = "deploy", mapValue = "sourcegraph" }
        , { mapKey = "sourcegraph-resource-requires"
          , mapValue = "cluster-admin"
          }
        ]
      , name = Some "sourcegraph-frontend"
      }
    , rules = Some
      [ kubernetes.PolicyRule::{
        , apiGroups = Some [ "" ]
        , resources = Some [ "endpoints", "services" ]
        , verbs = [ "get", "list", "watch" ]
        }
      ]
    }
