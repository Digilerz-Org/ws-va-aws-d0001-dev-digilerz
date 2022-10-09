
variable "instance_type" {
  type        = string
  description = "Type for EC2 Instance"
  default     = "t2.micro"
}

#DATA
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  user_data              = file("user-data/user_data-nginx-1.sh")
  tags                   = local.common_tags
  # tags = {
  # 	Name = "nginx1"
  # }
  # key_name               = "${var.key_name}"
  depends_on = [aws_vpc.vpc]
}
/*
resource "aws_instance" "nginx2" {
  # ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  ami                    = "ami-0851b76e8b1bce90b"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  user_data              = file("user-data/user_data-nginx-2.sh")
  tags                   = local.common_tags
  depends_on             = [aws_vpc.vpc]
}
*/