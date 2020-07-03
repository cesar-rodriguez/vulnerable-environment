variable "company_name" {}
variable "environment" {}
variable "vpc_cidr" {}
variable "profile" {}
variable "region" {}

locals {
  prefix = {
    value = "${var.company_name}-${var.environment}"
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile = var.profile
}
