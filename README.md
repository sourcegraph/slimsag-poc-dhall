# Stephen's Dhall PoC


# Random Dhall notes

## Convert Kubernetes YAML to Dhall, with types:

```
yaml-to-dhall 'let kubernetes = https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/1.18/package.dhall in kubernetes.Deployment.Type' < frontend.Deployment.yaml
```

```
dhall rewrite-with-schemas --inplace ./frontend.Deployment.dhall https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/1.18/schemas.dhall
```

## Type-check Dhall file

```
dhall --explain --file foo.dhall
```

## Convert Dhall to YAML

