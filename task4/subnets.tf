############ Private subnet

resource "aws_subnet" "private_subnet" {
  count = 3
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.subnet_az, count.index)


  tags = {
    Name = "${var.env}-private-sub-${count.index}"
  }
}

################ Public subnet

resource "aws_subnet" "public_subnet" {
  count = 3
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.subnet_az, count.index)


  tags = {
    Name = "${var.env}-public-sub-${count.index}"
  }
}