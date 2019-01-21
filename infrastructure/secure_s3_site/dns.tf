resource "aws_route53_record" "primary" {
  zone_id = "${var.hosted_zone_id}"
  name = "${var.domain}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.redirect_all_requests_to_www.domain_name}"
    zone_id = "${aws_cloudfront_distribution.redirect_all_requests_to_www.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${var.hosted_zone_id}"
  name = "www.${var.domain}"
  type = "CNAME"
  ttl = "3600"
  records = ["${aws_cloudfront_distribution.static_host_bucket.domain_name}"]
}
