output "instance_id" {
  description = "id ec2 instance"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "verejna ip"
  value       = aws_instance.main.public_ip
}