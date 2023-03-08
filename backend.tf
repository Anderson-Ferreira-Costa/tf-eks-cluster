
terraform {
  backend "s3" {
    bucket  = "anderson-ferreira"
    key     = "terraform-state/tf-eks-cluster/terraform.tfstate"
    region  = "us-east-1"
    profile = "anderson"
  }
}