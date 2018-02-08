resource "aws_route53_zone" "internal" {
  name = "test.in."
}

resource "aws_route53_record" "bastion" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "bastion.${aws_route53_zone.internal.name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.nlb-bastion.dns_name}"
    zone_id                = "${aws_lb.nlb-bastion.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "app-A" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "www.${aws_route53_zone.internal.name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.app.dns_name}"
    zone_id                = "${aws_lb.app.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "app-AAAA" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "www.${aws_route53_zone.internal.name}"
  type    = "AAAA"

  alias {
    name                   = "${aws_lb.app.dns_name}"
    zone_id                = "${aws_lb.app.zone_id}"
    evaluate_target_health = false
  }
}
