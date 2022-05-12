output "instance_public_ip" {
  value       = [aws_instance.web_server.public_dns]
  description = "The public DNS address of the web server"
}
