
terraform {
  backend "s3" {
    bucket = "backendforstatee"
    key    = "day-1/terraform.tfstate"
    region = "us-east-1"
  }
}