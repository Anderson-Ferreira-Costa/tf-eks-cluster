module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.4"

  cluster_name    = local.cluster_name
  cluster_version = "1.24"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.public_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"
      instance_types = ["t3.micro"]
      min_size     = 1
      max_size     = 5
      desired_size = 2

    # block_device_mappings = {
    #     xvda = {
    #       device_name = "/dev/xvda"
    #       ebs = {
    #         volume_size           = 75
    #         volume_type           = "gp3"
    #         iops                  = 3000
    #         throughput            = 150
    #         encrypted             = true
    #         delete_on_termination = true
    #       }
    #     }
    #   }
    }
    
  #  two = {
  #     name = "node-group-2"
  #     instance_types = ["t3.micro"]
  #     min_size     = 1
  #     max_size     = 3
  #     desired_size = 2
  #   }
  }
 }
