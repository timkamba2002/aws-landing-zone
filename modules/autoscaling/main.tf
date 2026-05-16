resource "aws_autoscaling_group" "this" {
  name                      = "${var.name}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.min_size
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 30

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-instance"
    propagate_at_launch = true
  }
}
