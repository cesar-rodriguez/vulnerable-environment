resource "aws_elb" "public_elb" {
  name = "${local.prefix.value}-public-elb"

  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.public_internet.id]
  instances       = aws_instance.web.*.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 15
  }

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

output "elb_dns" {
  description = "The DNS Name of the ELB"
  value       = aws_elb.public_elb.dns_name
}
