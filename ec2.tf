resource "aws_security_group" "web" {
  name        = "${local.prefix.value}-web-sg"
  description = "${local.prefix.value} Web Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
      #"10.0.0.0/16"
    ]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
}

data "aws_ami" "latest_ecs" {
  most_recent = true
  owners      = ["591542846629"] # AWS

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  count         = 2
  ami           = data.aws_ami.latest_ecs.image_id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = aws_subnet.public[count.index].id
  user_data              = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
service httpd start
echo "Provisioned with Terraform. Secured with Accurics" > /var/www/html/index.html
EOF
  tags = {
    Name = "${local.prefix.value}-ec2-${count.index}"
  }
}

output "instances_public_ips" {
  description = "The public IPs of the EC2 instances"
  value       = aws_instance.web.*.public_ip
}
