output "EC2_public_ip" {
  value = aws_instance.nginx.public_ip
}