resource "local_file" "hello-word" {
  content = var.content
  filename = "hello_word.txt"

}

variable "content" {

    type = string
    default = "Hello World"
}
output "id_file" {
  value = local_file.hello-word.id
}

data "local_file" "hell-word-data-file" {
  filename = local_file.hello-word.filename
}

output "data_source_result" {
  value = data.local_file.hell-word-data-file.content
}