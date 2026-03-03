module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "eks" {
  source              = "./modules/eks"
  cluster_name        = var.cluster_name
  subnet_ids          = module.vpc.private_subnets
  vpc_id              = module.vpc.vpc_id
  eks_cluster_role    = module.iam.eks_cluster_role_arn
  eks_node_group_role = module.iam.eks_node_group_role_arn
}
