output "public_ip" {
  value = aws_instance.vault-server.public_ip
}

output "username" {
  value     = data.vault_generic_secret.secret.data["username"]
  sensitive = true
}

output "password" {
  value     = data.vault_generic_secret.secret.data["password"]
  sensitive = true
}

output "public_key" {
  value     = data.vault_generic_secret.secret.data["public_key"]
  sensitive = true
}
