# ###-------- ALB -------###
# resource "aws_lb" "nginx" {
#   name               = join("-", [local.application.app_name, "nginxb"])
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.main-alb.id]
#   subnets            = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
#   idle_timeout       = "60"

#   access_logs {
#     bucket  = aws_s3_bucket.logs_s3dev.bucket
#     prefix  = join("-", [local.application.app_name, "nginxb-s3logs"])
#     enabled = true
#   }
#   tags = merge(local.common_tags,
#     { Name = "nginxserver"
#   Application = "public" })
# }
# ###------- ALB Health Check -------###
# resource "aws_lb_target_group" "nginxapp_tglb" {
#   name     = join("-", [local.application.app_name, "nginxapptglb"])
#   port     = 8200
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id

#   health_check {
#     path                = "/"
#     port                = "traffic-port"
#     protocol            = "HTTP"
#     healthy_threshold   = "5"
#     unhealthy_threshold = "2"
#     timeout             = "5"
#     interval            = "30"
#     matcher             = "200,307"
#   }
# }
# resource "aws_lb_target_group_attachment" "nginx_tg" {
#   target_group_arn = aws_lb_target_group.nginxapp_tglb.arn
#   target_id        = aws_instance.nginx-server.id
#   port             = 8200
# }
# ####---- Redirect Rule -----####
# resource "aws_lb_listener" "nginx_listA" {
#   load_balancer_arn = aws_lb.nginx.arn
#   port              = "8200"
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"
#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }
# ####-------- SSL Cert ------#####
# resource "aws_lb_listener" "nginx_listB" {
#   load_balancer_arn = aws_lb.nginx.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
#   certificate_arn   = "arn:aws:acm:us-east-1:901445516958:certificate/8c77b4a6-4350-40cb-84c2-c5ac1119c4bf"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.nginxapp_tglb.arn
#   }
# }