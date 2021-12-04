data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "elite_conf" {
  name_prefix     = join("-", [local.application.app_name, "elite-scalevm"])
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t3.large"
  key_name        = aws_key_pair.mykeypair.name
  security_groups = [aws_security_group.ec2-sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhD5ucWIfFwBeOm9WcbYBPCqf/Ut7rKfwbHL6XRX3QRz8Tfm621iEHdl+XkF2g/Sef4Nk0pSGE3in0mwyEzILAHviu82YEcH8a6HiHVIfPrdo3s55p6RupaBmIXvZohkqKhLMLFgZoPWFMQS9uGr6vQM5HK91XILtOmKpLnTre/JbTxhq1cqzQLPwROJ2mx8IWf4w1KI6ZIFQkuIB4xugQNOG/PCiUx5D+N4u5HrMq4sTMW3lcUtbUUNAvHYdw9AaSwnPPTnsmPHAOS84fmd96T2I0H0DclTzMgWvchKiEK/oSzYKcT6GZysCnIlWmJIFm8sgfwiT+T4ya+WkW3bTnkZeCxNLUVl+6TDAgGlIMq1i2NicB5kZzM7CMB/hlLZzJ8WZQdlhrVOSUyZYeXzdxeW//SJ0N1z3HO58nLHL8Wg71wjSS+d39zUdVQy+Ew2UF6aMPOrzKyK4FKTqu0iFkKpRbI89J9dWRU7/vesgyKUOtQCVh0Vloq3KfYju/Nm8= lbena@LAPTOP-QB0DU4OG"
}

resource "aws_autoscaling_group" "elite_autoscale" {
  name                 = join("-", [local.application.app_name, "elite-scalegroup"])
  launch_configuration = aws_launch_configuration.elite_conf.name
  vpc_zone_identifier  = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  min_size             = 1
  max_size             = 2
  health_check_type    = "ELB"
  force_delete         = true

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_policy" "autoscale_policy" {
  name                   = join("-", [local.application.app_name, "elite-scalepolicy"])
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.autoscale_policy.name
}
