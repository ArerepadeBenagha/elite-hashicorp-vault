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
# data "cloudinit_config" "userdata" {
#   gzip          = true
#   base64_encode = true

#   part {
#     content_type = "text/x-shellscript"
#     filename     = "userdata_docker"
#     content = templatefile("../templates/userdata_vault.tpl",
#       {
#         # localhost=aws_instance.vault-server.public_ip
#       }
#     )
#   }
# }

data "template_file" "userdata_vault" {
  template = file("${path.module}/userdata_vault.tpl")
  vars = {
    localhost = "${aws_instance.vault-server.public_ip}"
  }
}