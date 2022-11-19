
locals {
  instance_resource_name = "${local.environment}_instance" #this is not given in any where
  instance_user_name     = "ubuntu"                        #this is not given in any where
  instance_sg            = aws_security_group.nginx-2-sg.id
}


variable "instance_type" {
  type        = string
  description = "Type for EC2 Instance"
  default     = "t2.micro"
}

variable "instance_ami" {
  type        = string
  description = "Ubuntu Server 22.04 LTS (HVM) SSD Volume Type"
  default     = "ami-062df10d14676e201"
}


####################################################################
#############################INSTANCES##############################
####################################################################
resource "aws_instance" "dev_instance" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = local.instance_subnet_1
  vpc_security_group_ids = [local.instance_sg]
  user_data              = file("user-data-ubuntu/ubuntu-installation.sh")
  # key_name               = local.instance_ED25519_keypair
  key_name               = "developer_key"

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    # kms_key_id            = local.kms_ebs_key
    volume_size = 30
    volume_type = "standard"
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 100
    volume_type = "standard"
    encrypted   = false
    # kms_key_id            = local.kms_ebs_key
    delete_on_termination = true
  }

  tags = {
    Name        = "${local.namespace}-instance"
    Environment = local.environment
  }

  depends_on = [aws_vpc.vpc, tls_private_key.oskey]
}



################################OUTPUT######################################

output "instance-id" {
  value       = "ID of the Instance -> ${aws_instance.dev_instance.id}"
  description = "ID of Instance"
}

output "instance-private-ip" {
  value       = aws_instance.dev_instance.private_ip
  description = "Private IP address of instance for route53 DNS record"
}

output "instance-az" {
  value       = "Instance is Launcher -> ${aws_instance.dev_instance.availability_zone}"
  description = "AZ of Instance"
}

output "instance-root-volume-id" {
  value       = aws_instance.dev_instance.root_block_device.*.volume_id
  description = "root-volume-id"
}

output "instance-ebs-volume-id" {
  value       = aws_instance.dev_instance.ebs_block_device.*.volume_id
  description = "ebs-volume-id"
}


