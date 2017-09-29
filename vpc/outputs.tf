

output "subnets" {
  value = ["${aws_subnet.subnets.*.id}"]
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "igw_id" {
  value = "${aws_internet_gateway.ig.id}"
}