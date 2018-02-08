
resource "aws_vpc" "vpc" {
  cidr_block = "10.128.0.0/16"

  assign_generated_ipv6_cidr_block = true

  tags = "${merge(var.default_tags, map(
    "Name", var.vpc_name
  ))}"
}

resource "aws_vpc_dhcp_options" "dopt" {
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-dopt"
  ))}"
}

resource "aws_vpc_dhcp_options_association" "dopt" {
  vpc_id          = "${aws_vpc.vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dopt.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-igw"
  ))}"
}

resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_subnet" "gw-a" {
  vpc_id          = "${aws_vpc.vpc.id}"
  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 4)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 4)}"

  availability_zone = "${data.aws_region.current.name}a"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-gw-a"
  ))}"
}

resource "aws_subnet" "gw-c" {
  vpc_id          = "${aws_vpc.vpc.id}"
  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 6)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 6)}"

  availability_zone = "${data.aws_region.current.name}c"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-gw-a"
  ))}"
}

resource "aws_subnet" "public-lb-a" {
  vpc_id          = "${aws_vpc.vpc.id}"
  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 8)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 8)}"

  availability_zone = "${data.aws_region.current.name}a"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-public-lb-a"
  ))}"
}

resource "aws_subnet" "public-lb-c" {
  vpc_id          = "${aws_vpc.vpc.id}"
  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 10)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 10)}"

  availability_zone = "${data.aws_region.current.name}c"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-public-lb-c"
  ))}"
}

resource "aws_subnet" "public-ec2-a" {
  vpc_id          = "${aws_vpc.vpc.id}"
  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 12)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 12)}"

  availability_zone = "${data.aws_region.current.name}a"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-public-ec2-a"
  ))}"
}

resource "aws_subnet" "public-ec2-c" {
  vpc_id          = "${aws_vpc.vpc.id}"
  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 14)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 14)}"

  availability_zone = "${data.aws_region.current.name}c"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-public-ec2-c"
  ))}"
}

resource "aws_subnet" "private-lb-a" {
  vpc_id          = "${aws_vpc.vpc.id}"
  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 32)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 32)}"

  availability_zone = "${data.aws_region.current.name}a"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-private-lb-a"
  ))}"
}

resource "aws_subnet" "private-lb-c" {
  vpc_id          = "${aws_vpc.vpc.id}"
  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 34)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 34)}"

  availability_zone = "${data.aws_region.current.name}c"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-private-lb-c"
  ))}"
}

resource "aws_subnet" "private-ec2-a" {
  vpc_id          = "${aws_vpc.vpc.id}"
  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 36)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 36)}"

  availability_zone = "${data.aws_region.current.name}a"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-private-ec2-a"
  ))}"
}

resource "aws_subnet" "private-ec2-c" {
  vpc_id          = "${aws_vpc.vpc.id}"
  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 38)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 38)}"

  availability_zone = "${data.aws_region.current.name}c"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-private-ec2-c"
  ))}"
}

resource "aws_subnet" "private-rds-a" {
  vpc_id          = "${aws_vpc.vpc.id}"
  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 48)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 48)}"

  availability_zone = "${data.aws_region.current.name}a"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-private-rds-a"
  ))}"
}

resource "aws_subnet" "private-rds-c" {
  vpc_id          = "${aws_vpc.vpc.id}"
  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 50)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 50)}"

  availability_zone = "${data.aws_region.current.name}c"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-private-rds-c"
  ))}"
}

resource "aws_route_table" "rt-gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_internet_gateway.igw.id}"
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-igw-a"
  ))}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_internet_gateway.igw.id}"
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-public"
  ))}"
}

resource "aws_route_table" "private-a" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.ngw-a.id}"
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = "${aws_egress_only_internet_gateway.eigw.id}"
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-private-a"
  ))}"
}

resource "aws_route_table" "private-c" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.ngw-c.id}"
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = "${aws_egress_only_internet_gateway.eigw.id}"
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-private-c"
  ))}"
}

resource "aws_route_table_association" "gw-a" {
  subnet_id      = "${aws_subnet.gw-a.id}"
  route_table_id = "${aws_route_table.rt-gw.id}"
}

resource "aws_route_table_association" "gw-c" {
  subnet_id      = "${aws_subnet.gw-c.id}"
  route_table_id = "${aws_route_table.rt-gw.id}"
}

resource "aws_route_table_association" "public-lb-a" {
  subnet_id      = "${aws_subnet.public-lb-a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-lb-c" {
  subnet_id      = "${aws_subnet.public-lb-c.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-ec2-a" {
  subnet_id      = "${aws_subnet.public-ec2-a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-ec2-c" {
  subnet_id      = "${aws_subnet.public-ec2-c.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private-lb-a" {
  subnet_id      = "${aws_subnet.private-lb-a.id}"
  route_table_id = "${aws_route_table.private-a.id}"
}

resource "aws_route_table_association" "private-lb-c" {
  subnet_id      = "${aws_subnet.private-lb-c.id}"
  route_table_id = "${aws_route_table.private-c.id}"
}

resource "aws_route_table_association" "private-ec2-a" {
  subnet_id      = "${aws_subnet.private-ec2-a.id}"
  route_table_id = "${aws_route_table.private-a.id}"
}

resource "aws_route_table_association" "private-ec2-c" {
  subnet_id      = "${aws_subnet.private-ec2-c.id}"
  route_table_id = "${aws_route_table.private-c.id}"
}

resource "aws_route_table_association" "private-rds-a" {
  subnet_id      = "${aws_subnet.private-rds-a.id}"
  route_table_id = "${aws_route_table.private-a.id}"
}

resource "aws_route_table_association" "private-rds-c" {
  subnet_id      = "${aws_subnet.private-rds-c.id}"
  route_table_id = "${aws_route_table.private-c.id}"
}

resource "aws_eip" "ngw-a" {
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_eip" "ngw-c" {
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_nat_gateway" "ngw-a" {
  allocation_id = "${aws_eip.ngw-a.id}"
  subnet_id     = "${aws_subnet.gw-a.id}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-ngw-a"
  ))}"
}

resource "aws_nat_gateway" "ngw-c" {
  allocation_id = "${aws_eip.ngw-c.id}"
  subnet_id     = "${aws_subnet.gw-c.id}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}-ngw-c"
  ))}"
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.vpc_name}"
  subnet_ids = ["${aws_subnet.private-rds-a.id}", "${aws_subnet.private-rds-c.id}"]

  tags = "${merge(var.default_tags, map(
    "Name", "${var.vpc_name}"
  ))}"
}
