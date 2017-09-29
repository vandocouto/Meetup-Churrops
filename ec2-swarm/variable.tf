variable "instanceWorker" {
	default = "3"
}

variable "ami" {
	default = "ami-cd0f5cb6"
}

variable "region" {
  default = "us-east-1"
}

variable "type" {
  default = "t2.micro"
}
variable "ami_id" {
  default = "ami-ba1715ac"
}
variable "sg_name" {
  default = "swarm"
}

variable "type_disk_so" {
        default = "gp2"
}

variable "size_so" {
        default = "30"
}

variable "type_disk_storage" {
        default = "gp2"
}

variable "size_storage" {
        default = "30"
}

variable "tag" {
  default = "swarm"
}

variable "ssh_user_name" {
  default = "ubuntu"
}