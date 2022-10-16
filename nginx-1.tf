
variable "nginx1_instance_type" {
  type        = string
  description = "Type for EC2 Instance"
  default     = "t2.micro"
}

#DATA
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# INSTANCES
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.nginx1_instance_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx-1-sg.id]
  user_data              = file("user-data/user_data-nginx-1.sh")

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    # kms_key_id            = local.ebs_key
    volume_size = 30
    volume_type = "standard"
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 100
    volume_type = "standard"
    encrypted   = false
    # kms_key_id            = local.ebs_key
    delete_on_termination = true
  }

  tags = {
    Name        = "nginx1"
    Environment = "dev"
  }
  depends_on = [aws_vpc.vpc]
}



######################### Outputs #############################
output "nginx1_private_ip" {
  value       = aws_instance.nginx1.private_ip
  description = "Private IP address of instance for route53 DNS record"
}

# output "nginx1_server_name" {
#   value       = "${var.nginx1_hostname}.${local.dns_suffix}"
#   description = "FQDN for route53 DNS record name"
# }

data "aws_ebs_volume" "ebs_volume" {
  most_recent = true
  filter {
    name   = "attachment.instance-id"
    values = ["${aws_instance.nginx1.id}"]
  }
}
output "ebs_volume_id" {
  value = "${data.aws_ebs_volume.ebs_volume.id}"
}

output "volume-id-root" {
  description = "root volume-id"
  #get the root volume id form the instance
     value       =  element(tolist(data.aws_instance.nginx1.root_block_device.*.volume_id),0)
}

output "volume-id-ebs" {
   description = "ebs-volume-id"
    #get the 1st esb volume id form the instance
        value       =  element(tolist(data.aws_instance.nginx1.ebs_block_device.*.volume_id),0)
}