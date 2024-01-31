output "name" {
    value = aws_s3_bucket.bucket.id
}

output "policy" {
  value = var.policy
}

output "paht-files" {
  value = var.files
}