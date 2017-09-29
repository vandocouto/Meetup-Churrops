data "terraform_remote_state" "vpc" {
  backend = "local"

  config {
    path = "../../vpc/terraform.tfstate"
  }
}

data "terraform_remote_state" "ec2-swarm" {
  backend = "local"

  config {
    path = "../../ec2-swarm/terraform.tfstate"
  }
}

resource "aws_security_group" "elb" {
  name = "elb"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

# Load Balance traefik
resource "aws_elb" "traefik" {
  name = "traefik"
  subnets = [
    "${data.terraform_remote_state.vpc.subnets}"]
  security_groups = [
    "${aws_security_group.elb.id}"]
  // interno load balance (true) externo load balance (false)
  internal = false

  listener {
    instance_port = 80
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }

  listener {
    instance_port = 80
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }

   listener {
    instance_port = 8080
    instance_protocol = "tcp"
    lb_port = 8080
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 10
    unhealthy_threshold = 2
    timeout = 2
    target = "TCP:80"
    interval = 10
  }

  instances = [
      "${data.terraform_remote_state.ec2-swarm.4}"]
  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 60
}