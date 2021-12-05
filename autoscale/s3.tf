# ########------- S3 Bucket -----------####
# resource "aws_s3_bucket" "logs_s3dev" {
#   bucket = join("-", [local.application.app_name, "logdev"])
#   acl    = "private"

#   tags = merge(local.common_tags,
#     { Name = "vaultserver"
#   bucket = "private" })
# }
# resource "aws_s3_bucket_policy" "logs_s3dev" {
#   bucket = aws_s3_bucket.logs_s3dev.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Id      = "MYBUCKETPOLICY"
#     Statement = [
#       {
#         Sid       = "Allow"
#         Effect    = "Allow"
#         Principal = "*"
#         Action    = "s3:*"
#         Resource = [
#           aws_s3_bucket.logs_s3dev.arn,
#           "${aws_s3_bucket.logs_s3dev.arn}/*",
#         ]
#         Condition = {
#           NotIpAddress = {
#             "aws:SourceIp" = "8.8.8.8/32"
#           }
#         }
#       },
#     ]
#   })
# }