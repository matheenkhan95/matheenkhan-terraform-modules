# Create the NLB with public subnets and security group
resource "aws_lb" "external_nlb" {
  name               = "precreated-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = values(data.terraform_remote_state.vpc.outputs.public_subnet_ids)
  # Remove security_groups - NLBs don't use them
  enable_deletion_protection = false
}

# Create a target group for NGINX
resource "aws_lb_target_group" "nginx_tg" {
  name        = "nginx-precreated-tg"
  port        = 32080
  protocol    = "TCP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  target_type = "instance" # Must be "ip" for EKS

  health_check {
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "/healthz"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
  }
}

# Create a listener for the NLB
resource "aws_lb_listener" "tcp_listener" {
  load_balancer_arn = aws_lb.external_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}
