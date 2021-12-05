# #####------ Certificate -----------####
# resource "aws_acm_certificate" "vaultcert" {
#   domain_name       = "*.elietesolutionsit.de"
#   validation_method = "DNS"
#   lifecycle {
#     create_before_destroy = true
#   }
#   tags = merge(local.common_tags,
#     { Name = "elite-vaultdev.elietesolutionsit.de"
#   Cert = "vaultcert" })
# }

# ###------- Cert Validation -------###
# data "aws_route53_zone" "main-zone" {
#   name         = "elietesolutionsit.de"
#   private_zone = false
# }

# resource "aws_acm_certificate_validation" "vaultcert" {
#   certificate_arn         = aws_acm_certificate.vaultcert.arn
#   validation_record_fqdns = [for record in aws_route53_record.vaultzone_record : record.fqdn]
# }