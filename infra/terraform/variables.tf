variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Name prefix for tagging"
  type        = string
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}
