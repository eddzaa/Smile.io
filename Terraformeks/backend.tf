terraform {
  backend "s3" {
    bucket         = "smilebackend" # Replace with your actual S3 bucket name
    key            = "EKS/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-state-bucket"
    encrypt        = true
  }
}
