##################################################################################
# TERRAFORM BACKEND
##################################################################################
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = local.organization

    workspaces {
      name = local.workspaces_2
    }
  }
}


/*
terraform {
  cloud {
    organization = local.organization
    hostname = "app.terraform.io"

    workspaces {
      name = local.workspaces_2
    }
  }
}
*/


/*
data "terraform_remote_state" "app-baseline" {
  backend = "remote"

  config = {
    organization = local.organization
    hostname = "app.terraform.io"

    workspaces {
      name = local.workspaces_2
}
}
}
*/