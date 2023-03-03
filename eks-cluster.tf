module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.4"

  cluster_name    = local.cluster_name
  cluster_version = "1.25"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }
  
  workers_group_defaults = {
    root_volume_type = "gp3"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group"

      instance_types = ["t3.micro"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

#     fargate_profiles = {

#     nginx = {
#       selectors = [{ namespace = "default" }]
#       subnets = module.vpc.private_subnets
#     }
    
#     coredns = {
#       selectors = [
#         { 
#           namespace = "kube-system"
#           labels    = { "k8s-app" = "kube-dns" }
#         },        
#       ]
#       subnets = module.vpc.private_subnets
#     }
# }
 }
