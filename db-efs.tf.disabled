####################################################################
################################EFS#################################
####################################################################
resource "aws_efs_file_system" "db_efs" {
  creation_token = "${local.environment}-db-efs"
  encrypted      = false
  # kms_key_id     = local.kms_ebs_key
  tags = {
    Name        = "${local.namespace}-efs"
    Environment = local.environment
  }
  depends_on = [aws_instance.dev_instance]
}

resource "aws_efs_mount_target" "efs_mount_trgt_2a" {
  file_system_id  = aws_efs_file_system.db_efs.id
  subnet_id       = aws_subnet.subnet1.id
  security_groups = [aws_security_group.db_efs_security_group.id]
}

#resource "aws_efs_mount_target" "efs_mount_trgt_2b" {
#  file_system_id  = aws_efs_file_system.db_efs.id
#  subnet_id       = aws_subnet.subnet2.id
#  security_groups = [aws_security_group.db_efs_security_group.id]
#}



###############################Ouptput#################################

output "db_efs_ip_2a" {
  value = aws_efs_mount_target.efs_mount_trgt_2a.ip_address
}

#output "db_efs_ip_1b" {
#  value = aws_efs_mount_target.efs_mount_trgt_2b.ip_address
#}

output "file_system_dns_name" {
  value = aws_efs_file_system.db_efs.dns_name
}

output "file_system_arn" {
  value = aws_efs_file_system.db_efs.arn
}
