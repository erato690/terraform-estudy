data "template_file" "user_data" {
  template =  file("template.json.tpl")

  vars = {
    name = "John Doe"
    age  = 42
    email = "teste@templatedata.com"
  }
}

data "archive_file" "json_zip" {
  type        =  local.file_ext

  output_path = "${path.module}/files/${local.object_name}.${local.file_ext}"

  source {
    content  = data.template_file.user_data.rendered
    filename = "${local.object_name}.json"
  }
}