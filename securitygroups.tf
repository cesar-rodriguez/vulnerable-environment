# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "public_internet" {
  name        = "${local.prefix.value}-public-internet"
  description = "Public Load Balancer"
  vpc_id      = aws_vpc.vpc.id

  # HTTP access from anywhere
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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
}

# Security group for web servers
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
      "0.0.0.0/0"
    ]
  }
}
