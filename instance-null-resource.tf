###############Null resources#################
resource "null_resource" "copy_null_resource" {
  triggers = {
    ec2_instance_ids = aws_instance.dev_instance.id
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.dev_instance.public_ip
    private_key = file("instance_keypair/myterrakey.pem")
    # private_key = tls_private_key.oskey.private_key_pem
    timeout     = "4m"
  }

  provisioner "file" {
    source      = "./documents"
    destination = "/home/ubuntu/"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo mkdir /home/ubuntu/project",
  #     # "chmod +x /home/ubuntu/project",
  #     "sudo cd /home/ubuntu/project/",
  #     "sudo git clone https://github.com/Digilerz-Org/ws-va-aws-d0001-dev-digilerz.git"
  #   ]
  # }
}



/*
###############EBS Mount file -  Null resources#################
#Null Resources
resource "null_resource" "dev_instance_ebs_null_resource" {
  triggers = {
    ec2_instance_ids = aws_instance.dev_instance.id
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.dev_instance.private_ip
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
      "sudo /home/ubuntu/ebs.sh ${aws_ebs_volume.ebs_volume.id} /home/ubuntu/"
    ]
  }
  depends_on = [aws_instance.dev_instance, aws_volume_attachment.ebs_attach]
}*/



/*
###############Script Swap file -  Null resources#################
resource "null_resource" "dev_instance_null_swap_memory" { 
  triggers = {
    ec2_instance_ids = aws_instance.dev_instance.this_id
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.dev_instance.this_private_ip
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
      "sudo  /home/ec2-user/swap_memory_file.sh ${aws_ebs_volume.ebs_volume.id} swap"
    ]
  }
}
*/



/*
###############Ansible All Files -  Null resources#################
resource "null_resource" "dev_instance_null_resource" {
  depends_on = [aws_instance.dev_instance, aws_ebs_volume.ebs_volume]
  triggers = {
    ec2_instance_ids = aws_instance.dev_instance.this_id
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.dev_instance.this_private_ip
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
      #"ansible-playbook --extra-vars='{ dnshostname : ${var.dev_instance_hostname}.${local.dns_suffix} }' --connection=local --inventory 127.0.0.1, ~/ansible-scripts/ansible-rhel79/ansible-rhel79.yml"      
    ]
  }
}*/



/*
###############Ansible - EFS Null resources#################
resource "null_resource" "dev_instance_null_resource_efs" {
  triggers = {
    ec2_instance_ids = aws_instance.dev_instance.id
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.dev_instance.public_ip
    private_key = file("./instance_keypair/myterrakey.pem")
    timeout     = "4m"
  }

  provisioner "file" {
    source      = "./script-files/efs.yaml"
    destination = "/home/ubuntu/efs.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      " export ANSIBLE_HOST_KEY_CHECKING=False",
      " ansible-playbook --extra-vars='{ efs_file_system_id : ${aws_efs_mount_target.efs_mount_trgt_2a.ip_address}, efs_mount_dir : /efs }'  --connection=local --inventory 127.0.0.1, /home/ubuntu/efs.yaml "
    ]
  }
  depends_on = [tls_private_key.oskey, aws_instance.dev_instance, aws_efs_file_system.db_efs]
}
*/
