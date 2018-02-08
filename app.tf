resource "random_id" "app-instance" {
  byte_length = 6
}

resource "aws_lb" "app" {
  name               = "app-${random_id.app-instance.hex}"
  load_balancer_type = "application"
  ip_address_type    = "dualstack"
  subnets            = ["${aws_subnet.public-lb-a.id}", "${aws_subnet.public-lb-c.id}"]
  security_groups    = ["${aws_security_group.app-lb.id}"]

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-public"
  ))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "app-HTTP" {
  protocol = "HTTP"
  port     = 80
  vpc_id   = "${aws_vpc.vpc.id}"

  health_check {
    interval = 6
  }
}

resource "aws_lb_listener" "app-HTTP" {
  load_balancer_arn = "${aws_lb.app.arn}"
  protocol          = "HTTP"
  port              = 80

  default_action {
    target_group_arn = "${aws_lb_target_group.app-HTTP.arn}"
    type             = "forward"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app-instance" {
  description = "APP Instance"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags = "${merge(var.default_tags, map(
    "Name", "app"
  ))}"
}

resource "aws_security_group_rule" "app-instance-ingress-bastion" {
  security_group_id        = "${aws_security_group.app-instance.id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = "${aws_security_group.bastion.id}"
}

resource "aws_security_group_rule" "app-instance-ingress-lb" {
  security_group_id        = "${aws_security_group.app-instance.id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = "${aws_security_group.app-lb.id}"
}

resource "aws_security_group_rule" "app-instance-egress" {
  security_group_id = "${aws_security_group.app-instance.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "app-lb" {
  description = "APP LB"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags = "${merge(var.default_tags, map(
    "Name", "app-lb"
  ))}"
}

resource "aws_security_group_rule" "app-lb-ingress" {
  security_group_id = "${aws_security_group.app-lb.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["${var.office-cidrs}"]
}

resource "aws_security_group_rule" "app-lb-egress-instance" {
  security_group_id        = "${aws_security_group.app-lb.id}"
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = "${aws_security_group.app-instance.id}"
}

# https://www.terraform.io/docs/providers/template/d/cloudinit_config.html
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
data "template_cloudinit_config" "app" {
  part {
    filename     = "init.cfg"
    content_type = "text/part-handler"
    content      = "output : { all : '| tee -a /var/log/cloud-init-output.log' }"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${file("app-userdata.sh")}"
  }
}

resource "aws_launch_configuration" "app" {
  name_prefix     = "app-${random_id.app-instance.hex}-"
  image_id        = "${data.aws_ami.amazon-linux-v1.id}"
  instance_type   = "t2.nano"
  key_name        = "${aws_key_pair.master.key_name}"
  security_groups = ["${aws_security_group.app-instance.id}"]

  user_data = "${data.template_cloudinit_config.app.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  vpc_zone_identifier       = ["${aws_subnet.private-ec2-a.id}", "${aws_subnet.private-ec2-c.id}"]
  name                      = "app-${random_id.app-instance.hex}"
  launch_configuration      = "${aws_launch_configuration.app.name}"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 30
  health_check_type         = "EC2"
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  force_delete              = true
  target_group_arns         = ["${aws_lb_target_group.app-HTTP.arn}"]

  timeouts {
    delete = "2m"
  }

  tag {
    key                 = "Name"
    value               = "app-${random_id.app-instance.hex}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "nobody@example.com"
    propagate_at_launch = true
  }
}
