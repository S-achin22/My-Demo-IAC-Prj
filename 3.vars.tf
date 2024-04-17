variable "region" {
  description = "The name of the AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "cluster-version" {
  description = "The Version for the EKS Cluster"
  type        = string
  default     = "1.28"
}

variable "cluster-name" {
  description = "The name of the EKS Cluster"
  type        = string
  default     = "EKS"
}

variable "access_key" {
  type        = string
  description = "Access Key ID For AWS"
}

variable "secret_key" {
  type        = string
  description = "Secret Key For AWS"
}
