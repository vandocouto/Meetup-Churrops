variable "instance" {
	default = "1"
}

variable "ami" {
	default = "ami-cd0f5cb6"
}

variable "region" {
  default = "us-east-1"
}
variable "type" {
  default = "t2.small"
}
variable "ami_id" {
  default = "ami-ba1715ac"
}
variable "sg_name" {
  default = "churrops"
}

variable "key" {
  default = "churrops"
}

variable "type_disk_so" {
        default = "gp2"
}

variable "size_so" {
        default = "70"
}

variable "tag" {
  default = "churrops"
}
variable "ssh_user_name" {
  default = "ubuntu"
}