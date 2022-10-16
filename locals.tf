locals {
  common_tags = {
    company      = "digilerz"
    project      = "digilerz-web-app"
    billing_code = "00000000000"
  }
  organization = "demo-project-organization"
  workspaces_1 = "ws-va-aws-d0001-dev-digilerz"
  workspaces_2 = "digilerz-testing"
  namespace    = "digilerz"
  tags         = "dev-env"
}