aws_region = "us-east-1"
vpc_cidr   = "172.18.0.0/16"
vpc_name   = "DevSecOps-Vpc"
key_name   = "Prac-SecOps-Key"
#azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
#public_cird_block  = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24"]
#private_cird_block = ["172.18.10.0/24", "172.18.20.0/24", "172.18.30.0/24"]
environment   = "Prod"
ingress_value = ["80", "8080", "443", "8443", "22", "3306", "1900", "1443"]
amis = {
  us-east-1 = "ami-068c0051b15cdb816"
  us-east-2 = "ami-0d8674b411adffa9f"

}

public_subnets = {
  "us-east-1a" = "172.18.1.0/24"
  "us-east-1b" = "172.18.2.0/24"
  "us-east-1c" = "172.18.3.0/24"
}

private_subnets = {
  "us-east-1a" = "172.18.10.0/24"
  "us-east-1b" = "172.18.20.0/24"
  "us-east-1c" = "172.18.30.0/24"
}


non_prod_subnet_count = "1"
