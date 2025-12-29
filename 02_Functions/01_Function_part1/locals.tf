locals {
  Owner      = "Prod-owner"
  costcenter = "Hyd-8080"
  TeamDL     = "matheenkhan@gmail.com"

}


locals {
  selected_public_subnets = var.environment == "Prod" ? aws_subnet.public-subnet : {
    for k, v in aws_subnet.public-subnet : k => v if index(keys(aws_subnet.public-subnet), k) < var.non_prod_subnet_count
  }
}

locals {
  selected_private_subnets = var.environment == "Prod" ? aws_subnet.private-subnet : {
    for k, v in aws_subnet.private-subnet : k => v if index(keys(aws_subnet.private-subnet), k) < var.non_prod_subnet_count
  }
}


