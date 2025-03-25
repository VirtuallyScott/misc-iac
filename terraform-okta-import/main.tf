terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
  }
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

# Example resources - these should match what you're importing
resource "okta_app_oauth" "example_app" {
  # Configuration will be imported from existing Okta resources
}

resource "okta_group" "example_group" {
  # Configuration will be imported from existing Okta resources
}

resource "okta_user" "example_user" {
  # Configuration will be imported from existing Okta resources
}
