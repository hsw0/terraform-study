resource "random_id" "jumpbox-instance" {
  byte_length = 6
}

resource "aws_instance" "jumpbox" {
  ami           = "${data.aws_ami.amazon-linux-v1.id}"
  instance_type = "t2.nano"

  key_name = "${aws_key_pair.master.key_name}"

  vpc_security_group_ids = ["${aws_security_group.jumpbox.id}"]

  subnet_id = "${aws_subnet.private-ec2-a.id}"

  tags = "${merge(var.default_tags, map(
    "Name", "jumpbox-${random_id.jumpbox-instance.hex}"
  ))}"
}

resource "aws_security_group" "jumpbox" {
  description = "Jumpbox Instance"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags = "${merge(var.default_tags, map(
    "Name", "jumpbox"
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
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "nlb-jumpbox" {
  name               = "jumpbox-${random_id.jumpbox-instance.hex}"
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
}

output "jumpbox-hostname" {
  value = "${aws_lb.nlb-jumpbox.dns_name}"
}

resource "aws_lb_target_group" "nlb-jumpbox" {
  port     = 22
  protocol = "TCP"
  vpc_id   = "${aws_vpc.vpc.id}"
}

resource "aws_lb_target_group_attachment" "nlb-jumpbox" {
  target_group_arn = "${aws_lb_target_group.nlb-jumpbox.arn}"
  target_id        = "${aws_instance.jumpbox.id}"
  port             = 22
}

resource "aws_lb_listener" "nlb-jumpbox" {
  load_balancer_arn = "${aws_lb.nlb-jumpbox.arn}"
  port              = "22"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.nlb-jumpbox.arn}"
    type             = "forward"
  }
}

/*
resource "aws_eip" "jumpbox" {
  vpc = true

  instance   = "${aws_instance.jumpbox.id}"
  depends_on = ["aws_internet_gateway.igw"]
}
*/

