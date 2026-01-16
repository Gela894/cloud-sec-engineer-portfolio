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

#Create a NAT Gateway per AZ
resource "aws_nat_gateway" "nat_gw_A" {
  allocation_id = aws_eip.nat_eip_A.id
  subnet_id     = aws_subnet.publicAPP_A.id
  tags = {
    Name = "secure-vpc-nat-gw-A"
  }
}
resource "aws_nat_gateway" "nat_gw_B" {
  allocation_id = aws_eip.nat_eip_B.id
  subnet_id     = aws_subnet.publicAPP_B.id
  tags = {
    Name = "secure-vpc-nat-gw-B"
  }
}
# Create an Elastic IP for each NAT Gateway
resource "aws_eip" "nat_eip_A" {
  domain = "vpc"
}
resource "aws_eip" "nat_eip_B" {
  domain = "vpc"
}
# Update the PrivateApp Route Table to include routes to the NAT Gateways
resource "aws_route" "privateAPP_nat_gw_A" {
  route_table_id         = aws_route_table.privateAPP_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_A.id
}
resource "aws_route" "privateAPP_nat_gw_B" {
  route_table_id         = aws_route_table.privateAPP_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_B.id
}
# Update the PrivateData Route Table to include routes to the NAT Gateways
resource "aws_route" "privateData_nat_gw_A" {
  route_table_id         = aws_route_table.privateData_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_A.id
}
resource "aws_route" "privateData_nat_gw_B" {
  route_table_id         = aws_route_table.privateData_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_B.id
}
# Verify private subnets do not automatically assign public IPs
resource "aws_subnet_public_ip_on_launch" "privateAPP_A_no_public_ip" {
  subnet_id                 = aws_subnet.privateAPP_A.id
  map_public_ip_on_launch   = false
}
# Create VPC Endpoints for S3 and Interface Endpoints for other services (SSM, EC2 messages, SSM messages, CloudWatch logs)
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region_name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.privateAPP_rt.id, aws_route_table.privateData_rt.id]
  tags = {
    Name = "secure-vpc-s3-endpoint"
  }
}
resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region_name}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.privateAPP_A.id, aws_subnet.privateAPP_B.id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  tags = {
    Name = "secure-vpc-ssm-endpoint"
  }
}
resource "aws_vpc_endpoint" "ec2_messages_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region_name}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.privateAPP_A.id, aws_subnet.privateAPP_B.id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  tags = {
    Name = "secure-vpc-ec2-messages-endpoint"
  }
}
resource "aws_vpc_endpoint" "ssm_messages_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region_name}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.privateAPP_A.id, aws_subnet.privateAPP_B.id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  tags = {
    Name = "secure-vpc-ssm-messages-endpoint"
  }
}
resource "aws_vpc_endpoint" "cloudwatch_logs_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region_name}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.privateAPP_A.id, aws_subnet.privateAPP_B.id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  tags = {
    Name = "secure-vpc-cloudwatch-logs-endpoint"
  }
}
