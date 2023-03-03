resource "aws_ec2_client_vpn_endpoint" "this" {
  description = "Allow access to cloud network"

  vpc_id                 = module.vpc.vpc_id
  split_tunnel           = true
  client_cidr_block      = "10.20.0.0/22"
  security_group_ids     = [aws_security_group.vpn.id]
  server_certificate_arn = aws_acm_certificate.server.arn

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.server.arn
  }

  connection_log_options {
    enabled = false
  }

  tags = { Name = "${terraform.workspace}-vpn-endpoint" }
}

resource "aws_ec2_client_vpn_network_association" "this" {
  subnet_id              = module.vpc.public_subnets[0]
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
}

resource "aws_ec2_client_vpn_authorization_rule" "this" {
  target_network_cidr    = module.vpc.vpc_cidr_block
  authorize_all_groups   = true
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
}