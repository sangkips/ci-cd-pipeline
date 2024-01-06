# Create AWS instance

resource "aws_instance" "ci-cd" {
  instance_type = var.instance_type
  ami           = var.ami
}
# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc-cidr

}

# Check availability zones in each region
data "aws_availability_zones" "aws_availability_azs" {
  state = "available"
}

# Create public subnets
resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, each.value + 100)
  availability_zone       = tolist(data.aws_availability_zones.aws_availability_azs.names)[each.value - 1]
  map_public_ip_on_launch = true

}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  for_each                = var.private_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, each.value)
  availability_zone       = tolist(data.aws_availability_zones.aws_availability_azs.names)[each.value - 1]
  map_public_ip_on_launch = false
}

# Create route table for public subnets
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main-nat-gw.id
  }
}

# Associate public route table with public subnets
resource "aws_route_table_association" "public-rta" {
  depends_on     = [aws_subnet.public_subnets]
  route_table_id = aws_route_table.public-rt.id
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
}

# Associate private route table with private subnets
resource "aws_route_table_association" "private-rta" {
  depends_on     = [aws_subnet.private_subnets]
  route_table_id = aws_route_table.private-rt.id
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
}

# Create internet gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id
}

# Create a elastic IP NAT gateway
resource "aws_eip" "main-eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main-igw]
}

# Create a nat gateway
resource "aws_nat_gateway" "main-nat-gw" {
  depends_on    = [aws_subnet.public_subnets]
  subnet_id     = aws_subnet.public_subnets["public_subnet-1"].id
  allocation_id = aws_eip.main-eip.id
}


# Create S3 bucket
resource "aws_s3_bucket" "kips-bucket" {
  bucket = "kips-bucket"
}

# Create DynamoDB for locking the state file.
# It will bill you per request made
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}