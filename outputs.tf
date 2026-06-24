output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "External ALB — hit this in your browser"
}

output "internal_alb_dns_name" {
  value       = module.alb.internal_alb_dns_name
  description = "Internal ALB DNS"
}

output "web_1_public_ip" {
  value = module.compute.web_1_public_ip
}

output "web_2_public_ip" {
  value = module.compute.web_2_public_ip
}

output "app_1_private_ip" {
  value = module.compute.app_1_private_ip
}

output "app_2_private_ip" {
  value = module.compute.app_2_private_ip
}