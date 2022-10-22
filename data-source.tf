/*
# example one: Data block for AMI ID
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}
*/

/*
# Output using data block --> keeping this for example purpose only
data "aws_ebs_volume" "ebs_volume" {
  most_recent = true
  filter {
    name   = "attachment.instance-id"
    values = ["${aws_instance.nginx2.id}"]
  }
}
output "ebs-volume-id-example-output" {
  value = "${data.aws_ebs_volume.ebs_volume.id}"
}
*/