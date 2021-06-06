## vpc

resource "aws_vpc" "main_vpc" {
    cidr_block = var.vpc_cidr

    tags = {
       Name = "${var.env}-vpc"
  }
}

## Private subnets

resource "aws_subnet" "private_subnets" {
  count = 3
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.subnet_az, count.index)

  tags = {
    "Name" = "${var.env}-private_sub_${count.index}"
  }
}

## Public subnets

resource "aws_subnet" "public_subnets" {
  count = 3
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.subnet_az, count.index)

  tags = {
    "Name" = "${var.env}-public_subnets_${count.index}"
  }
}