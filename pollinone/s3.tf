resource "aws_s3_bucket" "react-static" {
  bucket = "clientpoll"
}

resource "aws_s3_bucket_website_configuration" "react-static" {
  bucket = "clientpoll"

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}

resource "aws_s3_bucket_cors_configuration" "react-static" {
  bucket = "clientpoll"
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "POST", "PUT", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = []
  }
}

resource "aws_s3_bucket" "cloudfront-logs" {
  bucket = "clientpoll-cloudfront-logs"
}
