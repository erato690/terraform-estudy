variable "name" {
  type = string
}


variable "files" {
  type = string
}


variable "tags" {
  type = map(string)
}

variable "key_prefix" {
  type    = string
  default = ""
}
variable "policy" {
  type = string
}