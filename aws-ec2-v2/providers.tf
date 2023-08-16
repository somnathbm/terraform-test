terraform {
  required_version = ">= 1.5.0"
  required_providers {
    # aws
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    # random
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::691685274845:role/AwsageEngnrDevOrgAccessRole"
  }
}

provider "random" {

}