output "vpc_id" {
  description = "id vpc"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "id subnetu"
  value       = aws_subnet.subnet.id
}