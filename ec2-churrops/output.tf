output "Public_ip" {
        value = "${join (",", aws_eip.ip-wan.*.public_ip)}"
}

output "Private_ip" {
        value = "${join (",", aws_eip.ip-wan.*.private_ip)}"
}
