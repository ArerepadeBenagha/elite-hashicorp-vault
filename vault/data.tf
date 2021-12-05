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
    filename     = "userdata_docker"
    content      = templatefile("../templates/userdata_vault.tpl", {})
  }
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    echo 'localhost="${aws_instance.vault-server.public_ip}"' > /opt/server_ip
    EOF
  }
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.client.rendered
  }
}

data "template_file" "client" {
  template = file("../templates/userdata_ip.sh")
}