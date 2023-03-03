output "ec2_private_ip" {
  value = var.enable_test_ec2 ? aws_instance.test[0].private_ip : ""
}