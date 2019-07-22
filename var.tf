
variable "accesskey" {
  default = ""
}

variable "secretkey" {
  default = ""
}

variable "env" {
  description = "Which environment you want to build ?"
}

variable "azs" {
  description = "Please enter the availability zone from [us-east-1a,us-east-1b,us-east-1c] to deploy the server"
  #type = "list"
  #default = ["us-east-1a","us-east-1b","us-east-1c"]
}

variable "Ami" {
  type = "map"
  default = {
    #This is Amazon AMI
    Dev = "ami-035b3c7efe6d061d5"

    #This is Linux AMI
    Stg = "ami-0c322300a1dd5dc79"

    #This is Windows AMI
    Prod = "ami-0be3b7126b85e11dc"
  }
}

variable "vpc_cidr" {
  type    = "list"
  default = ["10.0.0.0/26", "10.0.1.0/25", "10.0.10.0/24"]
}

variable "pub_subnet_cidr" {
  type = "map"
  default = {
    Dev_pub_subnet_cidr  = "10.0.0.0/27"
    Stg_pub_subnet_cidr  = "10.0.1.0/26"
    Prod_pub_subnet_cidr = "10.0.10.0/25"
  }
}

variable "pvt_subnet_cidr" {
  type = "map"
  default = {
    Dev_pvt_subnet_cidr  = "10.0.0.16/28"
    Stg_pvt_subnet_cidr  = "10.0.1.32/27"
    Prod_pvt_subnet_cidr = "10.0.10.64/26"
  }
}
