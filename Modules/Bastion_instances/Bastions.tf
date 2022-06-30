
module myip {
    source  = "4ops/myip/http"
    version = "1.0.0"
}

resource "aws_security_group" "Bastionsg" {
    name = "Bastion_access"
    vpc_id = var.vpc_id
    ingress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["${module.myip.address}/32"]
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Bastion_access"
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
    owners = ["099720109477"] # Canonical
}
resource "aws_instance" "RunnerBastion" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name = "Vgitlab"
    vpc_security_group_ids = [aws_security_group.Bastionsg.id]
    subnet_id = var.public_subnet_id
    associate_public_ip_address = true
    tags = {
        Name = "RunnerBastion"
  }
}