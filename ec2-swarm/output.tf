# output
output "1" {
	value = "${join(",", aws_instance.swarm-manager.*.public_ip)}"

}

output "2" {
        value = "${join(",", aws_instance.swarm-worker.*.public_ip)}"

}

output "3" {
        value = "${join(",", aws_instance.swarm-manager.*.private_ip)}"

}

output "4" {
  value = ["${aws_instance.swarm-manager.*.id}"]
}

//output "InstanceID" {
//  value = "${join(",", aws_instance.docker-swarm.*.id)}"
//}