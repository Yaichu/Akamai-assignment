provider "aws" {
  region = "ca-central-1"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "app_vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "Akamai App VPC"
  }
}

resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "ca-central-1a"
  tags = {
    Name = "Akamai App Subnet"
  }
}

resource "aws_security_group" "app_security_group" {
  name        = "app_security_group"
  vpc_id = aws_vpc.app_vpc.id

  # Allow from the workstation to the LB server on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["13.48.147.159/32"]
  }

  # Allow from the workstation to all the servers on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["13.48.147.159/32"]
  }

  # Allow any internal communication in the subnet
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.1.0/24"]
  }

  # Block all other inbound traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows all outbound traffic from the security group to any destination
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound internet access
  }
}

resource "aws_internet_gateway" "igateway" {
  vpc_id = aws_vpc.app_vpc.id
}

resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igateway.id
  }

  tags = {
    Name = "app_route_table"
  }
}

resource "aws_route_table_association" "app_route_table_association" {
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.app_route_table.id
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "local_sensitive_file" "ssh_private_key_file" {
  filename = "./app-key.pem"
  content  = tls_private_key.ssh_key.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "app_key" {
  key_name   = "app-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_instance" "lb" {
  ami           = "ami-0baa2760c1decf0c8"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.app_security_group.name]
  key_name      = aws_key_pair.app_key.key_name
  subnet_id     = aws_subnet.app_subnet.id
  private_ip    = "192.168.0.11"
  associate_public_ip_address = true

  tags = {
    Name = "LB"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0baa2760c1decf0c8"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.app_security_group.name]
  key_name      = aws_key_pair.app_key.key_name
  subnet_id     = aws_subnet.app_subnet.id
  private_ip    = "192.168.0.12"
  associate_public_ip_address = true

  tags = {
    Name = "WEB"
  }
}

resource "aws_instance" "db" {
  ami           = "ami-0baa2760c1decf0c8"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.app_security_group.name]
  key_name      = aws_key_pair.app_key.key_name
  subnet_id     = aws_subnet.app_subnet.id
  private_ip    = "192.168.0.13"
  associate_public_ip_address = true

  tags = {
    Name = "DB"
  }
}
