# terraform config block
terraform {
    required_version = ">= 1.5.0"
    backend "s3" {
      bucket = "awsage-tftest-demo"
      region = "us-east-1"
      key = "global/s3/terraform.tfstate"
      dynamodb_table = "tftest-locking"
      encrypt = true
      role_arn = "arn:aws:iam::691685274845:role/AwsageEngnrDevOrgAccessRole"
    }
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}


# use the declared provider
provider "aws" {
    region = "us-east-1"
    assume_role {
        role_arn = "arn:aws:iam::691685274845:role/AwsageEngnrDevOrgAccessRole"
    }
}

