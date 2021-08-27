# vpc

This terraform module:

* Creates VPC
* 2 private subnets (for RDS)
* 1 public subnet (exposed on 0.0.0.0/0)

## Run
$ terraform plan -var-file=development.tfvars

$ terraform apply -var-file=development.tfvars
