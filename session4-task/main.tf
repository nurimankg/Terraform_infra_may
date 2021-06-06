#################### vpc

resource "aws_vpc" "main_vpc" {
    cidr_block = var.vpc_cidr

    tags = {
       Name = "${var.env}-vpc"
  }
}

################## Private subnets

resource "aws_subnet" "private_subnets" {
  count = 3
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.subnet_az, count.index)

  tags = {
    "Name" = "${var.env}-private_sub_${count.index}"
  }
}

################# Public subnets

resource "aws_subnet" "public_subnets" {
  count = 3
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.subnet_az, count.index)
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.env}-public_subnets_${count.index}"
  }
}

################# Private route table

resource "aws_route_table" "privat_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.internet_access
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "${var.env}-private_routetable"
  }
}

resource "aws_route_table_association" "private_a" {
  count = 3
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.privat_rt.id
}


################## Public route table

resource "aws_route_table" "pulic_rt" {
   vpc_id = aws_vpc.main_vpc.id
   

  route {
    cidr_block = var.internet_access
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.env}-public_routetable"
  }
 }

resource "aws_route_table_association" "public_b" {
    count = 3
    subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
    route_table_id = aws_route_table.privat_rt.id
}

################ Internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.env}-internet_gw"
  }
}

################### Nat gateway

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id  = aws_subnet.public_subnets.0.id

  tags = {
    Name = "${var.env}-nat_gateway"
  }
}

#################### Nat gateway EIP

resource "aws_eip" "nat-eip" {
  vpc = true
  tags = {
    Name = "${var.env}-nat_gw_eip"
  }
}
