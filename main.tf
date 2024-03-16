# Define provider
provider "aws" {
  region = "your_aws_region"
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Attach internet gateway to VPC
resource "aws_vpc_attachment" "my_igw_attachment" {
  vpc_id             = aws_vpc.my_vpc.id
  internet_gateway_id = aws_internet_gateway.my_igw.id
}

# Create two subnets in different availability zones
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "your_az_1"
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "your_az_2"
}

# Create a NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet_a.id
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {}

# Create security groups for instances
resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow inbound traffic from public subnet"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch instances in public and private subnets
resource "aws_instance" "public_instance" {
  ami                    = "your_ami_id"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_a.id
  associate_public_ip_address = true
  security_groups        = [aws_security_group.public_sg.id]
}

resource "aws_instance" "private_instance" {
  ami                    = "your_ami_id"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_b.id
  security_groups        = [aws_security_group.private_sg.id]
}

# Output
output "public_ip" {
  value = aws_instance.public_instance.public_ip
}

output "private_ip" {
  value = aws_instance.private_instance.private_ip
}
