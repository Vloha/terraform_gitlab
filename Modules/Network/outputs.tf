output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The id of the VPC"
}

output "PublicBsubnet" {
  value       = aws_subnet.public2.id
  description = "BastionSubnet"
}
output "PublicGsubnet" {
  value       = aws_subnet.public.id
  description = "GitlabSubnet"
}
output "PrivateSubnetRunner" {
  value       = aws_subnet.private2.id
  description = "RunnerSubnet"
}
