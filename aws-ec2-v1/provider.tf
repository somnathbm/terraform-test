# declare aws provider
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# provider for the east region
provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::691685274845:role/AwsageEngnrDevOrgAccessRole"
  }
}

# alternate provider for the west region
provider "aws" {
  region = "us-west-1"
  alias  = "west"
}