variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true
}

variable "AWS_REGION" {
  type        = string
  description = "Region for AWS Resources"
  default     = "ap-south-1"
}


##################################################################################
# PROVIDERS
##################################################################################
provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.AWS_REGION
}
