provider "aws" {
  region  = local.region
  profile = "anderson"
}

locals {
  name            = "my-eks"
  cluster_version = "1.29"
  region          = "us-east-1"

  vpc_id     = data.aws_subnet.subnet.vpc_id
  subnet_ids = data.aws_subnets.subnets.ids
}

################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name                             = local.name
  cluster_version                          = local.cluster_version
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids
  # vpc_id                   = module.vpc.vpc_id
  # subnet_ids               = module.vpc.private_subnets
  # control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_groups = {

    default_node_group = {

      # capacity_type        = "SPOT"
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.micro"]

      desired_size = 3
      min_size     = 1
      max_size     = 10

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 10
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 125
            encrypted             = true
            delete_on_termination = true
          }
        }
      }
      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }
    }
  }
}

# module "eks_aws_auth" {
#   source                    = "terraform-aws-modules/eks/aws//modules/aws-auth"
#   version                   = "20.8.5"

#   manage_aws_auth_configmap = true

#   aws_auth_roles = [
#     {
#       rolearn  = "arn:aws:iam::66666666666:role/role1"
#       username = "role1"
#       groups   = ["custom-role-group"]
#     },
#   ]

#   aws_auth_users = [
#     {
#       userarn  = "arn:aws:iam::66666666666:user/user1"
#       username = "user1"
#       groups   = ["custom-users-group"]
#     },
#   ]
# }