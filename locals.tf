locals {
  # Terraform organization
  organization = "Digilerz-Org"

  # Terraform workspace list
  workspaces_1 = "ws-va-aws-addon-dev-networking"
  workspaces_2 = "ws-va-aws-d0001-dev-digilerz"
  workspaces_3 = "ws-vb-aws-d0001-dev-digilerz"

  # Common tags for all resources
  namespace   = "digilerz"
  environment = "dev"
  tags        = "${local.namespace}-${local.environment}"

  # # KMS keys
  # kms_ebs_key = 
  # kms_s3_key = 

  # Subnets
  instance_subnet_1 = "aws_subnet.subnet1.id"
  instance_subnet_2 = "aws_subnet.subnet2.id"

  #Keypairs
  instance_ED25519_keypair = "aws_key_pair.key121.key_name"
}
