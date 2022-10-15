
variable "nginx2_instance_type" {
  type        = string
  description = "Type for EC2 Instance"
  default     = "t2.micro"
}

variable "nginx2_instance_ami" {
  type        = string
  description = "Ubuntu Server 22.04 LTS (HVM) SSD Volume Type"
  default     = "ami-062df10d14676e201"
}

# INSTANCES
resource "aws_instance" "nginx2" {
  ami                    = var.nginx2_instance_ami
  instance_type          = var.nginx2_instance_type
  subnet_id              = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx-2-sg.id]
  user_data              = file("user-data/user_data-nginx-2.sh")

  root_block_device = {
    delete_on_termination = true
    encrypted             = false
    # kms_key_id            = local.ebs_key
    volume_size           = 30
    volume_type           = "standard"
  }

  ebs_block_device = {
    ebs_volume_1 = {
      delete_on_termination = true
      device_name           = "/dev/sdf"
      volume_size           = 100
      volume_type           = "standard"
      encrypted             = true
      # kms_key_id            = local.ebs_key
      tags = {
        Name = "nginx2"
      }
    }
  }

  tags = {
    Name = "nginx2"
  }
  depends_on = [aws_vpc.vpc]
}

resource "aws_ebs_volume" "volume" {
  availability_zone = aws_instance.nginx2.availability_zone
  size              = 10
  depends_on        = [aws_vpc.vpc, aws_instance.nginx2]
}

resource "aws_volume_attachment" "ebsAttach" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.volume.id
  instance_id = aws_instance.nginx2.id
  depends_on  = [aws_instance.nginx2, aws_ebs_volume.volume]
}



##################################OUTPUT#########################################
#INSTANCE (Lets Try to fetch the AZ and ID)
output "instanceVal1" {
  value = "Instance is Launcher -> ${aws_instance.nginx2.availability_zone}"
}

output "instanceVal2" {
  value = "ID of the Instance -> ${aws_instance.nginx2.id}"
}

#EBS VOLUME (Lets Try To Print the AZ of volume and ID)
output "volumeVal1" {
  value = "AZ of volume -> ${aws_ebs_volume.volume.availability_zone}"
}

output "volumeVal2" {
  value = "ID of Volume -> ${aws_ebs_volume.volume.id}"
}
