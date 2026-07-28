variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes Version"
  type        = string
}

variable "node_instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "desired_nodes" {
  description = "Desired worker nodes"
  type        = number
}

variable "environment" {
  description = "Environment name"
  type        = string
}