
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
  tags = {
    Name = "nginx1"
  }
  depends_on = [aws_vpc.vpc]
}
