variable "company_name" {}
variable "environment" {}
variable "vpc_cidr" {}
variable "profile" {}
variable "region" {}
#variable "db_password" {}

locals {
  prefix = {
    value = "${var.company_name}-${var.environment}"
  }
}

provider "aws" {
  region  = var.region
}

terraform {
  backend "s3" {
    bucket = "cesar-lab-state-bucket"
    key    = "vulnerable-environment.tfstate"
    region = "us-east-1"
  }
}

