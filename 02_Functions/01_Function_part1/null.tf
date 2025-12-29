resource "null_resource" "setup_web" {
  for_each = aws_instance.public-server

  # Trigger re-run if public IP changes
  #triggers = {
  #  instance_id = each.value.public_ip
  #}

  provisioner "file" {
    source      = "user_data.sh"
    destination = "/home/ec2-user/user_data.sh"

    connection {
      type        = "ssh"
      host        = each.value.public_ip
      user        = "ec2-user"
      private_key = file("Prac-SecOps-Key.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 700 /home/ec2-user/user_data.sh",
      "sudo ./home/ec2-user/user_data.sh",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      host        = each.value.public_ip
      user        = "ec2-user"
      private_key = file("Prac-SecOps-Key.pem")
    }
  }
}
