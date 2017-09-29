 resource "aws_vpc" "vpc" {
    cidr_block = "${var.cidr}"
    enable_dns_hostnames = "${var.enable_dns_hostnames}"
    enable_dns_support = "${var.enable_dns_support}"
    tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
  }

  resource "aws_internet_gateway" "ig" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags = "${merge(var.tags, map("Name", format("%s-igw", var.name)))}"
  }

  resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.vpc.id}"
    propagating_vgws = [
      "${var.public_propagating_vgws}"]
    tags = "${merge(var.tags, map("Name", format("%s-rt-public", var.name)))}"
  }

  resource "aws_route" "public_internet_gateway" {
    route_table_id = "${aws_route_table.public.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }

  resource "aws_subnet" "subnets" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.subnets[count.index]}"
    availability_zone = "${element(var.azs, count.index)}"
    count = "${length(var.subnets)}"
    map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
    tags = "${merge(var.tags, map("Name", format("%s-subnet-public-%s", var.name, element(var.azs, count.index))))}"

  }

  resource "aws_route_table_association" "public" {
    count = "${length(var.subnets)}"
    subnet_id = "${element(aws_subnet.subnets.*.id, count.index)}"
    route_table_id = "${aws_route_table.public.id}"
  }