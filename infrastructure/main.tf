terraform {
  backend "s3" {
    bucket = "infrastructure.castthat.app"
    key = "terraform"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_route53_zone" "primary" {
  name = "${var.domain}"

  tags {
    app = "${var.domain}"
  }
}

resource "aws_inspector_resource_group" "application" {
  tags = {
    app = "${var.domain}"
  }
}

module "keybase_verification" {
  source = "keybase_verification"
  hosted_zone_id = "${aws_route53_zone.primary.zone_id}"
  key = "${var.keybase_verification_key}"
  domain = "${var.domain}"
}

module "secure_s3_site" {
  source = "secure_s3_site"
  hosted_zone_id = "${aws_route53_zone.primary.zone_id}"
  domain = "${var.domain}"
  region = "${var.aws_region}"
}
