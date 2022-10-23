#! /bin/bash

rm -rf instance_keypair
rm -rf .terraform
rm -f .terraform.lock.hcl
rm -rf terraform.tfstate*
rm -rf plan-files/myplan-v1.tfplan
terraform fmt