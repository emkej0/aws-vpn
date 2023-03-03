terraform {
  backend "s3" {
    bucket  = "vpn-tfstate"
    key     = "vpn.tfstate"
    region  = "eu-central-1"
    profile = "vpn"
  }
}