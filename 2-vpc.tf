data "aws_availability_zones" "az" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  azs             = data.aws_availability_zones.az.names
  private_subnets = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  public_subnets  = ["10.0.96.0/20", "10.0.112.0/20", "10.0.128.0/20"]

  map_public_ip_on_launch = true
  enable_nat_gateway      = false

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }

  vpc_tags = {
    ProjectName = "EKS-VPC"
  }
}

output "eks-vpc_id" {
  value = module.vpc.vpc_id
}
output "subnet_id-priv" {
  value = module.vpc.private_subnets
}

output "subnet_id-pub" {
  value = module.vpc.public_subnets
}

locals {
  private_subnets = [
    for subnet in module.vpc.private_subnets : subnet
  ]
  public_subnets = [
    for subnet in module.vpc.public_subnets : subnet
  ]

  depends_on = [module.vpc.private_subnets, module.vpc.public_subnets]
}