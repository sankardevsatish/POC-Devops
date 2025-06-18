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
  ttl     = 3600
  proxied = true
}

resource "cloudflare_origin_ca_certificate" "origin_cert" {
  csr                = file("csr.pem") # or use `csr = <<EOT ... EOT` inline
  hostnames          = ["gocrazywithdev.com", "*.gocrazywithdev.com"]
  requested_validity = 5475
}
