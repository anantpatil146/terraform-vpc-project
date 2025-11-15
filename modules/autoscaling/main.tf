resource "aws_launch_configuration" "web_lc" {
 name_prefix = "${var.env}-launch-config"
 image_id = var.ami_id
 instance_type = "t2.micro"
 key_name = var.key_name
 security_groups = [var.security_group_id]
 lifecycle {
 create_before_destroy = true
 }
}
resource "aws_autoscaling_group" "web_asg" {
 name = "${var.env}-asg"
 launch_configuration = aws_launch_configuration.web_lc.name
 min_size = 1
 max_size = 3
 desired_capacity = 2
 vpc_zone_identifier = [var.subnet_id]
 health_check_type = "EC2"
 target_group_arns = [aws_lb_target_group.web_tg.arn]
 force_delete = true
}
resource "aws_lb" "web_lb" {
 name = "${var.env}-lb"
 internal = false
 load_balancer_type = "application"
 subnets = [var.subnet_id]
}
resource "aws_lb_target_group" "web_tg" {
 name = "${var.env}-tg"
 port = 80
 protocol = "HTTP"
 vpc_id = var.vpc_id
}
resource "aws_lb_listener" "web_listener" {
 load_balancer_arn = aws_lb.web_lb.arn
 port = 80
 protocol = "HTTP"
 default_action {
 type = "forward"
 target_group_arn = aws_lb_target_group.web_tg.arn
 }
}
output "load_balancer_dns" {
 value = aws_lb.web_lb.dns_name
}
