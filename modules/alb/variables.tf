variable "vpc_id"             { type = string }
variable "public_subnet_ids"  { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "alb_sg_id"          { type = string }
variable "alb_internal_sg_id" { type = string }
variable "web_instance_ids"   { type = list(string) }
variable "app_instance_ids"   { type = list(string) }