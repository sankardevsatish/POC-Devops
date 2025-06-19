variable "cloudflare_api_token" {
  description = "token"
  type        = string
  sensitive   = true
}

variable "ip_address" {
  description = "IP address for the A record"
  type        = string
}
