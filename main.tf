provider "aws" {
  alias = "main"
  region = "${var.aws_region}"

}


resource "aws_key_pair" "keypair" {
	provider= "aws.main"
	key_name = "${var.keyname}"
	public_key = "$(var.public_key)"
}


resource "aws_vpc" "vpc-tunnel" {
  provider= "aws.main"
  cidr_block = "${var.vpc_cidr}"
  assign_generated_ipv6_cidr_block = true
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "ipv6-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  provider= "aws.main"
  vpc_id = "${aws_vpc.vpc-tunnel.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc-tunnel.ipv6_cidr_block, 8, 1)}"
  assign_ipv6_address_on_creation = true
  tags {
    Name = "IPv6 Public Subnet"
  }
}


resource "aws_internet_gateway" "gateway-tunnel" {
    provider= "aws.main"
    vpc_id = "${aws_vpc.vpc-tunnel.id}"
}


resource "aws_default_route_table" "vpc-tunnel" {
    default_route_table_id = "${aws_vpc.vpc-tunnel.default_route_table_id}"
    tags {
        Name = "test"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gateway-tunnel.id}"
    }

    route {
        ipv6_cidr_block = "::/0"
        gateway_id = "${aws_internet_gateway.gateway-tunnel.id}"
    }
}

resource "aws_route_table_association" "vpc-tunnel" {
    subnet_id      = "${aws_subnet.public-subnet.id}"
    route_table_id = "${aws_default_route_table.vpc-tunnel.id}"
}

resource "aws_security_group" "security-tunnel" {
  provider= "aws.main"
  name = "vpc_test_web"
  description = "Allow incoming TUNNEL connections & SSH access"
  vpc_id = "${aws_vpc.vpc-tunnel.id}"
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8888 
    to_port = 8888
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  ingress {
    from_port = 6565
    to_port = 6565 
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

 

  tags {
    Name = "IPv6 TUNNEL"
  }
}


resource "aws_instance" "ipv4-tunnel" {
   ami  = "${var.ami}"
   instance_type = "t1.micro"
   key_name = "${aws_key_pair.keypair.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.security-tunnel.id}"]
   associate_public_ip_address = true
   source_dest_check = false
  provisioner "local-exec" {
    command = " ssh -N -f -L localhost:8889:localhost:6565 heap"
    command = "echo Host heap >> ~/.ssh/config "
    command = "echo HostName ${var.ipv6_machine} >> ~/.ssh/config"
    command = "LocalForward 7777 localhost:7777 >> ~/.ssh/config"
    command = "User ${var.username} >> ~/.ssh/config"
  }

  tags {
    Name = "ipv4-tunnel"
  }
}

output "main public IPv4" {
  value = "${aws_instance.ipv4-tunnel.public_ip}"
}

output "main IPv6" {
  value = ["${aws_instance.ipv4-tunnel.ipv6_addresses}"]
}
