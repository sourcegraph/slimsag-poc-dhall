let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/1.18/package.dhall

in kubernetes.Ingress::{
    , metadata = kubernetes.ObjectMeta::{
      , annotations = Some
        [ { mapKey = "kubernetes.io/ingress.class", mapValue = "nginx" }
        , { mapKey = "nginx.ingress.kubernetes.io/proxy-body-size"
          , mapValue = "150m"
          }
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
    , spec = Some kubernetes.IngressSpec::{
      , rules = Some
        [ kubernetes.IngressRule::{
          , http = Some kubernetes.HTTPIngressRuleValue::{
            , paths =
              [ kubernetes.HTTPIngressPath::{
                , backend = kubernetes.IngressBackend::{
                  , serviceName = Some "sourcegraph-frontend"
                  , servicePort = Some
                      (< Int : Natural | String : Text >.Int 30080)
                  }
                , path = Some "/"
                }
              ]
            }
          }
        ]
      }
    }
