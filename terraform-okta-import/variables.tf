variable "okta_org_name" {
  description = "The Okta organization name"
  type        = string
  sensitive   = true
}

variable "okta_api_token" {
  description = "The Okta API token"
  type        = string
  sensitive   = true
}

variable "okta_base_url" {
  description = "The Okta base URL"
  type        = string
  default     = "okta.com"
}
