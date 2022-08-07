# Reading the data from a remote statefile "terraform-vpc" repository
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.BUCKET
    key    = "student/vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}
