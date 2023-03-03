resource "aws_security_group" "vpn" {
  name        = "vpn-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow all traffic"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = { Name = "client-vpn-endpoint-sg" }
}