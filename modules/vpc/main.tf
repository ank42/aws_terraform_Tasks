# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "Public" {
  count = length(var.public_subnet_ids)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_ids[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public${count.index}"
  }
}

resource "aws_subnet" "Private" {
  count = length(var.private_subnet_ids)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_ids[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_eip" "nat" {
  count = length(var.private_subnet_ids)

  vpc = true
}

resource "aws_nat_gateway" "main" {
  count = length(var.private_subnet_ids)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.Public[count.index].id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_ids)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "private${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.private_subnet_ids)

  subnet_id      = aws_subnet.Public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_ids)

  subnet_id      = aws_subnet.Private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
