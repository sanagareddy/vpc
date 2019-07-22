provider "aws" {
	access_key = "${var.accesskey}"
	secret_key = "${var.secretkey}"
	region = "${var.region}"
}

resource "aws_instance" "Dev_Server" {
		count = "${var.env == "Dev" ? 1 : 0}"
		ami = "${var.Ami.Dev}"
		instance_type = "t2.micro"
		subnet_id = "${aws_subnet.PubSub}"
		security_groups = "${aws_security_group.Dev_SG}"
}

resource "aws_instance" "Stage_Server" {
		count = "${var.env == "Stg" ? 1 : 0}"
		ami = "${var.Ami.Stg}"
		instance_type = "t2.micro"
		subnet_id = "${aws_subnet.PvtSub}"
		security_groups = "${aws_security_group.Stg_SG}"
}

resource "aws_instance" "Prod_Server" {
		count = "${var.env == "Prod" ? 1 : 0}"
		ami = "${var.Ami.Prod}"
		instance_type = "t2.micro"
		subnet_id = "${aws_subnet.PvtSub}"
		security_groups = "${aws_security_group.Prod_SG}"
}

resource "aws_vpc" "Main_vpc" {
	tags = {"Name" = "Main_vpc"}
	count = "${var.env == "Dev" ? 1 : 0} : ${var.env == "Stg" ? 1 : 0}"
	cidr_block = "${var.vpc_cidr[0]}"
	#count = "${var.env == "Stg" ? 1 : 0}"
	#cidr_block = "${var.vpc_cidr[1]}"
	#count = "${var.env == "Prod" ? 1 : 0}"
	#cidr_block = "${var.vpc_cidr[2]}"	
}

resource "aws_subnet" "PubSub" {
	tags = {"Name" = "PubSub"}
	vpc_id = "{aws_vpc.Main_vpc.id}"
	availability_zone = "${var.azs}"
	count = "${var.env == "Dev" ? 1 : 0}"
	cidr_block = "{var.pub_subnet_cidr.Dev_pub_subnet_cidr}"
	count = "${var.env == "Stg" ? 1 : 0}"
	cidr_block = "{var.pub_subnet_cidr.Stg_pub_subnet_cidr}"
	count = "${var.env == "Prod" ? 1 : 0}"
	cidr_block = "{var.pub_subnet_cidr.Prod_pub_subnet_cidr}"
	
}

resource "aws_subnet" "PvtSub" {
	tags = {"Name" = "PvtSub"}
	vpc_id = "{aws_vpc.Main_vpc.id}"
	availability_zone = "${var.azs}"
	count = "${var.env == "Dev" ? 1 : 0}"
	cidr_block = "{var.pvt_subnet_cidr.Dev_pvt_subnet_cidr}"
	count = "${var.env == "Stg" ? 1 : 0}"
	cidr_block = "{var.pvt_subnet_cidr.Stg_pvt_subnet_cidr}"
	count = "${var.env == "Prod" ? 1 : 0}"
	cidr_block = "{var.pvt_subnet_cidr.Prod_pvt_subnet_cidr}"
}

resource "aws_security_group" "Dev_SG" {
	depends_on = "${aws.subnet.PubSub}"
	depends_on = "${aws.subnet.PvtSub}"
	name = "Dev_SG"
	ingress = {
		protocol = 'tcp'
		from_port = 22
		to_port = 22
		cidr_block = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "Stg_SG" {
	depends_on = "${aws.subnet.PubSub}"
	depends_on = "${aws.subnet.PvtSub}"
	name = "Stg_SG"
	ingress = {
		protocol = 'tcp'
		from_port = 22
		to_port = 22
		cidr_block = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "Prod_SG" {
	depends_on = "${aws.subnet.PubSub}"
	depends_on = "${aws.subnet.PvtSub}"
	name = "Prod_SG"
	ingress = {
		protocol = 'tcp'
		from_port = 8080
		to_port = 8080
		cidr_block = ["0.0.0.0/0"]
	}
}

resource "aws_route_table" "RT1" {
	tags = {"Nmae" = "RouteTable1"}
	vpc_id = "${aws_vpc.Main_vpc}"
	route = {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.IG1.id}"
	}
}

resource "aws_internet_gateway" "IG1" {
	vpc_id = "${aws_vpc.Main_vpc}"
	tags = {"Name" = "IGateway"}
}

resource "aws_route_table_association" "rt_association" {
		subnet_id = "${aws_subnet.PubSub.id}"
		route_table_id = "${aws_route_table.RT1.id}"
}

#resource "aws_nat_gateway" "NAT1" {
#
#}