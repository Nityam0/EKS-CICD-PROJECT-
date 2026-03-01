######   vpc configuration  ######
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

#######  iam role for EKS cluster  ######

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

#######  attach policies to the role  ######
resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#######   ecr repository ######
resource "aws_ecr_repository" "app_repo" {
  name = "cicd-app-repo"
}

#######   eks cluster  ######
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.public.id]
  }
}


#######  node group for EKS cluster  ######
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "node-group"
  node_role_arn   = aws_iam_role.eks_cluster_role.arn
  subnet_ids      = [aws_subnet.public.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

######## jenkins ec2 instance  ######
resource "aws_instance" "jenkins" {
  ami           = "ami-xxxxxxxx"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  associate_public_ip_address = true

  tags = {
    Name = "Jenkins-Server"
  }
}

