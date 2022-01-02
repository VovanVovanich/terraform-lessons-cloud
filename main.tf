data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.server_size
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
<body bgcolor="black">
echo "<h2 color="blue">${var.server_name}-WebServer with IP: $myip</h2><br><font color="red">Build by Terraform and Vovik!"  >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
  tags = {
    Name  = "${var.server_name}-WebServer"
    Owner = "Vova"
  }
}

resource "aws_security_group" "web" {
  name_prefix = "${var.server_name}-WebServer-SG"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "${var.server_name}-WebServer SecurityGroup"
    Owner = "Vova"
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  tags = {
    Name  = "${var.server_name}-WebServer-IP"
    Owner = "Vova"
  }
}
