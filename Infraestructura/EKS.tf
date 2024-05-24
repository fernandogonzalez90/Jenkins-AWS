module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">=20.11"

  cluster_name = "Pruebas_EKS"
  vpc_id      = module.vpc_id
  subnet_ids   = module.vpc.private_subnets
  #   Nunca en produccion !
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conlfict = "OVERWRITE"
    }
    vpc_cni = {
      resolve_conlfict = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conlfict = "OVERWRITE"
    }
    csi = {
      resolve_conlfict = "OVERWRITE"
    }
  }

  eks_managed_node_groups = {
    node-group = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1
      instance_type    = ["t2.micro"]

      tags = {
        environment = "Pruebas"
      }
    }
  }
}
