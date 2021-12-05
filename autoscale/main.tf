resource "aws_launch_configuration" "elite_conf" {
  name_prefix      = join("-", [local.application.app_name, "elite-scalevm"])
  image_id         = data.aws_ami.ubuntu.id
  instance_type    = var.instance_type
  key_name         = aws_key_pair.mykeypair.key_name
  security_groups  = [aws_security_group.ec2-sg.id, aws_security_group.main-alb.id]
  user_data_base64 = data.cloudinit_config.userdata.rendered

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
  min_size             = 2
  max_size             = 4
  health_check_type    = "ELB"
  force_delete         = true
  default_cooldown     = "60"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm" {
  alarm_name          = join("-", [local.application.app_name, "elitedev-cpu-alarm"])
  alarm_description   = "example-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.elite_autoscale.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.elite-autoscalepolicy.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "elite-autoscalepolicy-scaledown" {
  name                   = join("-", [local.application.app_name, "elitedev-scaledown"])
  autoscaling_group_name = aws_autoscaling_group.elite_autoscale.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm-scaledown" {
  alarm_name          = join("-", [local.application.app_name, "elitedev-metricalarm"])
  alarm_description   = "example-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.elite_autoscale.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.elite-autoscalepolicy-scaledown.arn]
}
