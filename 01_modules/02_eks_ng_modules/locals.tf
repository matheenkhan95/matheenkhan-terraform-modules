locals {
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets = values(data.terraform_remote_state.vpc.outputs.private_subnet_ids)
  public_subnets  = values(data.terraform_remote_state.vpc.outputs.public_subnet_ids)

  # AZ Configuration
  selected_azs = var.multi_az ? keys(data.terraform_remote_state.vpc.outputs.private_subnet_ids) : [element(keys(data.terraform_remote_state.vpc.outputs.private_subnet_ids), 0)]

  # General node group configuration using input variables
  general_node_group = var.enable_general ? {
    name           = var.general_node_group_name
    instance_types = var.general_node_group_instance_types
    min_size       = var.general_node_group_min_size
    max_size       = var.general_node_group_max_size
    desired_size   = var.general_node_group_desired_size
    subnet_ids     = var.multi_az ? local.private_subnets : [local.private_subnets[0]]
  }: null

  # GPU node group configuration (only set if GPU is enabled)
  gpu_node_group = var.enable_gpu ? {
    name           = var.gpu_node_group_name
    instance_types = var.gpu_node_group_instance_types
    min_size       = var.gpu_node_group_min_size
    max_size       = var.gpu_node_group_max_size
    desired_size   = var.gpu_node_group_desired_size
    subnet_ids     = var.multi_az ? local.private_subnets : [local.private_subnets[0]]
    taints         = var.gpu_node_group_taints
  } : null

}