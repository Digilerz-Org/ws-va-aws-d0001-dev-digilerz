variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Key"
}

variable "AWS_REGION" {
  type        = string
  description = "Region for AWS Resources"
  default     = "ap-south-1"
}

# variable "shared_cred_file" {
#  default = "/home/tf_user/.aws/credentials"
# }


##################################################################################
# PROVIDERS
##################################################################################
provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.AWS_REGION
  # shared_credentials_file = "${var.shared_cred_file}"
  # profile = "customprofile"  
}


