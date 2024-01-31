output "file" {
  value = "${var.bucket}${aws_s3_object.object.key}"
}

output "object_etag" {
  value = aws_s3_object.object.etag
}

output "object_content_type" {
  value = aws_s3_object.object.content_type
}

output "object_meta" {
  value = aws_s3_object.object.metadata
}