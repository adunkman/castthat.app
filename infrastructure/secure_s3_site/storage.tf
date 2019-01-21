resource "aws_s3_bucket" "redirect_all_requests_to_www" {
  bucket = "${var.domain}"
  acl = "public-read"

  website = {
    redirect_all_requests_to = "https://www.${var.domain}"
  }

  tags {
    app = "${var.domain}"
  }
}

resource "aws_s3_bucket" "static_host_bucket" {
  bucket = "www.${var.domain}"
  acl = "public-read"

  website = {
    index_document = "index.html"
  }

  tags {
    app = "${var.domain}"
  }
}
