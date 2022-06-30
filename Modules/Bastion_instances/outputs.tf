output "BastionRunnerIp" {
  value = aws_instance.RunnerBastion.private_ip
}
