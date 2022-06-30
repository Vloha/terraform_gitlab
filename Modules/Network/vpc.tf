resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    tags = {
        Name = "Gitlab_VPC"
    }
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "Gitlab_Gateway"
    }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = "us-east-1a"
    cidr_block = "192.168.0.0/26"
    tags = {
        Name = "Gitlab_public"
    }
}
resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = "us-east-1b"
    cidr_block = "192.168.0.64/26"
    tags = {
        Name = "Bastion_public"
    }
}

resource "aws_subnet" "private2" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = "us-east-1c"
    cidr_block = "192.168.0.128/26"
    tags = {
        Name = "Gitlabrunner_private"
    }
}

resource "aws_eip" "nat_eip" {
    vpc =true
    tags = {
        Name = "Gitlab_eip"
    }
}

resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public.id
    tags = {
        Name = "Gitlab_NATgw"
    }
}

resource "aws_route_table" "PublicRt" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "Public_RT"
    }
}


resource "aws_route_table" "PrivateRt2" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw.id
    }
    tags = {
        Name = "Gitlabrunner_Private"
    }
}

resource "aws_route_table_association" "PublicAssociation_A" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.PublicRt.id
}
resource "aws_route_table_association" "PublicAssociation_B" {
    subnet_id = aws_subnet.public2.id
    route_table_id = aws_route_table.PublicRt.id
}


resource "aws_route_table_association" "Private2Association" {
    subnet_id = aws_subnet.private2.id
    route_table_id = aws_route_table.PrivateRt2.id
}