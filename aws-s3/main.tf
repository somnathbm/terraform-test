# create s3 bucket
resource "aws_s3_bucket" "tf" {
  bucket = "awsage-tftest-demo"
}

# setup versioning first
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.tf.id

  versioning_configuration {
    status = "Enabled"
  }
}

# setup server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "enabled" {
  bucket = aws_s3_bucket.tf.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# block public access and acl
resource "aws_s3_bucket_public_access_block" "disabled" {
  bucket = aws_s3_bucket.tf.id
  
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# setup locking for s3
resource "aws_dynamodb_table" "locking" {
  name = "tftest-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}