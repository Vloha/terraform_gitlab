resource "aws_s3_bucket" "Vbucket" {
  bucket = "gitlab.runner-token"
  force_destroy = true
  tags = {
    Name = "gitlab.runner-token"
  }
}
resource "aws_s3_bucket_acl" "private" {
  bucket = aws_s3_bucket.Vbucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_disabled" {
  bucket = aws_s3_bucket.Vbucket.id
  versioning_configuration {
    status = "Disabled"
  }
}