output "alb_dns_name"          { value = aws_lb.external.dns_name }
output "internal_alb_dns_name" { value = aws_lb.internal.dns_name }