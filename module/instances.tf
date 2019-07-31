resource "aws_instance" "win1_ec" {
  ami               = "ami-0b99c7725b9484f9e"
  instance_type     = "t2.micro"
  subnet_id         = "${aws_subnet.subnet1.id}"
  tags              = { "Name" = "win1_ec" }
  #availability_zone = "us-east-1a"
  user_data         = <<-EOF
		#! bin/bash
		yum install -y httpd
		echo "Welcome to the red page !!!" > /var/www/html/index.html
		yum install -y update
		service httpd start
		EOF


}

resource "aws_instance" "win2_ec" {
  ami = "ami-0b99c7725b9484f9e"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet2.id}"
  tags = { "Name" = "Win2_ec" }
  user_data = <<-EOF
		#! bin/bash
		yum install httpd -y
		echo "Welcome to the green page !!!" > /var/www/html/index.html
		yum install -y update
		service httpd start
		EOF
}
