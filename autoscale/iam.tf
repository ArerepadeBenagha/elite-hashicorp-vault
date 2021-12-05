#IAM
resource "aws_iam_role" "nginx_role" {
  name = join("-", [local.application.app_name, "nginxrole"])

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(local.common_tags,
    { Name = "nginxserver"
  Role = "nginxrole" })
}

#######------- IAM Role ------######
resource "aws_iam_role_policy" "nginx_policy" {
  name = join("-", [local.application.app_name, "nginxpolicy"])
  role = aws_iam_role.nginx_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}