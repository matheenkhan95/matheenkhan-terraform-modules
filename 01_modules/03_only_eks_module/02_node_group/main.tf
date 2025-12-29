/*resource "aws_eks_node_group" "this" {
  for_each = var.node_groups

  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-${each.key}"
  node_role_arn   = aws_iam_role.node_group.arn

  scaling_config {
    desired_size = each.value.desired_capacity
    max_size     = each.value.max_capacity
    min_size     = each.value.min_capacity
  }

  instance_types = [each.value.instance_type]

  # if a specific AZ (subnet list) is provided, use that.
  # Otherwise, use all private subnets (spanning all AZs).
  subnet_ids = length(each.value.node_subnet_ids) > 0 ? each.value.node_subnet_ids : var.private_subnets
  
  dynamic "taint" {
    for_each = lookup(each.value, "taints", []) # Prevents errors if taints are missing
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }
  
  remote_access {
    ec2_ssh_key = var.ec2_key_name
    # Optionally add security groups for SSH access
    # source_security_group_ids = [ ... ]
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_group_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_policy,
    aws_iam_role_policy_attachment.custom_node_group_policy_attachment
  ]
}
*/

locals {
  expanded_node_groups = flatten([
    for group_name, group in var.node_groups : [
      # If node_subnet_ids is empty -> 1 group with all subnets
      length(group.node_subnet_ids) == 0 ? [
        {
          name   = group_name
          config = merge(group, { node_subnet_ids = var.private_subnets })
        }
      ] : 
      # If subnets are specified -> 1 group per subnet with AZ name
      [
        for subnet in group.node_subnet_ids : {
          # Lookup AZ name from subnet ID
          name   = "${group_name}-${[for az, id in var.private_subnets : az if id == subnet][0]}"
          config = merge(group, { node_subnet_ids = [subnet] })
        }
      ]
    ]
  ])

  node_groups_expanded = { 
    for ng in local.expanded_node_groups : ng.name => ng.config 
  }
}

/*
resource "aws_eks_node_group" "this" {
  for_each = local.node_groups_expanded

  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-${each.key}"
  node_role_arn   = aws_iam_role.node_group.arn

  scaling_config {
    desired_size = each.value.desired_capacity
    max_size     = each.value.max_capacity
    min_size     = each.value.min_capacity
  }

  instance_types = [each.value.instance_type]

  # Each expanded node group now gets a single subnet.
  subnet_ids = each.value.node_subnet_ids

  dynamic "taint" {
    for_each = lookup(each.value, "taints", [])
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  remote_access {
    ec2_ssh_key = var.ec2_key_name
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_group_policy,
    aws_iam_role_policy_attachment.ecr_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.custom_node_group_policy_attachment
  ]
}

*/

resource "aws_launch_template" "this" {
  for_each = local.node_groups_expanded

  name_prefix   = "${var.cluster_name}-${each.key}-"
  instance_type = each.value.instance_type
  key_name      = var.ec2_key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.allow_all.id]

  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-${each.key}-node"
    }
  }
}

resource "aws_eks_node_group" "this" {
  for_each = local.node_groups_expanded

  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-${each.key}"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = each.value.node_subnet_ids

  scaling_config {
    desired_size = each.value.desired_capacity
    max_size     = each.value.max_capacity
    min_size     = each.value.min_capacity
  }

  launch_template {
    id      = aws_launch_template.this[each.key].id
    version = "$Latest"
  }


  dynamic "taint" {
    for_each = lookup(each.value, "taints", [])
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_launch_template.this,
    aws_iam_role_policy_attachment.node_group_policy,
    aws_iam_role_policy_attachment.ecr_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.custom_node_group_policy_attachment
  ]
}
