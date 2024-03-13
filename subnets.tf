resource "aws_subnet" "subnet1"{
vpc_id = aws_vpc.vpc.id
cidr_block = "10.0.1.0/24"
availability_zone = "us-east-1a"
map_public_ip_on_launch = "true"
tags= {
Name = "my-subnet1"
}
}

resource "aws_subnet" "subnet2"{
vpc_id = aws_vpc.vpc.id
cidr_block = "10.0.2.0/24"
availability_zone = "us-east-1b"
map_public_ip_on_launch = "true"
tags= {
Name = "my-subnet2"
}
}






