# declare aws provider
terraform {
    required_version = ">= 1.5.0"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# meta argument
provider "aws" {
    region = "us-east-1"
}

# alternate provider
provider "aws" {
    region = "us-west-1"
    alias = "west"
}