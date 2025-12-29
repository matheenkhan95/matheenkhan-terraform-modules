resource "aws_instance" "public-server" {
  # ami = "${data.aws_ami.my_ami.id}"
  for_each      = local.selected_public_subnets
  ami           = lookup(var.amis, var.aws_region, "ami-068c0051b15cdb816")
  instance_type = "t2.micro"
  key_name      = var.key_name

  subnet_id                   = each.value.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true

  tags = {
    Name        = "public-server-${each.key}"
    Owner       = local.Owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }


}
