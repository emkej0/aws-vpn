resource "aws_instance" "test" {
  count = var.enable_test_ec2 ? 1 : 0

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.intra_subnets[0]
  vpc_security_group_ids = [aws_security_group.test_instance[0].id]

  tags = { Name = "vpn-connection-test-instance" }
}

resource "aws_security_group" "test_instance" {
  count = var.enable_test_ec2 ? 1 : 0

  name        = "test-ec2-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow traffic from VPN"

  ingress {
    security_groups = [aws_security_group.vpn.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  egress {
    security_groups = [aws_security_group.vpn.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  tags = { Name = "test-ec2-sg" }
}