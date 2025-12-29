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
 