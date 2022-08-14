resource "aws_default_vpc" "default" {
}

resource "aws_subnet" "us-east-1a" {
  vpc_id                  = aws_default_vpc.default.id
  availability_zone       = "us-east-1a"
  cidr_block              = "172.31.0.0/20"
  map_public_ip_on_launch = true
  tags                    = {}
}

resource "aws_subnet" "us-east-1b" {
  vpc_id                  = aws_default_vpc.default.id
  availability_zone       = "us-east-1b"
  cidr_block              = "172.31.80.0/20"
  map_public_ip_on_launch = true
  tags                    = {}
}

resource "aws_subnet" "us-east-1c" {
  vpc_id                  = aws_default_vpc.default.id
  availability_zone       = "us-east-1c"
  cidr_block              = "172.31.16.0/20"
  map_public_ip_on_launch = true
  tags                    = {}
}

resource "aws_subnet" "us-east-1d" {
  vpc_id                  = aws_default_vpc.default.id
  availability_zone       = "us-east-1d"
  cidr_block              = "172.31.32.0/20"
  map_public_ip_on_launch = true
  tags                    = {}
}

resource "aws_subnet" "us-east-1e" {
  vpc_id                  = aws_default_vpc.default.id
  availability_zone       = "us-east-1e"
  cidr_block              = "172.31.48.0/20"
  map_public_ip_on_launch = true
  tags                    = {}
}

resource "aws_subnet" "us-east-1f" {
  vpc_id                  = aws_default_vpc.default.id
  availability_zone       = "us-east-1f"
  cidr_block              = "172.31.64.0/20"
  map_public_ip_on_launch = true
  tags                    = {}
}

