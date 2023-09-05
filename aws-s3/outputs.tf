output "s3_bucket_arn" {
   value = aws_s3_bucket.tf.arn 
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.locking.arn
}