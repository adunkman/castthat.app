resource "aws_route53_record" "keybase_verification" {
  zone_id = "${var.hosted_zone_id}"
  name = "${var.domain}"
  type = "TXT"
  ttl = "3600"
  records = [ "keybase-site-verification=${var.key}" ]
}
