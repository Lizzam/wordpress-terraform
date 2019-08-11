resource "aws_instance" "wp" {
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

