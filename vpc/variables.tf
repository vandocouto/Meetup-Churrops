variable "name" {
  default = "Meetup-Churrops"
}

variable "region" {
  default = "us-east-1"
}

variable "cidr" {
  default = "10.0.0.0/21"
}

variable "subnets" {
  type = "list"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
  type = "list"
  default     = ["us-east-1a", "us-east-1b" , "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
}

variable "enable_dns_hostnames" {
  default     = true
}

variable "enable_dns_support" {
  default     = true
}

variable "enable_nat_gateway" {
  default     = true
}

variable "map_public_ip_on_launch" {
  default     = true
}

variable "private_propagating_vgws" {
  type = "list"
  default     = []
}

variable "public_propagating_vgws" {
  type = "list"
  default     = []
}

// blank tag
variable "tags" {
  default     = {}
}
