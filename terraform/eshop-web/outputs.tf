output "websvr_ip" {
  description = "Private IP address of the provisioned web server"
  value       = aws_instance.web_server.private_ip
}