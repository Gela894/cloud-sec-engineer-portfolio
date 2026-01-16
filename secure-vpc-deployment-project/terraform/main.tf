terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  tags = {
    Name = "secure-vpc"
  }
}
# Create a public subnet
resource "aws_subnet" "publicAPP_A" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "secure-vpc-publicAPP_A-subnetA"
  }
}
# Create a second public subnet

resource "aws_subnet" "publicAPP_B" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
      Name = "secure-vpc-publicAPP_B-subnetB"
    }
}
# Create a private subnet
resource "aws_subnet" "privateAPP_A" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "secure-vpc-privateAPP_A-subnetA"
  }
}
# Create a second private subnet
resource "aws_subnet" "privateAPP_B" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "secure-vpc-privateAPP_B-subnetB"
  }
}
# Create a third private subnet
resource "aws_subnet" "privateData_A" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "secure-vpc-privateData_A-subnetA"
  }
}
# Create a fourth private subnet
resource "aws_subnet" "privateData_B" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "secure-vpc-privateData_B-subnetB"
  }
}
# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "secure-vpc-igw"
  }
}
# Create a Public Route Table to route traffic to the Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "secure-vpc-public-rt"
  }
}
# Create a route to the Internet Gateway in the Public Route Table

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id
}
# Create a PrivateApp Route Table
resource "aws_route_table" "privateAPP_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "secure-vpc-privateAPP-rt"
  }
}
# Create a PrivateData Route Table
resource "aws_route_table" "privateData_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "secure-vpc-privateData-rt"
  }
}
# Associate Public Subnets with the Public Route Table
resource "aws_route_table_association" "publicAPP_A_assoc" {
  subnet_id      = aws_subnet.publicAPP_A.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "publicAPP_B_assoc" {
  subnet_id      = aws_subnet.publicAPP_B.id
  route_table_id = aws_route_table.public_rt.id
}
# Associate PrivateApp Subnets with the PrivateApp Route Table
resource "aws_route_table_association" "privateAPP_A_assoc" {
  subnet_id      = aws_subnet.privateAPP_A.id
  route_table_id = aws_route_table.privateAPP_rt.id
}
resource "aws_route_table_association" "privateAPP_B_assoc" {
  subnet_id      = aws_subnet.privateAPP_B.id
  route_table_id = aws_route_table.privateAPP_rt.id
}
# Associate PrivateData Subnets with the PrivateData Route Table
resource "aws_route_table_association" "privateData_A_assoc" {
  subnet_id      = aws_subnet.privateData_A.id
  route_table_id = aws_route_table.privateData_rt.id
}
resource "aws_route_table_association" "privateData_B_assoc" {
  subnet_id      = aws_subnet.privateData_B.id
  route_table_id = aws_route_table.privateData_rt.id
}
