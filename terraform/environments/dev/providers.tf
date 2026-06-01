terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "terraform-first-test-jh2026"
    key    = "devops-portfolio/dev/terraform.tfstate"
    region = "eu-north-1"
    profile = "terraform"
  }
    }
provider "aws" {
    region = "eu-north-1"
    profile = "terraform"
}
