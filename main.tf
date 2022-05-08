# ##################################################################################################################
# # CREATE SPOKE EC2 INSTANCE (CSR_1)
# ##################################################################################################################
# resource "aws_instance" "test-servers" {
#     ami           = var.ami
#     instance_type = var.instance_type
#     subnet_id = 

#     tags = {
#     Name = "SPOKE-CSR_1"
#   }

# }


##################################################################################################################
# CREATE SPOKE_VPC & 2 PRIVATE SUBNETS IN 2 AZs
##################################################################################################################
resource "aws_vpc" "spoke" {
  cidr_block              = var.cidr_block_spoke
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags = {
    Name = "SPOKE-VPC"
  }
}

resource "aws_subnet" "spoke_private_subnet_1" {
  vpc_id     = aws_vpc.spoke.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "SPOKE_Private_Subnet_1"
  }
}

resource "aws_subnet" "spoke_private_subnet_2" {
  vpc_id     = aws_vpc.spoke.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "SPOKE_Private_Subnet_2"
  }
}


##################################################################################################################
# CREATE SPOKE_ROUTE TABLE
##################################################################################################################

resource "aws_route_table" "spoke_private_route_table" {
  vpc_id = aws_vpc.spoke.id

  # route {
  #   cidr_block = ["10.0.0.0/24, 10.0.1.0/24"]
  # }

  tags = {
    Name = "SPOKE_ROUTE_TABLE"
  }
}

  resource "aws_route_table_association" "spoke_private_subnet_1_route_table_association" {
  subnet_id      = aws_subnet.spoke_private_subnet_1.id
  route_table_id = aws_route_table.spoke_private_route_table.id
}

 resource "aws_route_table_association" "spoke_private_subnet_2_route_table_association" {
  subnet_id      = aws_subnet.spoke_private_subnet_2.id
  route_table_id = aws_route_table.spoke_private_route_table.id
}




#################################################################################################################################
#################################################################################################################################
#################################################################################################################################
#################################################################################################################################





##################################################################################################################
# CREATE TRANSIT_VPC & 2 PRIVATE SUBNETS IN 2 AZs
##################################################################################################################
resource "aws_vpc" "transit" {
  cidr_block              = var.cidr_block_transit
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags = {
    Name = "TRANSIT-VPC"
  }
}

resource "aws_subnet" "transit_private_subnet_1" {
  vpc_id     = aws_vpc.transit.id
  cidr_block = "20.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "TRANSIT_Private_Subnet_1"
  }
}

resource "aws_subnet" "transit_private_subnet_2" {
  vpc_id     = aws_vpc.transit.id
  cidr_block = "20.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "TRANSIT_Private_Subnet_2"
  }
}

##################################################################################################################
# CREATE TRANSIT_ROUTE TABLE
##################################################################################################################

resource "aws_route_table" "transit_private_route_table" {
  vpc_id = aws_vpc.transit.id

  # route {
  #   cidr_block = ["20.0.0.0/24, 20.0.1.0/24"]
  # }
  
  tags = {
    Name = "SPOKE_ROUTE_TABLE"
  }
}

  resource "aws_route_table_association" "transit_private_subnet_1_route_table_association" {
  subnet_id      = aws_subnet.transit_private_subnet_1.id
  route_table_id = aws_route_table.transit_private_route_table.id
}

 resource "aws_route_table_association" "transit_private_subnet_2_route_table_association" {
  subnet_id      = aws_subnet.transit_private_subnet_2.id
  route_table_id = aws_route_table.transit_private_route_table.id
}


####################################################################################################################
# CREATE VPC PEERING
####################################################################################################################
resource "aws_vpc_peering_connection" "peer" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.transit.id
  vpc_id        = aws_vpc.spoke.id
  peer_region   = var.region

  tags = {
    Name = "VPC_PEERING_FOR_SPOKE_TRANSIT"
  }

}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}