variable "ami"               { type = string }
variable "instance_type"     { type = string }
variable "key_name"          { type = string }
variable "private_key_path"  { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids"{ type = list(string) }
variable "ec2_sg_id"         { type = string }
variable "app_sg_id"         { type = string }