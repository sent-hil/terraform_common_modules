output "private_subnet_id_1" {
  value = aws_subnet.private_subnet[0].id
}

output "private_subnet_id_2" {
  value = aws_subnet.private_subnet[1].id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.public_subnet.cidr_block
}
