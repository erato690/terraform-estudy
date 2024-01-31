resource "random_pet" "random_name" {
  keepers = {
    # Generate a new pet name each time Terraform is run.
    timestamp = timestamp()
  }
  
}


resource "aws_s3_bucket" "data_output_bucket" {
  bucket  = "${random_pet.random_name.id}-${var.env}"
  tags = local.common_tags
}

resource "aws_s3_object" "data_output_object" {
  bucket = aws_s3_bucket.data_output_bucket.id
  key    = "${uuid()}.${local.file_ext}"
  source = data.archive_file.json_zip.output_path
  etag   = filemd5(data.archive_file.json_zip.output_path)
  content_type = "application/zip"
  tags = local.common_tags
  
}