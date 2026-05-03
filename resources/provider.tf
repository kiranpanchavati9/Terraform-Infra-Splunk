# ============================================================
# provider.tf
# Description : Configures the Terraform AWS provider
#               Specifies provider version and AWS region
# ============================================================


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}