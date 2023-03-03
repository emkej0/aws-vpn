data "template_file" "client_vpn_config_file" {
  template = file("${path.module}/config_file.tpl")
  vars = {
    key             = tls_private_key.client.private_key_pem
    cert            = tls_locally_signed_cert.client.cert_pem
    path            = path.module
    profile         = terraform.workspace
    vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  }
}

resource "local_file" "name" {
  content = data.template_file.client_vpn_config_file.rendered
  filename = "${path.module}/client-vpn-content.txt"
}