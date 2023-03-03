resource "tls_private_key" "certificate_authority" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "certificate_authority" {
  private_key_pem       = tls_private_key.certificate_authority.private_key_pem
  is_ca_certificate     = true
  validity_period_hours = 999999

  subject {
    common_name = "${terraform.workspace}.vpn.authority"
  }

  allowed_uses = ["cert_signing", "crl_signing"]
}

resource "aws_acm_certificate" "certificate_authority" {
  private_key      = tls_private_key.certificate_authority.private_key_pem
  certificate_body = tls_self_signed_cert.certificate_authority.cert_pem
}

resource "tls_private_key" "server" {
  algorithm = "RSA"
}

resource "tls_cert_request" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name = "${terraform.workspace}.vpn.server"
  }
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem      = tls_cert_request.server.cert_request_pem
  ca_private_key_pem    = tls_private_key.certificate_authority.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.certificate_authority.cert_pem
  validity_period_hours = 9999

  allowed_uses = ["digital_signature", "key_encipherment", "server_auth"]
}

resource "aws_acm_certificate" "server" {
  private_key       = tls_private_key.server.private_key_pem
  certificate_body  = tls_locally_signed_cert.server.cert_pem
  certificate_chain = tls_self_signed_cert.certificate_authority.cert_pem
}

resource "tls_private_key" "client" {
  algorithm = "RSA"
}

resource "tls_cert_request" "client" {
  private_key_pem = tls_private_key.client.private_key_pem

  subject {
    common_name = "${terraform.workspace}.vpn.client"
  }
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem      = tls_cert_request.client.cert_request_pem
  ca_private_key_pem    = tls_private_key.certificate_authority.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.certificate_authority.cert_pem
  validity_period_hours = 9999

  allowed_uses = ["client_auth", "digital_signature", "key_encipherment"]
}

resource "aws_acm_certificate" "client" {
  private_key       = tls_private_key.client.private_key_pem
  certificate_body  = tls_locally_signed_cert.client.cert_pem
  certificate_chain = tls_self_signed_cert.certificate_authority.cert_pem
}