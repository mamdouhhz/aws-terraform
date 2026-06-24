output "web_instance_ids"  { value = [aws_instance.web_1.id, aws_instance.web_2.id] }
output "app_instance_ids"  { value = [aws_instance.app_1.id, aws_instance.app_2.id] }
output "web_1_public_ip"   { value = aws_instance.web_1.public_ip }
output "web_2_public_ip"   { value = aws_instance.web_2.public_ip }
output "app_1_private_ip"  { value = aws_instance.app_1.private_ip }
output "app_2_private_ip"  { value = aws_instance.app_2.private_ip }