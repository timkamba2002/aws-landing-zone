resource "aws_launch_template" "this" {
  name_prefix   = "${var.name}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    security_groups = [var.security_group_id]
    subnet_id       = var.subnet_id
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.name}-instance"
    }
  }
}
