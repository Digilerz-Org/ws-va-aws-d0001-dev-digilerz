# Security Group for EFS
resource "aws_security_group" "db_efs_security_group" {
  description = "security group for nginx2-efs"
  vpc_id      = aws_vpc.vpc.id
  name        = "${local.namespace}-efs-security-group"

  # to allow the traffic from the bastions

  ingress {
    description     = "Open port for Network File System"
    security_groups = [aws_security_group.nginx-2-sg.id]
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
  }

  egress {
    description     = "Allow outbound communication for EFS"
    security_groups = [aws_security_group.nginx-2-sg.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  ingress {
    description = "Allow inbound communication for EFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound communication for EFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { "Name" = "${local.namespace}-efs-security-group" }

}
