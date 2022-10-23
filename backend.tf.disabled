##################################################################################
# TERRAFORM BACKEND
##################################################################################
terraform {
  backend "remote" {
    # hostname = "value"
    organization = local.organization

    workspaces {
      name = local.workspaces_2
    }
  }
}
