variable "ami_id" {
  default = "ami-0739f8cdb239fe9ae"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/files/user-data.sh")}"
}
