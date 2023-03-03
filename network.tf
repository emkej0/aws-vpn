module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpn-vpc"
  cidr = "10.10.0.0/16"

  azs             = ["eu-central-1a"]
  public_subnets  = ["10.10.1.0/24"]
  private_subnets = ["10.10.2.0/24"]
  intra_subnets   = ["10.10.3.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = { source = "vpc-module" }
}

resource "aws_nat_gateway" "private" {
  connectivity_type = "private"
  subnet_id         = module.vpc.private_subnets[0]

  tags = { Name = "private-nat-gw" }
}

resource "aws_route" "intra_to_vpn" {
  route_table_id         = module.vpc.intra_route_table_ids[0]
  nat_gateway_id         = aws_nat_gateway.private.id
  destination_cidr_block = aws_ec2_client_vpn_endpoint.this.client_cidr_block
}