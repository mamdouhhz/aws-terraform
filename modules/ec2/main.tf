resource "aws_instance" "web_1" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [var.ec2_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > web_1_public_ip.txt"
  }

  provisioner "remote-exec" {
    inline = ["echo connected"]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Hello from Web-1 — AZ-1</h1>" > /usr/share/nginx/html/index.html
  EOF

  tags = { Name = "web-1" }
}

resource "aws_instance" "web_2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[1]
  vpc_security_group_ids      = [var.ec2_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Hello from Web-2 — AZ-2</h1>" > /usr/share/nginx/html/index.html
  EOF

  tags = { Name = "web-2" }
}

resource "aws_instance" "app_1" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_ids[0]
  vpc_security_group_ids      = [var.app_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Hello from App-1 — AZ-1</h1>" > /usr/share/nginx/html/index.html
  EOF

  tags = { Name = "app-1" }
}

resource "aws_instance" "app_2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_ids[1]
  vpc_security_group_ids      = [var.app_sg_id]
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Hello from App-2 — AZ-2</h1>" > /usr/share/nginx/html/index.html
  EOF

  tags = { Name = "app-2" }
}