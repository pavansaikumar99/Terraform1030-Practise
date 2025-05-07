#vpc creation
resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="dev"
  }
}

#InternetGateway and attach to vpc
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.dev.id
}

#subnets creation
resource "aws_subnet" "public" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.dev.id
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "pvt" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.dev.id
}

#route table creation
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

#Subnet associations
resource "aws_route_table_association" "dev" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#security groups
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  vpc_id      = aws_vpc.dev.id
  tags = {
    Name = "dev_sg"
  }
 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" #AllProtocols
    cidr_blocks      = ["0.0.0.0/0"]
    
  }


  }

#key-pair
resource "aws_key_pair" "devtest" {
  key_name = "public"
  public_key = file("~/.ssh/id_ed25519.pub")
}

#Launch server
resource "aws_instance" "dev" {
  ami = "ami-0f88e80871fd81e91"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  key_name = aws_key_pair.devtest.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
}