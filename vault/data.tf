data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
#Userdata
data "cloudinit_config" "userdata" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    filename     = "userdata_vault"
    content      = templatefile("../templates/userdata_vault.tpl", {})
  }
}

# data "vault_generic_secret" "secret" {
#   path = "kv/secret"
# }