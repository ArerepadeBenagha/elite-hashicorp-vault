output "instance" {
  value = aws_instance.rds-server.public_ip
}

output "rds" {
  value = aws_db_instance.mysql.endpoint
}