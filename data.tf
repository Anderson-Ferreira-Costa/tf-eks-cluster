data "aws_caller_identity" "current" {}

data "aws_subnets" "subnets" {
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_subnet" "subnet" {
  id = element(data.aws_subnets.subnets.ids, 0)
}