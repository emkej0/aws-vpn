provider "aws" {
  region  = "eu-central-1"
  profile = terraform.workspace
  default_tags {
    tags = local.default_tags
  }
}

provider "tls" {}