# declare resource - s3 bucket
resource "aws_s3_bucket" "tf_bucket01" {
  bucket = "awsage-tf-bucket01"

  tags = {
    Name = "awsage-tf-bucket01"
    Environment = "dev"
  }
}

# enable bucket versioning
resource "aws_s3_bucket_versioning" "bucket-versioning" {
    bucket = aws_s3_bucket.tf_bucket01.id
    versioning_configuration {
        status = "Enabled"
    }
}