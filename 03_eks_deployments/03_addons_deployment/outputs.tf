output "vpc_cni_details" {
  description = "VPC CNI Add-on details"
  value = {
    name    = module.cni.addon_name
    version = module.cni.addon_version
    #status  = module.cni.addon_status # If not created, avoid errors
  }
}

output "kube_proxy_details" {
  description = "Kube-Proxy Add-on details"
  value = {
    name    = module.kube-proxy.addon_name
    version = module.kube-proxy.addon_version
    #status  = module.kube-proxy.addon_status
  }
}

output "coredns_details" {
  description = "CoreDNS Add-on details"
  value = {
    name    = module.coredns.addon_name
    version = module.coredns.addon_version
    #status  = module.coredns.addon_status
  }
}

output "ebs_csi_driver_details" {
  description = "EBS CSI Driver Add-on details"
  value = {
    name    = module.ebs_csi_driver.addon_name
    version = module.ebs_csi_driver.addon_version
    #status  = module.ebs_csi_driver.addon_status
  }
}

output "metrics_server_details" {
  description = "Metrics Server Add-on details"
  value = {
    name    = module.metrics_server.addon_name
    version = module.metrics_server.addon_version
    #status  = module.metrics_server.addon_status
  }
}
