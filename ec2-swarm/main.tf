data "terraform_remote_state" "vpc" {
  backend = "local"

  config {
    path = "../vpc/terraform.tfstate"
  }
}

resource "aws_key_pair" "key-public" {
  key_name = "swarm"
  public_key = "${file("key-pairs/swarm.pem.pub")}"
}

resource "aws_security_group" "swarm" {
  name = "${var.sg_name}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "10.0.0.0/21"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}


# deploy swarm manager
resource "aws_instance" "swarm-manager" {
  count = "3"
  subnet_id = "${element(data.terraform_remote_state.vpc.subnets, count.index)}"
  instance_type = "${var.type}"
  ami = "${var.ami}"
  key_name = "swarm"
  security_groups = [
    "${aws_security_group.swarm.id}"]
  associate_public_ip_address = true

  root_block_device {
    volume_size = "${var.size_so}"
    volume_type = "${var.type_disk_so}"
  }

  tags {
    Name = "${var.tag}"
  }

  provisioner "remote-exec" {
    connection {
      user = "${var.ssh_user_name}"
      private_key = "${file("key-pairs/swarm.pem")}"
    }

    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install python-simplejson -y",]
  }

}

# deploy swarm worker
resource "aws_instance" "swarm-worker" {
  count = "${var.instanceWorker}"
  subnet_id = "${element(data.terraform_remote_state.vpc.subnets, count.index)}"
  instance_type = "${var.type}"
  ami = "${var.ami}"
  key_name = "swarm"
  security_groups = [
    "${aws_security_group.swarm.id}"]
  associate_public_ip_address = true

  root_block_device {
    volume_size = "${var.size_so}"
    volume_type = "${var.type_disk_so}"
  }

  tags {
    Name = "${var.tag}"
  }

  provisioner "remote-exec" {
    connection {
      user = "${var.ssh_user_name}"
      private_key = "${file("key-pairs/swarm.pem")}"
    }

    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install python-simplejson -y",]
  }

}

