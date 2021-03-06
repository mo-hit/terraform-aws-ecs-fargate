#------------------------------------------------------------------------------
# ECS Cluster
#------------------------------------------------------------------------------
module "ecs-cluster" {
  source  = "cn-terraform/ecs-cluster/aws"
  version = "1.0.6"
  # source  = "../terraform-aws-ecs-cluster"

  name = var.name_prefix
}

#------------------------------------------------------------------------------
# ECS Task Definition
#------------------------------------------------------------------------------
module "td" {
  source  = "cn-terraform/ecs-fargate-task-definition/aws"
  version = "1.0.21"
  # source  = "../terraform-aws-ecs-fargate-task-definition"

  name_prefix                  = var.name_prefix
  container_name               = var.container_name
  container_image              = var.container_image
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory_reservation
  container_definition         = var.container_definition
  port_mappings                = var.port_mappings
  healthcheck                  = var.healthcheck
  container_cpu                = var.container_cpu
  essential                    = var.essential
  entrypoint                   = var.entrypoint
  command                      = var.command
  working_directory            = var.working_directory
  environment                  = var.environment
  extra_hosts                  = var.extra_hosts
  map_environment              = var.map_environment
  environment_files            = var.environment_files
  secrets                      = var.secrets
  readonly_root_filesystem     = var.readonly_root_filesystem
  linux_parameters             = var.linux_parameters
  log_configuration            = var.log_configuration
  firelens_configuration       = var.firelens_configuration
  mount_points                 = var.mount_points
  dns_servers                  = var.dns_servers
  dns_search_domains           = var.dns_search_domains
  ulimits                      = var.ulimits
  repository_credentials       = var.repository_credentials
  volumes_from                 = var.volumes_from
  links                        = var.links
  user                         = var.user
  container_depends_on         = var.container_depends_on
  docker_labels                = var.docker_labels
  start_timeout                = var.start_timeout
  stop_timeout                 = var.stop_timeout
  privileged                   = var.privileged
  system_controls              = var.system_controls
  hostname                     = var.hostname
  disable_networking           = var.disable_networking
  interactive                  = var.interactive
  pseudo_terminal              = var.pseudo_terminal
  docker_security_options      = var.docker_security_options

  permissions_boundary  = var.permissions_boundary
  placement_constraints = var.placement_constraints_task_definition
  proxy_configuration   = var.proxy_configuration
  volumes               = var.volumes
}

#------------------------------------------------------------------------------
# ECS Service
#------------------------------------------------------------------------------
module "ecs-fargate-service" {
  source  = "git@github.com:mo-hit/terraform-aws-ecs-fargate-service.git"
  # source  = "../terraform-aws-ecs-fargate-service"

  name_prefix = var.name_prefix
  vpc_id      = var.vpc_id

  ecs_cluster_arn                    = module.ecs-cluster.aws_ecs_cluster_cluster_arn
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  desired_count                      = var.desired_count
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  ordered_placement_strategy         = var.ordered_placement_strategy
  placement_constraints              = var.ecs_service_placement_constraints
  platform_version                   = var.platform_version
  propagate_tags                     = var.propagate_tags
  service_registries                 = var.service_registries
  task_definition_arn                = module.td.aws_ecs_task_definition_td_arn

  # Network configuration block
  public_subnets   = var.public_subnets_ids
  private_subnets  = var.private_subnets_ids
  security_groups  = var.ecs_service_security_groups
  assign_public_ip = var.assign_public_ip

  # ECS Service Load Balancer block
  container_name = var.container_name

  # ECS Autoscaling
  enable_autoscaling = var.enable_autoscaling
  ecs_cluster_name   = module.ecs-cluster.aws_ecs_cluster_cluster_name

  # Certificates
  default_certificate_arn                         = var.default_certificate_arn
  ssl_policy                                      = var.ssl_policy
  additional_certificates_arn_for_https_listeners = var.additional_certificates_arn_for_https_listeners
}
