
locals {
  instance_user_name = "ubuntu"

}


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

# #Data block for AMI ID
# data "aws_ssm_parameter" "ami" {
#   name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
# }

# INSTANCES
resource "aws_instance" "nginx2" {
  # ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  ami                    = var.nginx2_instance_ami
  instance_type          = var.nginx2_instance_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx-2-sg.id]
  user_data              = file("user-data-ubuntu/ubuntu-installation.sh")
  key_name               = aws_key_pair.key121.key_name
  # dns_hostnames          = ["${var.nginx2_hostname}.${local.dns_suffix}"]

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

  # provisioner "remote-exec" {
  #   inline = [
  #     "rm -rf ~/home/ubuntu/script-files",
  #     # "mkdir -p ~/script-files"
  #   ]
  # }  

  provisioner "file" {
    # source      = "./script-files"
    # destination = "/home/ubuntu/
    source      = "./script-files/efs.yaml"
    destination = "/home/ubuntu/efs.yaml"
  }

  provisioner "local-exec" {
    command = [
      # "chmod +x /home/ubuntu/ebs.sh",
      # "sleep 3m",
      # "sudo /home/ubuntu/ebs.sh ${aws_ebs_volume.volume.id} /home/ubuntu/",
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      "ansible-playbook --extra-vars='{ efs_file_system_id : ${aws_efs_mount_target.efs_mount_trgt_2a.ip_address}, efs_mount_dir : /efs }'  --connection=local --inventory 127.0.0.1, /home/ubuntu/efs.yaml "
    ]
  }

  tags = {
    Name        = "nginx2"
    Environment = "dev"
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

/*
#Null Resources
resource "null_resource" "nginx2_ebs_null_resource" {
  triggers = {
    ec2_instance_ids = aws_instance.nginx2.id
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.nginx2.private_ip
    private_key = tls_private_key.oskey.private_key_pem
  }

  # Create mount point for server from /dev/sdf device to /was
  provisioner "file" {
    source      = "./script-files/ebs.sh"
    destination = "/home/ubuntu/ebs.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/ebs.sh",
      "sleep 3m",
      "sudo /home/ubuntu/ebs.sh ${aws_ebs_volume.volume.id} /home/ubuntu/"
    ]
  }
  depends_on = [aws_instance.nginx2, aws_volume_attachment.ebsAttach]
}


resource "null_resource" "nginx2_null_resource_efs" {
  triggers = {
    ec2_instance_ids = aws_instance.nginx2.id
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.nginx2.private_ip
    private_key = tls_private_key.oskey.private_key_pem
  }

  provisioner "file" {
    source      = "./ansible-aws/efs.yaml"
    destination = "/home/ubuntu/efs.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      " export ANSIBLE_HOST_KEY_CHECKING=False",
      " ansible-playbook --extra-vars='{ efs_file_system_id : ${aws_efs_mount_target.efs_mount_trgt_2a.ip_address}, efs_mount_dir : /efs }'  --connection=local --inventory 127.0.0.1, /home/ubuntu/efs.yaml "
    ]
  }
  depends_on = [tls_private_key.oskey, aws_instance.nginx2, aws_efs_file_system.db_efs]
}
*/


##################################OUTPUT#########################################

output "instance-id" {
  value       = "ID of the Instance -> ${aws_instance.nginx2.id}"
  description = "ID of Instance"
}

output "instance-private-ip" {
  value       = aws_instance.nginx2.private_ip
  description = "Private IP address of instance for route53 DNS record"
}

output "instance-az" {
  value       = "Instance is Launcher -> ${aws_instance.nginx2.availability_zone}"
  description = "AZ of Instance"
}

output "instance-root-volume-id" {
  value       = aws_instance.nginx2.root_block_device.*.volume_id
  description = "root-volume-id"
}

output "instance-ebs-volume-id" {
  value       = aws_instance.nginx2.ebs_block_device.*.volume_id
  description = "ebs-volume-id"
}

output "ebs-volume-az" {
  value       = "AZ of volume -> ${aws_ebs_volume.volume.availability_zone}"
  description = "AZ of EBS VOLUME"
}

output "ebs-volume-id" {
  value       = "ID of Volume -> ${aws_ebs_volume.volume.id}"
  description = "ID of EBS VOLUME"
}

