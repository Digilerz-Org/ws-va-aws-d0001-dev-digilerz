
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
resource "null_resource" "nginx2_null_resource" {
  depends_on = [aws_instance.nginx2, aws_ebs_volume.volume]
  triggers = {
    ec2_instance_ids = aws_instance.nginx2.this_id
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.nginx2.this_private_ip
    private_key = tls_private_key.oskey.private_key_pem
  }

  # Create directory to copy files on to cohost instance
  provisioner "remote-exec" {
    inline = [
      "rm -rf ~/ansible-scripts;mkdir -p ~/ansible-scripts",
    ]
  }

  # Copy ansible files to cohost instance
  provisioner "file" {
    source      = "./ansible-scripts"
    destination = "~/ansible-scripts"
  }

  # Run commands on bastion instances
  provisioner "remote-exec" {
    inline = [
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      "ansible-playbook  --connection=local --inventory 127.0.0.1, ~/ansible-scripts/ansible-main.yml"
      #"ansible-playbook --extra-vars='{ dnshostname : ${var.nginx2_hostname}.${local.dns_suffix} }' --connection=local --inventory 127.0.0.1, ~/ansible-scripts/ansible-rhel79/ansible-rhel79.yml"      
    ]
  }
}*/

/*
resource "null_resource" "nginx2_ebs_null_resource" {
  triggers = {
    ec2_instance_ids = aws_instance.nginx2.this_id
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.nginx2.this_private_ip
    private_key = tls_private_key.oskey.private_key_pem
  }

  # Create mount point for server from /dev/sdf device to /was
  provisioner "file" {
    source      = "./script-files/ebs.sh"
    destination = "/home/ec2-user/ebs.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/ebs.sh",
      "sleep 3m",
      "sudo /home/ec2-user/ebs.sh ${aws_ebs_volume.volume.id} /was"
    ]
  }
  depends_on = [aws_instance.nginx2]
}
*/
/*
resource "null_resource" "nginx2_null_swap_memory" { 
  triggers = {
    ec2_instance_ids = aws_instance.nginx2.this_id
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.nginx2.this_private_ip
    private_key = tls_private_key.oskey.private_key_pem
  }

  ## Add swapmemory to the instance
  provisioner "file" {
    source      = "./script-files/swap_memory_file.sh"
    destination = "/home/ec2-user/swap_memory_file.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/swap_memory_file.sh",
      "sleep 3m",
      "sudo  /home/ec2-user/swap_memory_file.sh ${aws_ebs_volume.volume.id} swap"
    ]
  }
}
*/
resource "null_resource" "nginx2_null_efs" {
  triggers = {
    ec2_instance_ids = aws_instance.nginx2.id
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.nginx2.private_ip
    private_key = tls_private_key.oskey.private_key_pem
  }

  provisioner "file" {
    source      = "./script-files/efs.yaml"
    destination = "/home/ec2-user/efs.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      " export ANSIBLE_HOST_KEY_CHECKING=False",
      " ansible-playbook --extra-vars='{ efs_file_system_id : ${aws_efs_mount_target.efs_mount_trgt_2a.ip_address}, efs_mount_dir : /udb_dba_share }'  --connection=local --inventory 127.0.0.1, /home/ec2-user/efs.yaml "
    ]
  }
  depends_on = [aws_efs_file_system.db_efs]
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
