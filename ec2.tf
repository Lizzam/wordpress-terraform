data "aws_availability_zones" "availability_zones" {}

resource "aws_instance" "wp1" {
  ami           = "ami-0dc96254d5535925f"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]

  user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    service httpd start
    chkconfig httpd on
    cd /var/www/html
    echo "<html><h1>This is WebServer01</h1></html>" > index.html

EOF

  tags = {
    Name = "wordpress-app01"
    terraform = "true"
  }
}

resource "aws_instance" "wp2" {
  ami           = "ami-0dc96254d5535925f"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]

  user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    service httpd start
    chkconfig httpd on
    cd /var/www/html
    echo "<html><h1>This is WebServer02</h1></html>" > index.html

EOF

  tags = {
    Name = "wordpress-app02"
    terraform = "true"
  }
}

resource "aws_elb" "elb" {
  name               = "classic-web-elb"
  availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  security_groups = ["${aws_security_group.web.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 2
    target              = "HTTP:80/index.html"
    interval            = 5
  }

  instances                   = ["${aws_instance.wp1.id}","${aws_instance.wp2.id}"]
  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "wordpress-elb"
  }
}

