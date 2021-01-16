output "public_ip" {
  description = "instance Ip address"
  value = aws_instance.ec2_websrv.public_ip
}

output "PORT" {
  description = "PORT"
  value = "9200"
}