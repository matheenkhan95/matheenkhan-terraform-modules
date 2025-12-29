variable "region" {}
variable "cluster_name" {}
variable "namespace" {
  default = "ingress-nginx"
}
variable "chart_version" {
  default = "4.10.0"
}
variable "values_file_path" {
  description = "Path to your customized values.yaml"
}
