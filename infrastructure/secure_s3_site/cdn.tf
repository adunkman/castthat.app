resource "aws_cloudfront_distribution" "redirect_all_requests_to_www" {
  origin {
    domain_name = "${aws_s3_bucket.redirect_all_requests_to_www.website_endpoint}"
    origin_id = "${aws_s3_bucket.redirect_all_requests_to_www.arn}"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  aliases = ["${var.domain}"]
  enabled = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    viewer_protocol_policy = "allow-all"
    compress = true

    target_origin_id = "${aws_s3_bucket.redirect_all_requests_to_www.arn}"

    forwarded_values {
      query_string = false
      headers = ["Origin"]

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  tags {
    app = "${var.domain}"
  }
}

resource "aws_cloudfront_distribution" "static_host_bucket" {
  origin {
    domain_name = "${aws_s3_bucket.static_host_bucket.website_endpoint}"
    origin_id = "${aws_s3_bucket.static_host_bucket.arn}"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  aliases = ["www.${var.domain}"]
  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    compress = true

    target_origin_id = "${aws_s3_bucket.static_host_bucket.arn}"

    forwarded_values {
      query_string = false
      headers = ["Origin"]

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  tags {
    app = "${var.domain}"
  }
}
