resource "aws_key_pair" "ec2_keypair" {
    key_name   = "elasticsearch"
  public_key = file("./files/elasticsearch.pub")
}

resource "aws_instance" "ec2_websrv" {
  ami                  = var.ami_id
  instance_type        = "t3.medium"
  key_name             = aws_key_pair.ec2_keypair.key_name
  subnet_id            = aws_subnet.public_subnet1.id
  user_data            = data.template_file.user_data.rendered
  tags = {
    Name        = "ELASTICSEARCH-WEB-SERVER"
  }
  root_block_device {
    volume_size           = 50
    delete_on_termination = "true"
    encrypted             = "true"
  }
  volume_tags = {
    Name       = "ELASTICSEARCH-WEB-SERVER"
  }
  vpc_security_group_ids = [aws_security_group.sg_websrv.id]
}
