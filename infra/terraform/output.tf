output "ec2_public_ip" {
  description = "Public IP of the Ubuntu EC2 instance"
  value       = aws_instance.ec2.public_ip
}
