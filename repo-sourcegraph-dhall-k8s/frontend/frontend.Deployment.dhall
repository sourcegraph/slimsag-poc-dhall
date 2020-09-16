let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/1.18/package.dhall

let frontend = (../../repo-sourcegraph-dhall/resources.dhall).Frontend
let List/index = https://prelude.dhall-lang.org/List/index

in kubernetes.Deployment::{
    , metadata = kubernetes.ObjectMeta::{
      , annotations = Some
        [ { mapKey = "description"
          , mapValue = "Serves the frontend of Sourcegraph via HTTP(S)."
          }
        ]
      , labels = Some
        [ { mapKey = "app.kubernetes.io/component", mapValue = "frontend" }
        , { mapKey = "deploy", mapValue = "sourcegraph" }
        , { mapKey = "sourcegraph-resource-requires"
          , mapValue = "no-cluster-admin"
          }
        ]
      , name = Some "sourcegraph-frontend"
      }
    , spec = Some kubernetes.DeploymentSpec::{
      , minReadySeconds = Some 10
      , replicas = Some 1
      , revisionHistoryLimit = Some 10
      , selector = kubernetes.LabelSelector::{
        , matchLabels = Some
          [ { mapKey = "app", mapValue = "sourcegraph-frontend" } ]
        }
      , strategy = Some kubernetes.DeploymentStrategy::{
        , rollingUpdate = Some kubernetes.RollingUpdateDeployment::{
          , maxSurge = Some (kubernetes.IntOrString.Int 2)
          , maxUnavailable = Some (< Int : Natural | String : Text >.Int 0)
          }
        , type = Some "RollingUpdate"
        }
      , template = kubernetes.PodTemplateSpec::{
        , metadata = kubernetes.ObjectMeta::{
          , labels = Some
            [ { mapKey = "app", mapValue = "sourcegraph-frontend" }
            , { mapKey = "deploy", mapValue = "sourcegraph" }
            ]
          }
        , spec = Some kubernetes.PodSpec::{
          , containers =
            [ kubernetes.Container::{
              , args = Some [ "serve" ]
              , env = Some
                [ kubernetes.EnvVar::{ name = "PGDATABASE", value = Some "sg" }
                , kubernetes.EnvVar::{ name = "PGHOST", value = Some "pgsql" }
                , kubernetes.EnvVar::{ name = "PGPORT", value = Some "5432" }
                , kubernetes.EnvVar::{ name = "PGSSLMODE", value = Some "disable" }
                , kubernetes.EnvVar::{ name = "PGUSER", value = Some "sg" }
                , kubernetes.EnvVar::{
                  , name = "SRC_GIT_SERVERS"
                  , value = Some "gitserver-0.gitserver:3178"
                  }
                , kubernetes.EnvVar::{
                  , name = "POD_NAME"
                  , valueFrom = Some kubernetes.EnvVarSource::{
                    , fieldRef = Some kubernetes.ObjectFieldSelector::{
                      , fieldPath = "metadata.name"
                      }
                    }
                  }
                , kubernetes.EnvVar::{
                  , name = "CACHE_DIR"
                  , value = Some "/mnt/cache/\$(POD_NAME)"
                  }
                , kubernetes.EnvVar::{
                  , name = "GRAFANA_SERVER_URL"
                  , value = Some "http://grafana:30070"
                  }
                , kubernetes.EnvVar::{
                  , name = "JAEGER_SERVER_URL"
                  , value = Some "http://jaeger-query:16686"
                  }
                , kubernetes.EnvVar::{
                  , name = "PRECISE_CODE_INTEL_BUNDLE_MANAGER_URL"
                  , value = Some "http://precise-code-intel-bundle-manager:3187"
                  }
                , kubernetes.EnvVar::{
                  , name = "PROMETHEUS_URL"
                  , value = Some "http://prometheus:30090"
                  }
                ]
              , image = Some
                  "index.docker.io/${frontend.Containers.Frontend.Image}:insiders@sha256:57958d158b69ab75381089f1334fb2b58ac3cf516bed830e2b29512b9504dcc8"
              , livenessProbe = Some kubernetes.Probe::{
                , httpGet = Some kubernetes.HTTPGetAction::{
                  , path = Some "/healthz"
                  , port = < Int : Natural | String : Text >.String "http"
                  , scheme = Some "HTTP"
                  }
                , initialDelaySeconds = Some 300
                , timeoutSeconds = Some 5
                }
              , name = "frontend"
              , ports = Some
                [ kubernetes.ContainerPort::{
                  , containerPort = 3080
                  , name = Some "http"
                  }
                , kubernetes.ContainerPort::{
                  , containerPort = 3090
                  , name = Some "http-internal"
                  }
                ]
              , readinessProbe = Some kubernetes.Probe::{
                , httpGet = Some kubernetes.HTTPGetAction::{
                  , path = Some "/healthz"
                  , port = < Int : Natural | String : Text >.String "http"
                  , scheme = Some "HTTP"
                  }
                , periodSeconds = Some 5
                , timeoutSeconds = Some 5
                }
              , resources = Some kubernetes.ResourceRequirements::{
                , limits = Some
                  [ { mapKey = "cpu", mapValue = "2" }
                  , { mapKey = "memory", mapValue = "4G" }
                  ]
                , requests = Some
                  [ { mapKey = "cpu", mapValue = "2" }
                  , { mapKey = "memory", mapValue = "2G" }
                  ]
                }
              , terminationMessagePolicy = Some "FallbackToLogsOnError"
              , volumeMounts = Some
                [ kubernetes.VolumeMount::{
                  , mountPath = "/mnt/cache"
                  , name = "cache-ssd"
                  }
                ]
              }
            , kubernetes.Container::{
              , args = Some
                [ "--reporter.grpc.host-port=jaeger-collector:14250"
                , "--reporter.type=grpc"
                ]
              , env = Some
                [ kubernetes.EnvVar::{
                  , name = "POD_NAME"
                  , valueFrom = Some kubernetes.EnvVarSource::{
                    , fieldRef = Some kubernetes.ObjectFieldSelector::{
                      , apiVersion = Some "v1"
                      , fieldPath = "metadata.name"
                      }
                    }
                  }
                ]
              , image = Some
                  "index.docker.io/sourcegraph/jaeger-agent:insiders@sha256:69b0a662e47534c78a91c2a1d19f495eef750ebaacf190f4e87b676858595cef"
              , name = "jaeger-agent"
              , ports = Some
                [ kubernetes.ContainerPort::{
                  , containerPort = 5775
                  , protocol = Some "UDP"
                  }
                , kubernetes.ContainerPort::{
                  , containerPort = 5778
                  , protocol = Some "TCP"
                  }
                , kubernetes.ContainerPort::{
                  , containerPort = 6831
                  , protocol = Some "UDP"
                  }
                , kubernetes.ContainerPort::{
                  , containerPort = 6832
                  , protocol = Some "UDP"
                  }
                ]
              , resources = Some kubernetes.ResourceRequirements::{
                , limits = Some
                  [ { mapKey = "cpu", mapValue = "1" }
                  , { mapKey = "memory", mapValue = "500M" }
                  ]
                , requests = Some
                  [ { mapKey = "cpu", mapValue = "100m" }
                  , { mapKey = "memory", mapValue = "100M" }
                  ]
                }
              }
            ]
          , securityContext = Some kubernetes.PodSecurityContext::{
            , runAsUser = Some 0
            }
          , serviceAccountName = Some "sourcegraph-frontend"
          , volumes = Some
            [ kubernetes.Volume::{
              , emptyDir = Some kubernetes.EmptyDirVolumeSource::{=}
              , name = "cache-ssd"
              }
            ]
          }
        }
      }
    }
