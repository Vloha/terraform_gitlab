resource "aws_security_group" "Runnersg" {
    name = "Runner_access"
    vpc_id = var.vpc_id
    ingress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["${var.Bastion_runner_privateIP}/32"]
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Runner_access"
    }
}
data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"]
}

resource "aws_instance" "Runner" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.medium"
    key_name = "Vgitlab"
    iam_instance_profile = aws_iam_instance_profile.s3_for_ec2.name
    vpc_security_group_ids = [aws_security_group.Runnersg.id]
    subnet_id = var.private_runner_subnet_id
    user_data = templatefile("${path.module}/runner.sh.tftpl", {s3bucket_name = aws_s3_bucket.Vbucket.bucket, ip = aws_instance.Gitlab.private_ip})
    tags = {
        Name = "Runner"
    }
    depends_on = [aws_s3_bucket.Vbucket]
}