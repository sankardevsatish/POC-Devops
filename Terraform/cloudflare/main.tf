terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "cloudflare_zones" "my_zone" {
  filter {
    name = "gocrazywithdev.com"
  }
}

resource "cloudflare_record" "a_record" {
  zone_id = data.cloudflare_zones.my_zone.zones[0].id
  name    = "gocrazywithdev.com"
  type    = "A"
  value   = var.ip_address
  ttl     = 1
  proxied = true
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "example" {

  private_key_pem = tls_private_key.example.private_key_pem

  subject {
    common_name  = "gocrazywithdev.com"
  }
}

resource "cloudflare_origin_ca_certificate" "origin_cert" {
  csr                = tls_cert_request.example.cert_request_pem
  hostnames          = ["gocrazywithdev.com", "*.gocrazywithdev.com"]
  requested_validity = 5475
  request_type       = "origin-rsa"
}

