output "public_ip" {
  value = aws_instance.vault-server.public_ip
}

output username {
value = "${data.vault_generic_secret.secret.data["username"]}"
}

output password {
value = "${data.vault_generic_secret.secret.data["password"]}"
}