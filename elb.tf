# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "public_internet" {
  name        = "${local.prefix.value}-public-internet"
  description = "Public Load Balancer"
  vpc_id      = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
      #"0.0.0.0/0"
      "10.0.0.0/16"
    ]
  }
}


resource "aws_elb" "public_elb" {
  name = "${local.prefix.value}-public-elb"

  subnets         = aws_subnet.public.*.id
  security_groups = ["${aws_security_group.public_internet.id}"]
  instances       = aws_instance.web.*.id

  connection_draining = true
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  tags = {
    Name = "${local.prefix.value}-public-elb"
  }
}
