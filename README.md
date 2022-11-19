###############Terraform commands for Developer###############
terraform init
terraform plan
terraform apply
terraform destroy
##############################END#############################


##########################SSH client##########################
1. Open an SSH client.
2. Locate your private key file. The key used to launch this instance is myterrakey.pem
3. Run this command, if necessary, to ensure your key is not publicly viewable.
   chmod 400 myterrakey.pem
4. Connect to your instance using its Public DNS:
   Example: ec2-15-206-146-8.ap-south-1.compute.amazonaws.com

Example: ssh -i "developer/developer_key.pem" ubuntu@ec2-15-206-146-8.ap-south-1.compute.amazonaws.com
##############################END##############################
