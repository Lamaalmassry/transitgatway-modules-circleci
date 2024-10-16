terraform {
  backend "s3" {
    bucket         = "jdp-example"
    key            = "terraform.tfstate"

  }
}