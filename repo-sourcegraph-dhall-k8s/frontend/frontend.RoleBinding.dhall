let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/1.18/package.dhall

in kubernetes.RoleBinding::{
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
    , roleRef = kubernetes.RoleRef::{
      , apiGroup = ""
      , kind = "Role"
      , name = "sourcegraph-frontend"
      }
    , subjects = Some
      [ kubernetes.Subject::{
        , kind = "ServiceAccount"
        , name = "sourcegraph-frontend"
        }
      ]
    }
