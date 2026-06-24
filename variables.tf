variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "sub_pub_cidr_list" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "sub_prv_cidr_list" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "ami" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "private_key_path" {
  description = "Local path to the private key for SSH"
  type        = string
}