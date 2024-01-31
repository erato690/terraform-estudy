
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "remote-state" {
  bucket  = "tfstate-${data.aws_caller_identity.current.account_id}"

  tags = {
    name = "remote-state-terraform"
  }
  
}


resource "aws_s3_bucket_acl" "remote-state-acl" {
  bucket = aws_s3_bucket.remote-state.id
  acl    = "private"
  
}


resource "aws_s3_bucket_versioning" "versioning_remote-state" {
  bucket = aws_s3_bucket.remote-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "remote_state_bucket" {
  value = aws_s3_bucket.remote-state.bucket
}


output "remote_state_bucket_arn" {
  value = aws_s3_bucket.remote-state.id
}