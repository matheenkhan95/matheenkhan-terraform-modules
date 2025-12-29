resource "aws_instance" "private-server" {
  # ami = "${data.aws_ami.my_ami.id}"
  for_each      = local.selected_private_subnets
  ami           = lookup(var.amis, var.aws_region, "ami-068c0051b15cdb816")
  instance_type = "t2.micro"
  key_name      = var.key_name

  subnet_id              = each.value.id
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  #associate_public_ip_address = true

  tags = {
    Name        = "private-server-${each.key}"
    Owner       = local.Owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y nginx
    sudo yum install git -y
    sudo git clone https://github.com/saikiranpi/SecOps-game.git
    sudo rm -f /usr/share/nginx/html/index.html
    sudo cp SecOps-game/index.html /usr/share/nginx/html/index.html
    echo "<h1>${var.vpc_name}-public-server-${each.key}</h1>" | sudo tee /usr/share/nginx/html/index.html
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF
}
