resource "aws_vpc" "main" {
    cidr_block       =  var.vpc_cidr
    instance_tenancy =  local.instance_tenancy
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = var.vpc_tags
    
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = var.igw_tags
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  count = length(var.public_subnet_cidr)
  cidr_block =  var.public_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]
  tags = merge(
    var.public_subnet_tags ,
    {
        Name = "${var.project_name}-public-${local.azs_labels[count.index]}"
    }
  )
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }  
    tags = merge(
    var.public_route_table_tags ,
    {
        Name = "${var.project_name}-public"
      } 
    )
}


resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr) # this will fetch the length of public subnets
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index) # this will iterate and each time it gives single element
  route_table_id = aws_route_table.public.id
}
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  count = length(var.private_subnet_cidr)
  cidr_block =  var.private_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]
  tags = merge(
    var.private_subnet_tags ,
    {
        Name = "${var.project_name}-private-${local.azs_labels[count.index]}"
    }
  )
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }  
    tags = merge(
    var.private_route_table_tags ,
    {
        Name = "${var.project_name}-private"
      } 
    )
}


resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr) # this will fetch the length of public subnets
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index) # this will iterate and each time it gives single element
  route_table_id = aws_route_table.private.id
}
resource "aws_subnet" "database_subnet" {
  vpc_id     = aws_vpc.main.id
  count = length(var.database_subnet_cidr)
  cidr_block =  var.database_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]
  tags = merge(
    var.database_subnet_tags ,
    {
        Name = "${var.project_name}-database-${local.azs_labels[count.index]}"
    }
  )
}
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }  
    tags = merge(
    var.database_route_table_tags ,
    {
        Name = "${var.project_name}-database"
      } 
    )
}


resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr) # this will fetch the length of public subnets
  subnet_id      = element(aws_subnet.database_subnet[*].id, count.index) # this will iterate and each time it gives single element
  route_table_id = aws_route_table.database.id
}

resource "aws_eip" "nat" {
  domain   = "vpc"
  tags = merge(
    var.eip_tags ,
    {
        Name = var.project_name
      } 
    )

}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${ aws_eip.nat.id }"
  subnet_id     = "${ aws_subnet.public_subnet[0].id }"
  tags = merge(
    var.nat_gateway_tags ,
    {
        Name = var.project_name
      } 
    )
}