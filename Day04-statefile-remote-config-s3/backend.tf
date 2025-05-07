terraform {
  backend "s3" {
    bucket = "backendstatefilee"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}