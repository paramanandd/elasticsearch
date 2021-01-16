resource "aws_security_group" "sg_websrv" {
  name        = "ELASTICSEARCH-WEB-SERVER"
  description = "Security Group For ELASTICSEARCH Web Server"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name       = "ELASTICSEARCH-WEB-SERVE"
  }
  ingress {
    description = ""
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}