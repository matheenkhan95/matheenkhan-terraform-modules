/*

locals {
  expanded_node_groups = flatten([
    for group_name, group in var.node_groups : [
      # Condition 1: If node_subnet_ids is empty -> Deploy across all subnets
      length(group.node_subnet_ids) == 0 ? [
        {
          name   = group_name
          config = merge(group, { node_subnet_ids = values(var.private_subnets) })
        }
      ] :
      # Condition 2: If span_across_multiple_subnets is true -> Span across first N subnets dynamically
      group.span_across_multiple_subnets ? [
        {
          name   = "${group_name}-multi-az"
          config = merge(group, { 
            node_subnet_ids = slice(group.node_subnet_ids, 0, group.node_group_subnet_count) 
          })
        }
      ] :
      # Condition 3: If span_across_multiple_subnets is false -> Create separate node groups per subnet
      [
        for subnet in group.node_subnet_ids : {
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


node_groups = {
  "general" = {
    instance_type                  = "t3.medium"
    desired_capacity               = 2
    max_capacity                   = 3
    min_capacity                   = 1
    node_subnet_ids                = []  # Condition 1: Deploy across all subnets
    span_across_multiple_subnets   = false
    node_group_subnet_count        = 2   # Ignored in this case
  },
  "custom-ng" = {
    instance_type                  = "t3.medium"
    desired_capacity               = 2
    max_capacity                   = 3
    min_capacity                   = 1
    node_subnet_ids                = values(var.private_subnets) # Pass all subnets
    span_across_multiple_subnets   = true  # Condition 2: Span across first 2 subnets dynamically
    node_group_subnet_count        = 2
  },
  "special-ng" = {
    instance_type                  = "t3.medium"
    desired_capacity               = 2
    max_capacity                   = 3
    min_capacity                   = 1
    node_subnet_ids                = values(var.private_subnets) # Pass all subnets
    span_across_multiple_subnets   = false  # Condition 3: Separate node groups per subnet
    node_group_subnet_count        = 2   # Ignored in this case
  }
}


*/