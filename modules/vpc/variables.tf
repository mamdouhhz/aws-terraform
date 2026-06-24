variable "vpc_cidr"          { type = string }
variable "sub_pub_cidr_list" { type = list(string) }
variable "sub_prv_cidr_list" { type = list(string) }
variable "azs"               { type = list(string) }