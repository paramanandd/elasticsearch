resource "aws_vpc" "main" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name            = "MEDIAWIKI-VPC"
    
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name            = "MEDIAWIKI-IGW"
    
  }
}

resource "aws_route_table" "routes" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name            = "MEDIAWIKI-PUBLIC-ROUTE-TABLE"
    
  }
}

resource "aws_route" "default" {
  route_table_id         = aws_route_table.routes.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "public_subnet1" {
 
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.168.0.0/18"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "MEDIAWIKI-PUB-1"
  }
}

resource "aws_subnet" "public_subnet2" {
 
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.168.64.0/18"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "MEDIAWIKI-PUB-2"
  }
}

resource "aws_route_table_association" "associations" {

  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.routes.id
}


resource "aws_route_table_association" "associations_pub2" {

  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.routes.id
}

resource "aws_subnet" "private_subnet1" {
 
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.128.0/18"
  availability_zone = "us-east-1a"

  tags = {
    Name                              = "MEDIAWIKI-PRI-1"
  }
}

resource "aws_subnet" "private_subnet2" {
 
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.192.0/18"
  availability_zone = "us-east-1b"

  tags = {
    Name                              = "MEDIAWIKI-PRI-2"
  }
}


# we use only one route table with one NAT
# or one route table per NAT if we have multiple
resource "aws_route_table" "private_routes_nat" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name            = "MEDIAWIKI-PRIVATE-ROUTE-TABLE"
    
  }
}

#change main route table to custom route table. 
resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.private_routes_nat.id
}

resource "aws_route_table_association" "private_associations" {

  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_routes_nat.id
}

resource "aws_route_table_association" "private_associations2" {

  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_routes_nat.id
}

resource "aws_default_network_acl" "main" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id, aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]

  tags = {
    Name            = "MEDIAWIKI-NACL"
  }
}

resource "aws_eip" "eip" {
  vpc   = true
  tags = {
    Name            = "MEDIAWIKI-NAT-EIP"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name            = "MEDIAWIKI-NAT-GATEWAY"
  }
}


resource "aws_route" "private_route_nat" {
  route_table_id         = aws_route_table.private_routes_nat.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id

}
