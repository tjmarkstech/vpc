variable "ami" {
    default  = "ami-03ededff12e34e59e"

}
variable "instance_type" {
    default = "t2.micro"

}
variable "region" {
    default = "us-east-1"

}
variable "cidr_block_spoke" {
    default = "10.0.0.0/16"
  
}

variable "cidr_block_transit" {
    default = "20.0.0.0/16"
  
}

variable "peer_owner_id" {
    default = ""
}

variable "aws_vpc_peering_connection_id" {
    default = ""
}
  
