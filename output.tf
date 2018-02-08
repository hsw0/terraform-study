output "vpc-id" {
  value = "${aws_vpc.vpc.id}"
}

output "ngw-a-public_ip" {
  value = "${aws_nat_gateway.ngw-a.public_ip}"
}

output "ngw-c-public_ip" {
  value = "${aws_nat_gateway.ngw-c.public_ip}"
}
