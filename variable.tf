variable "project_name" {
    type = string
}

variable "vpc_tags" {
    type = map
    default = {}
}

variable "vpc_cidr" {
    type = string
}

variable "igw_tags" {
    type = map
    default = {}
}

variable "public_subnet_tags" {
    type = map
    default = {}
}

variable "public_subnet_cidr" {
    type = list 
    description = "please provide 2 public subnet CIDR"

    validation {
    condition = (
      length(var.public_subnet_cidr) == 2 
      )
      error_message = "CIDR list must be 2"
  }
}

variable "public_route_table_tags" {
    type = map
    default = {}
}

variable "private_subnet_tags" {
    type = map
    default = {}
}

variable "private_subnet_cidr" {
    type = list 
    description = "please provide 2 private subnet CIDR"

    validation {
    condition = (
      length(var.private_subnet_cidr) == 2 
      )
      error_message = "CIDR list must be 2"
  }
}

variable "private_route_table_tags" {
    type = map
    default = {}
}
variable "database_subnet_tags" {
    type = map
    default = {}
}

variable "database_subnet_cidr" {
    type = list 
    description = "please provide 2 database subnet CIDR"

    validation {
    condition = (
      length(var.database_subnet_cidr) == 2 
      )
      error_message = "CIDR list must be 2"
  }
}

variable "database_route_table_tags" {
    type = map
    default = {}
}
variable "eip_tags" {
    type = map
    default = {}
}

variable "nat_gateway_tags" {
    type = map
    default = {}
}