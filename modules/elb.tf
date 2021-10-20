variable "subnets" {}
variable "security_group" {}
variable "instances" {}
variable "elb_name" {}

resource "aws_elb" "public_elb" {
  name = var.elb_name

  subnets         = var.subnets
  security_groups = [var.security_group]
  instances       = var.instances

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
    Name = var.elb_name
  }
}

output "elb_dns" {
  description = "The DNS Name of the ELB"
  value       = aws_elb.public_elb.dns_name
}
