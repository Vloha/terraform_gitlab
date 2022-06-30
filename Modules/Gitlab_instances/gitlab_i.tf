module myip {
    source  = "4ops/myip/http"
    version = "1.0.0"
}
resource "aws_security_group" "Gitlabsg" {
    name = "Gitlab_access"
    depends_on = [aws_security_group.Runnersg]
    vpc_id = var.vpc_id
    ingress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["${module.myip.address}/32"]
    }
    ingress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        security_groups  = ["${aws_security_group.Runnersg.id}"]
    }
    ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks  = ["${module.myip.address}/32"]
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Gitlab_access"
    }
}


data "aws_ami" "Gubuntu" {
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
resource "aws_instance" "Gitlab" {
    ami = "${data.aws_ami.Gubuntu.id}"
    instance_type = "t3.xlarge"
    key_name = "Vgitlab"
    iam_instance_profile = aws_iam_instance_profile.s3_for_ec2.name
    vpc_security_group_ids = [aws_security_group.Gitlabsg.id]
    subnet_id = var.public_subnet_id
    associate_public_ip_address = true
    user_data = templatefile("${path.module}/gitlab.sh.tftpl", {s3bucket_name = aws_s3_bucket.Vbucket.bucket})
    tags = {
        Name = "Gitlab"
    }
    depends_on = [aws_s3_bucket.Vbucket]
}