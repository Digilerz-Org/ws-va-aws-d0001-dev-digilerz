# variable "kp_pem_file" {
#  default = "/home/downloads/myterrakey.pem"
# }

resource "tls_private_key" "oskey" {
  algorithm = "RSA"
}

resource "local_file" "myterrakey" {
  content  = tls_private_key.oskey.private_key_pem
  filename = "./instance_keypair/myterrakey.pem"
}

data "archive_file" "backup" {
  type = "zip"
  # source_file = "./instance_keypair/myterrakey.pem"
  source_file = tls_private_key.oskey.private_key_pem
  output_path = "${path.module}/archives/backup.zip"
}

resource "aws_key_pair" "key121" {
  key_name   = "myterrakey"
  public_key = tls_private_key.oskey.public_key_openssh
  #   public_key = "${var.kp_pem_file}"

  #   # Create a "myKey.pem" to your computer!! (change to chmod 400 myKey.pem for ssh)
  #   provisioner "local-exec" {
  #     command = "echo '${tls_private_key.oskey.private_key_pem}' > ./myterrakey.pem"
  #   }  
}

/*
resource "aws_instance" "mytfinstance" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key121.key_name

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh"
    ]
  }

  connection {
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = tls_private_key.oskey.private_key_pem
    host        = aws_instance.mytfinstance.public_ip
  }
}
*/
