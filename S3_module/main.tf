resource "aws_s3_bucket" "bucket" {

  bucket = var.name
  tags = var.tags
}


resource "aws_s3_bucket_website_configuration" "site_configuration" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }


}

resource "aws_s3_bucket_ownership_controls" "site_configuration_control" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "site_configuration_acess_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "site_configuration_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.site_configuration_control,
    aws_s3_bucket_public_access_block.site_configuration_acess_block,
  ]

  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"
}


resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = var.policy
}

module "object" {
  source = "./S3_object"

  for_each = var.files != "" ? fileset(var.files, "**/*.html") : []


  bucket = aws_s3_bucket.bucket.id
  key    = "${var.key_prefix}/${each.value}"
  src    = "${var.files}/${each.value}"
  
}