data "aws_vpc" "default" {
  default = "true"
}

resource "aws_security_group" "web" {
  name = "web"
  vpc_id = "${data.aws_vpc.default.id}"

  tags = {
      terraform = "true"
  }
}

resource "aws_security_group_rule" "http_ingress" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  
  security_group_id = "${aws_security_group.web.id}"
}

resource "aws_security_group_rule" "https_ingress" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  
  security_group_id = "${aws_security_group.web.id}"
}

resource "aws_security_group_rule" "ssh_ingress" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  
  security_group_id = "${aws_security_group.web.id}"
}

resource "aws_security_group_rule" "all_egress" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  
  security_group_id = "${aws_security_group.web.id}"
}

