output "alb_sg_id"          { value = aws_security_group.alb_sg.id }
output "ec2_sg_id"          { value = aws_security_group.ec2_sg.id }
output "alb_internal_sg_id" { value = aws_security_group.alb_internal_sg.id }
output "app_sg_id"          { value = aws_security_group.app_sg.id }