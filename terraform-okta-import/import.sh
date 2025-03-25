#!/bin/bash
# Enhanced Okta Terraform import script with better error handling and configurable commands

set -eo pipefail
shopt -s inherit_errexit

# Configuration
CONFIG_FILE="${CONFIG_FILE:-.env}"
TERRAFORM_CMD=""

# Load configuration with validation
load_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "Error: Config file $CONFIG_FILE not found" >&2
        exit 1
    fi
    # Load .env file
    set -o allexport
    source "$CONFIG_FILE" || {
        echo "Error: Failed to load config file $CONFIG_FILE" >&2
        exit 1
    }
    set +o allexport
    
    # Set default TERRAFORM_CMD if not specified
    TERRAFORM_CMD="${TERRAFORM_CMD:-terraform}"

    # Validate required variables
    local required_vars=("OKTA_ORG_NAME" "OKTA_API_TOKEN" "OKTA_BASE_URL")
    for var in "${required_vars[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            echo "Error: Required variable $var is not set in config" >&2
            exit 1
        fi
    done
}

# Initialize Terraform
init_terraform() {
    echo "Initializing Terraform..."
    if ! "$TERRAFORM_CMD" init; then
        echo "Error: Terraform initialization failed" >&2
        exit 1
    fi
}

# Import single resource with retries
import_resource() {
    local resource_type="$1"
    local okta_id="$2"
    local tf_address="$3"
    local max_retries=3
    local retry_delay=5
    local attempt=0

    echo "Importing $resource_type with ID $okta_id to $tf_address"
    
    while (( attempt < max_retries )); do
        if "$TERRAFORM_CMD" import "$tf_address" "$okta_id"; then
            return 0
        fi
        
        (( attempt++ )) || true
        if (( attempt < max_retries )); then
            echo "Attempt $attempt failed, retrying in $retry_delay seconds..."
            sleep "$retry_delay"
        fi
    done

    echo "Error: Failed to import $resource_type $okta_id after $max_retries attempts" >&2
    exit 1
}

# Main execution
main() {
    load_config
    init_terraform

    # Import resources (modify with your actual resources)
    import_resource "okta_app_oauth" "$OKTA_APP_ID" "okta_app_oauth.example_app"
    import_resource "okta_group" "$OKTA_GROUP_ID" "okta_group.example_group"
    import_resource "okta_user" "$OKTA_USER_ID" "okta_user.example_user"

    echo "Import completed successfully"
}

# Run main function
main "$@"
