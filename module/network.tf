#Creating VPC network along with security groups

resource "aws_vpc" "vpc1" {
  tags              = {"Name" : "my_vpc"}
  cidr_block        = "10.0.0.0/26"
  availability_zone = "us-east-1"
}

resource "aws_subnet" "subnet1" {
  tags                 = { "Name" = "my_sub1" }
  vpc_id               = "${aws_vpc.vpc1.id}"
  availability_zone    = "us-east-1a"
  cidr_block           = "10.0.0.0/27"
  map_public_ip_launch = "true"
}

resource "aws_subnet" "subnet2" {
  tags              = { "Name" = "my_sub2" }
  vpc_id            = "${aws_vpc.vpc1.id}"
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.0.0/28}"
}

resource "aws_subnet" "Pvt_sub" {
  tags              = { "Name" = "pvt_sub1" }
  vpc_id            = "${aws_vpc.vpc1.id}"
  availability_zone = "us-east-1c"
  cidr_block        = "10.0.1.0/26"
}

resource "aws_route_table" "rt1" {
  tags   = { "Name" = "RT1" }
  vpc_id = "${aws_vpc.vpc1.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IG.id}"
  }

}

resource "aws_route_table_association" "association" {
  subnet_id      = ["${aws_subnet.subnet1.id}", "${aws_subnet.subnet2.id}"]
  route_table_id = "${aws_route_table.rt1.id}"
}

resource "aws_internet_gateway" "IG" {
  tage   = { "Name" = "IG" }
  vpc_id = "${aws_vpc.vpc1.id}"
}




output "vpcz" {
	value = "${aws_vpc.vpc1.id}"
}

output "subs1" {
	value = "${aws_subnet.subnet1.id}"
}

output "subs2" {
	value = "${aws_subnet.subnet2.id}"
}

output "pvt_subs3" {
	value = "${aws_subnet.Pvt_sub.id}"
}