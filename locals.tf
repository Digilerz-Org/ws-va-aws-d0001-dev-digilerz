locals {
  common_tags = {
    company      = "digilerz"
    project      = "digilerz-web-app"
    billing_code = "00000000000"
  }

  # Terraform organization
  organization = "demo-project-organization"

  # Terraform workspace list
  workspaces_1 = "ws-va-aws-addon-dev-networking"
  workspaces_2 = "ws-va-aws-d0001-dev-digilerz"
  workspaces_3 = "ws-vb-aws-d0001-dev-digilerz"

  # Common tags for all resources
  namespace   = "digilerz"
  environment = "dev"
  tags        = "${local.namespace}-${local.environment}"
}