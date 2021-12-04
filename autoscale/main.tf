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
  key_name        = aws_key_pair.mykeypair.key_name
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
  default_cooldown     = "30"

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_policy" "autoscale_policy" {
  name                   = join("-", [local.application.app_name, "elite-scalepolicy"])
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.elite_autoscale.name
}
# Vars.tf
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "main"
  }
}

# Subnets
resource "aws_subnet" "main-public-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Main-public-1"
  }
}
resource "aws_subnet" "main-public-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "Main-public-2"
  }
}
resource "aws_subnet" "main-public-3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "Main-public-3"
  }
}
resource "aws_subnet" "main-private-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Main-private-1"
  }
}
resource "aws_subnet" "main-private-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "Main-private-2"
  }
}
resource "aws_subnet" "main-private-3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "Main-private-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# route tables
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "main-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.main-public-1.id
  route_table_id = aws_route_table.main-public.id
}
resource "aws_route_table_association" "main-public-2-a" {
  subnet_id      = aws_subnet.main-public-2.id
  route_table_id = aws_route_table.main-public.id
}
resource "aws_route_table_association" "main-public-3-a" {
  subnet_id      = aws_subnet.main-public-3.id
  route_table_id = aws_route_table.main-public.id
}
