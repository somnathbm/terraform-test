# terraform config block
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.8.0"
        }
    }
}


# use the declared provider
provider "aws" {
    region = var.provider_region
    assume_role {
        role_arn = "arn:aws:iam::691685274845:role/AwsageEngnrDevOrgAccessRole"
    }
}

