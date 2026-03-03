variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "eks_cluster_role" {
  type = string
}

variable "eks_node_group_role" {
  type = string
}
