resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = { Name = "main-vpc" }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.sub_pub_cidr_list[count.index]
  availability_zone = var.azs[count.index]
  tags              = { Name = "public-${count.index + 1}" }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.sub_prv_cidr_list[count.index]
  availability_zone = var.azs[count.index]
  tags              = { Name = "private-${count.index + 1}" }
}