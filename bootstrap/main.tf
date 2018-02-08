provider "aws" {
  region = "ap-northeast-2"
}

resource "random_id" "stack_id" {
  byte_length = 6
}

locals {
  s3_bucket = "terraform-state-${random_id.stack_id.hex}"

  lock_dynamodb_table = "terraform-state-lock-${random_id.stack_id.hex}"
}

/*
terraform {
  backend "s3" {
    bucket         = "terraform-state-XXXXXXXXXXXX"
    key            = "project/bootstrap-backend/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-state-lock-XXXXXXXXXXXX"
  }
}
*/

variable "default_tags" {
  type = "map"

  default = {
    "TerraformManaged" = "true"
  }
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "${local.s3_bucket}"
  region = "ap-northeast-2"

  versioning {
    enabled = true
  }

  acl = "private"

  tags = "${merge(var.default_tags, map(
    "Service", "test"
  ))}"
}

resource "aws_dynamodb_table" "tfstate-lock" {
  name = "${local.lock_dynamodb_table}"

  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "tfstate-bucket" {
  value = "${aws_s3_bucket.tfstate.bucket}"
}

output "tfstate-lock" {
  value = "${aws_dynamodb_table.tfstate-lock.name}"
}
