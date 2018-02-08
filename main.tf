provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-762f333fbfd5"
    key            = "project/test2/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-state-lock-762f333fbfd5"
  }
}

variable "default_tags" {
  type = "map"
  default = {
    "Owner" = "nobody@example.com"

    "TerraformManaged" = "true"
  }
}

data "aws_region" "current" { }


variable "office-cidrs" {
  default = [ "2.2.2.2/32" ]
}

variable "vpc_name" {
  default = "testvpc"
}

resource "aws_key_pair" "master" {
  key_name   = "me"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7X/AAA9QGhhpPETs4jTyEZmzHYNDibFh8TYShB/dQOzA8kTixnkn+qF856iojoXm9k5+FZUc3jM06wSY+Zf7a6YKdrCcS2qPNdbtRNez7ngKMJGZ4EBcNZdzd47TfT0ZPWC0COPb0gmVsZBsW+Au3a1sR4nhbpvyz8pMqkYrCKe1R+FAhfzUJufDuaAGg6sbdZ5mgO17q6INiIP5DN4MduNbU29zik5iR8odnskMcKOAzsTVsjNF3KcEm3uoGJaQUI8eV1rT/L4dWKAWHouIY1hfCv31+n28iwebRjbXXKHwGKZrlyfl7AQMg7O5NCdwlMG4tw/O6uX2TARfdkqh9"
}

# ami-ceafcba8
data "aws_ami" "amazon-linux-v1" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# ami-c2680fa4
data "aws_ami" "amazon-linux-v2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}
