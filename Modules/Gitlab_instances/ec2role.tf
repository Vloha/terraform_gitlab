
resource "aws_iam_role" "ec2_role_s3" {
    name = "ec2_role_s3"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    } 
  ]
}
EOF
}
resource "aws_iam_instance_profile" "s3_for_ec2" {
    name = "s3_for_ec2"
    role = aws_iam_role.ec2_role_s3.name
}
resource "aws_iam_role_policy" "s3_ReadWrite_policy" {
  name = "s3_ReadWrite_policy"
  role = "${aws_iam_role.ec2_role_s3.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.Vbucket.arn}"
            ]
        },
        {
            "Sid": "DeleteBucket",
            "Effect": "Allow",
            "Action": [
                "s3:DeleteBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.Vbucket.arn}"
            ]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "${aws_s3_bucket.Vbucket.arn}/*"
            ]
        }
    ]
}
EOF
}