output "Public_ip" {
        value = "${join (",", aws_instance.ec2-vault.*.public_ip)}"
}

output "Private_ip" {
        value = "${join (",", aws_instance.ec2-vault.*.private_ip)}"
}
