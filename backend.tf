terraform {
  backend "s3" {
    bucket = "prj-8273"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
