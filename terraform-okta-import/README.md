# Okta Terraform Import Tool

## Purpose
Import existing Okta configuration into Terraform state to transition from click-ops to infrastructure-as-code.

## Prerequisites
- Terraform installed
- Okta admin privileges
- Okta API token with appropriate permissions

## Setup
1. Install dependencies:
```bash
terraform init
```

2. Configure your environment:
```bash
chmod +x config.sh import.sh
source config.sh
```

## Usage
1. Edit config.sh with your Okta details and resource IDs
2. Run the import script:
```bash
./import.sh
```

## Customization
Add more resource types to import.sh following the pattern:
```bash
import_resource "okta_resource_type" "$OKTA_ID" "terraform_resource.address"
```

## Security Notes
- Never commit sensitive values to version control
- Use .gitignore to exclude config.sh and Terraform state files
- Rotate API tokens regularly

## Next Steps
After import:
1. Run `terraform plan` to verify
2. Add configuration to main.tf
3. Commit only the Terraform files (not state)
