## Private route table

resource "aws_route_table" "privat_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.internet_access
  }
  tags = {
    Name = "${var.env}-private_routetable"
  }


## Route tables association

resource "aws_route_table_association" "private_a" {
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.privat_rt.id
}

## Public route table

resource "aws_route_table" "pulic_rt" {
   vpc_id = aws_vpc.main_vpc.id
   gateway_id = aws_internet_gateway.gw.id

  route {
    cidr_block = var.internet_access

  tags = {
    Name = "${var.env}-public_routetable"
  }
 }

resource "aws_route_table_association" "public_b" {
    count = 3
    subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
    route_table_id = aws_route_table.privat_rt.id
}

## Internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.env}-internet_gw"
  }
}

## Nat gateway

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id  = aws_subnet.privat_rt.id

  tags = {
    Name = "${var.env}-nat_gateway"
  }
}

## Nat gateway EIP

resource "aws_eip" "nat-eip" {
  vpc = true
  tags = {
    Name = "${var.env}-nat_gw_eip"
  }
}
}
}