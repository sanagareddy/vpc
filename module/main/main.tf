#Creating modules

module "m_vpc" {
	source = "./module"
	tags = {"Name" = "M_VPC"}
	cidr_block = "192.168.0.0/24"
	vpc_id = "${module.m_vpc.vpcz}"
}

module "instance1" {
	source = "./module"
	ami = "ami-09aa695110875052b"
	subnet_id = "${module.m_vpc.subs1}"
	instance_type = "t2.micro"
}