##################################################################################
# SECURITY GROUPS
##################################################################################
resource "aws_security_group" "nginx-2-sg" {
  name        = "${local.environment}-instance-SG"
  description = "security group for instance"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name        = "${local.namespace}-instance-SG"
    Environment = local.environment
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
