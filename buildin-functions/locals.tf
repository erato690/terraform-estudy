locals {
  
  instance_count = lookup(var.instance_count, var.env)

  file_ext = "zip"

  object_name = "json_em_zip_pelo_archive_file"

  common_tags = {
    "owner" = "Rafael dias"
    "date_create"   = timestamp()
  }
}