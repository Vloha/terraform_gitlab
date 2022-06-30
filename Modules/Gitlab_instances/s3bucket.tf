resource "aws_s3_bucket" "Vbucket" {
  bucket = "*"
  force_destroy = true
  tags = {
    Name = "*"
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
