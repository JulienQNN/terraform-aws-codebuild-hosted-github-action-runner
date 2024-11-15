variable "repo_name" {
  description = "Name of the repository."
  type        = string
  default     = "JulienQNN/terraform-aws-codebuild-hosted-github-action-runner"
}

################################################################################
# Tagging
################################################################################

variable "custom_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

################################################################################
# Common variables
################################################################################

variable "app_name" {
  description = "Name of the application."
  type        = string
  default     = "terraform-aws-codebuild-hosted-github-action-runner"
}

variable "app_env" {
  description = "Environment name of the application."
  type        = string
  default     = "test"
}

variable "app_owner" {
  description = "Owner of the application."
  type        = string
  default     = "me"
}
