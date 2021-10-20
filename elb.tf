module "elb" {
  #source         = "git@github.com:therasec/vulnerable-environment.git//modules"
  #source         = "github.com/therasec/vulnerable-environment//modules"
  source         = "./modules"
  elb_name       = "${local.prefix.value}-public-elb"
  subnets        = aws_subnet.public.*.id
  security_group = aws_security_group.public_internet.id
  instances      = aws_instance.web.*.id
}

output "elb_dns" {
  description = "The DNS Name of the ELB"
  value       = module.elb.elb_dns
}
