resource "aws_route53_record" "vaultzone_record" {
  for_each = {
    for dvo in aws_acm_certificate.vaultcert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main-zone.zone_id
}

##------- ALB Alias record ----------##
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main-zone.zone_id
  name    = "elite-vaultdev.elietesolutionsit.de"
  type    = "A"

  alias {
    name                   = aws_lb.vault.dns_name
    zone_id                = aws_lb.vault.zone_id
    evaluate_target_health = true
  }
}