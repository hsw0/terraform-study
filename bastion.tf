resource "random_id" "bastion-instance" {
  byte_length = 6
}

resource "aws_instance" "bastion" {
  ami           = "${data.aws_ami.amazon-linux-v1.id}"
  instance_type = "t2.nano"

  key_name = "${aws_key_pair.master.key_name}"

  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  subnet_id = "${aws_subnet.private-ec2-a.id}"

  tags = "${merge(var.default_tags, map(
    "Name", "bastion-${random_id.bastion-instance.hex}"
  ))}"
}

resource "aws_security_group" "bastion" {
  description = "Jumpbox Instance"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags = "${merge(var.default_tags, map(
    "Name", "bastion"
  ))}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.office-cidrs}"]
  }

  # LB Health check
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${aws_subnet.public-lb-a.cidr_block}", "${aws_subnet.public-lb-c.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "nlb-bastion" {
  name               = "bastion-${random_id.bastion-instance.hex}"
  load_balancer_type = "network"
  internal           = false

  subnet_mapping {
    subnet_id = "${aws_subnet.public-lb-a.id}"
  }

  subnet_mapping {
    subnet_id = "${aws_subnet.public-lb-c.id}"
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-public"
  ))}"

  lifecycle {
    create_before_destroy = true
  }
}

output "bastion-hostname" {
  value = "${aws_lb.nlb-bastion.dns_name}"
}

resource "aws_lb_target_group" "nlb-bastion" {
  port     = 22
  protocol = "TCP"
  vpc_id   = "${aws_vpc.vpc.id}"
}

resource "aws_lb_target_group_attachment" "nlb-bastion" {
  target_group_arn = "${aws_lb_target_group.nlb-bastion.arn}"
  target_id        = "${aws_instance.bastion.id}"
  port             = 22
}

resource "aws_lb_listener" "nlb-bastion" {
  load_balancer_arn = "${aws_lb.nlb-bastion.arn}"
  port              = "22"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.nlb-bastion.arn}"
    type             = "forward"
  }

  lifecycle {
    create_before_destroy = true
  }
}

/*
resource "aws_eip" "bastion" {
  vpc = true

  instance   = "${aws_instance.bastion.id}"
  depends_on = ["aws_internet_gateway.igw"]
}
*/

