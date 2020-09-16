{
    Frontend = {
        InternalService = ./frontend/frontend-internal.Service.dhall,
        Deployment = ./frontend/frontend.Deployment.dhall,
        Ingress = ./frontend/frontend.Ingress.dhall,
        Role = ./frontend/frontend.Role.dhall,
        RoleBinding = ./frontend/frontend.RoleBinding.dhall,
        Service = ./frontend/frontend.Service.dhall,
        ServiceAccount = ./frontend/frontend.ServiceAccount.dhall
    }
}