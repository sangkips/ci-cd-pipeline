terraform {
  backend "s3" {
    bucket         = "kips-bucket"
    key            = "State-Files/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_lock"
    encrypt        = true
  }
}
