################  Public Route Table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  
#     route {
#     cidr_block = var.internet_access
#     # gateway_id = aws_internet_gateway.example.id
#   }

  tags = {
    Name = "${var.env}-pub_rt"
  }
}

resource "aws_route_table_association" "public_rt_as" {
  count = 3
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}


################  Private Route Table

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  
#     route {
#     cidr_block = var.internet_access
#     # gateway_id = aws_internet_gateway.example.id
#   }

  tags = {
    Name = "${var.env}-private_rt"
  }
}

resource "aws_route_table_association" "private_rt_as" {
  count = 3
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}
