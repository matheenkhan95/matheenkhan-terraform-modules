provider "kubernetes" {
  config_path = "C:\\Users\\a878519\\.kube\\config"
}

provider "helm" {
  kubernetes {
    config_path = "C:\\Users\\a878519\\.kube\\config"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.12.1"
  namespace  = "ingress-nginx"
  create_namespace = true

  values = [
    <<EOF
controller:
  replicaCount: 2
  service:
    type: NodePort
    nodePorts:
      http: 32080
      https: 32443
    externalTrafficPolicy: Local
  extraArgs:
    health-check-path: /healthz
EOF
  ]

  disable_openapi_validation = true
  wait          = true
  wait_for_jobs = true
  timeout       = 600
}
