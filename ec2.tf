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

resource "aws_key_pair" "auth" {
  key_name   = "${local.prefix.value}-key"
  public_key = file("${local.prefix.value}.pub")
}

resource "aws_instance" "web" {
  count         = 2
  ami           = data.aws_ami.latest_ecs.image_id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.auth.id

  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = aws_subnet.public[count.index].id
  user_data              = <<EOF
#!/bin/bash
yum update -y
#yum install -y httpd
#service httpd start
#echo "Provisioned with Terraform. Secured with tenable.cs" > /var/www/html/index.html
mkdir -p /usr/share/nginx/html/
echo "Provisioned with Terraform. Secured with tenable.cs" > /usr/share/nginx/html/index.html
docker run --name some-nginx -v /usr/share/nginx/html:/usr/share/nginx/html:ro -d -p 80:80 nginx:1.21.0
EOF
  tags = {
    Name = "${local.prefix.value}-ec2-${count.index}"
    vm-scan = "true"
  }
}

output "instances_public_ips" {
  description = "The public IPs of the EC2 instances"
  value       = aws_instance.web.*.public_ip
}
