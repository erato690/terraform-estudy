data "template_file" "policy" {
  template = file("${path.module}/../static-web-site-files/policy.json.tpl")

  vars = {
    bucket_name = module.bucket.name
  }
}