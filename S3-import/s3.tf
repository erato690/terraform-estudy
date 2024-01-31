 import {
   to = aws_s3_bucket.s3_import
   id = "import_s3-import-terraform"
 }

resource "aws_s3_bucket" "s3_import" {
  bucket  = "s3-import-terraform"

  tags = {
    import = "true"
  }

}