resource "aws_route_table" "myrt"{
vpc_id = aws_vpc.vpc.id
route{
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}
tags = {
name = "myroutetable"
}
}

resource "aws_route_table_association" "sn1"{
subnet_id = aws_subnet.subnet1.id
route_table_id = aws_route_table.myrt.id
}

resource "aws_route_table_association" "sn2"{
subnet_id = aws_subnet.subnet2.id
route_table_id = aws_route_table.myrt.id
}

