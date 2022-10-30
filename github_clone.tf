variable "gh_token" {
  default = "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"
}

variable "gh_base_url" {
  default = "https://github.com/Digilerz-Org/ws-va-aws-d0001-dev-digilerz.git"
}


provider "github" {
  token    = var.gh_token
  owner    = "Digilerz-Org"
  base_url = var.gh_base_url
  #   version = "~>v2.9"
}

data "github_repository" "dummy" {
  full_name = "Digilerz-Org/ws-va-aws-d0001-dev-digilerz"
}

# cmd - terraform show -json | jq -r '.values.root_module.resources[0].values.http_clone_url'