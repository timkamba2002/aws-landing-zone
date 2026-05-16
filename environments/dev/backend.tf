terraform {
  backend "s3" {
    bucket         = "landing-zone-dev-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "landing-zone-dev-lock2"

    encrypt        = true
  }
}
