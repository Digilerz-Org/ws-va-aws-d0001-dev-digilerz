variable "db_efs_name" {
  description = "name of the elastic file system"
  default     = "db_efs"
}

resource "aws_efs_file_system" "db_efs" {
  creation_token = var.db_efs_name
  encrypted      = false
  #   kms_key_id     = local.ebs_key
  tags = {
    Name        = "nginx2-efs"
    Environment = "dev"
  }
  depends_on = [aws_instance.nginx2]
}

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
    description = "Allow outbound communication for EFS"
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

resource "aws_efs_mount_target" "efs_mount_trgt_2a" {
  file_system_id  = aws_efs_file_system.db_efs.id
  subnet_id       = aws_subnet.subnet1.id
  security_groups = [aws_security_group.db_efs_security_group.id]
}

output "db_efs_ip_2a" {
  value = aws_efs_mount_target.efs_mount_trgt_2a.ip_address
}

#resource "aws_efs_mount_target" "efs_mount_trgt_2a_2b" {
#  file_system_id  = aws_efs_file_system.db_efs.id
#  subnet_id       = aws_subnet.subnet2.id
#  security_groups = [aws_security_group.db_efs_security_group.id]
#}
#
#output "db_efs_ip_1b" {
#  value = aws_efs_mount_target.efs_mount_trgt_2a_2b.ip_address
#}
#
output "file_system_dns_name" {
  value = aws_efs_file_system.db_efs.dns_name
}

output "file_system_arn" {
  value = aws_efs_file_system.db_efs.arn
}
