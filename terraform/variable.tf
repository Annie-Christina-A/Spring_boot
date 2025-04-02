variable "aws_region" {
  description = "AWS region"
  default     = "eu-north-1"
}

variable "s3_bucket_name" {
  description = "S3 bucket for storing CodePipeline artifacts"
  default     = "my-codepipeline-bucket-wsl"
}

variable "github_owner" {
  description = "GitHub repository owner"
}

variable "github_repo" {
  description = "GitHub repository name"
}

variable "github_token" {
  description = "GitHub personal access token"
  sensitive   = true
}

