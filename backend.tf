terraform {
  backend "s3" {
    bucket         = "backend-bucket-terraform"
    key            = "terraform.tfstate"

  }
}
