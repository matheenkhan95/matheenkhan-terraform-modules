/*provider "aws" {
  region = "us-east-1"
}

module "nginx_ingress" {
  source            = "../../../01_modules/05_ingress_controller/02_nginx_controller"
  chart_version     = "4.10.0"
  namespace         = "ingress-nginx"
  values_file_path  = "E:/10_cka_tasks/12_vpc_deployment_locals_for/01_modules/00_iam_json"
  cluster_name =   data.terraform_remote_state.eks.outputs.cluster_name
  region = "us-east-1"
}


provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "eks" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    token                  = data.aws_eks_cluster_auth.eks.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
}

resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.10.0"
  timeout = 900
 values = [
  file("E:/10_cka_tasks/12_vpc_deployment_locals_for/01_modules/00_iam_json/nginx-ingress.yaml")
]

}
*/


provider "kubernetes" {
  # Use double backslashes to escape backslashes in Windows paths.
  config_path = "C:\\Users\\a878519\\.kube\\config"
}

provider "helm" {
  kubernetes = {
    config_path = "C:\\Users\\a878519\\.kube\\config"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.12.1" # Update the version if necessary

  namespace        = "ingress-nginx"
  create_namespace = true

  # Configure the ingress controller to create a LoadBalancer for external access.
  values = [
    <<EOF
controller:
  service:
    type: LoadBalancer
EOF
  ]

  # Disable OpenAPI validation to bypass the error with the pre-install hook.
  disable_openapi_validation = true

  # Wait for the release to be ready, reducing the chance of timeout errors.
  wait          = true
  wait_for_jobs = true
  timeout       = 600
}
