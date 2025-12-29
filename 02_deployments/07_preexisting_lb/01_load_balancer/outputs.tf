# networking_team/outputs.tf
output "target_group_arn" {
  value = aws_lb_target_group.nginx_tg.arn
}
