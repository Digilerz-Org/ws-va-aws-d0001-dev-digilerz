# variable "kp_pem_file" {
#  default = "/home/downloads/myterrakey.pem"
# }

resource "tls_private_key" "oskey" {
  # algorithm = "RSA"
  # rsa_bits = 4096
  algorithm = "ED25519"
}

resource "local_file" "myterrakey" {
  content  = tls_private_key.oskey.private_key_pem
  filename = "./instance_keypair/myterrakey.pem"
}

# data "archive_file" "backup" {
#   type = "zip"
#   # source_file = "./instance_keypair/myterrakey.pem"
#   # source_file = tls_private_key.oskey.private_key_pem
#   output_path = "${path.module}/archives/backup.zip"
# }

resource "aws_key_pair" "key121" {
  key_name   = "myterrakey"
  public_key = tls_private_key.oskey.public_key_openssh
  #   public_key = "${var.kp_pem_file}"

  # Create a "myterrakey.pem" to your computer!! (change to chmod 400 myKey.pem for ssh)
  provisioner "local-exec" {
    command = "echo '${tls_private_key.oskey.private_key_pem}' > ./instance_keypair/myterrakey.pem"
  }
}

