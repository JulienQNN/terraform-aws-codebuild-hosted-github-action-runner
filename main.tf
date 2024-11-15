locals {
  account_id         = data.aws_caller_identity.current.account_id

  app_env   = var.app_env
  app_name  = var.app_name
  app_owner = var.app_owner

  codebuild_project = "${local.app_env}-${local.app_name}"

  # Github
  source_location = "https://github.com/${var.repo_name}.git"

  # Network
  vpc_name            = "${local.app_env}-shared-vpc"
  vpc_id              = data.aws_ssm_parameter.vpc_id.value
  vpc_cidr            = data.aws_ssm_parameter.shared_vpc_cidr.value
  private_subnet_1_id = data.aws_ssm_parameter.private_subnet_1_id.value

}

data "aws_caller_identity" "current" {}

# Network
data "aws_ssm_parameter" "vpc_id" {
  name = "/org/landing-zone/network/${local.vpc_name}/id"
}

data "aws_ssm_parameter" "shared_vpc_cidr" {
  name = "/org/landing-zone/network/${local.vpc_name}/cidr"
}

data "aws_ssm_parameter" "private_subnet_1_id" {
  name = "/org/landing-zone/network/${local.vpc_name}/private-subnet-1/id"
}
