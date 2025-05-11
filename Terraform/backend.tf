terraform {
  backend "s3" {
    bucket = "secrets"
    key = "terraform/state/Axis/terraform.tfstate"
    endpoint = "https://20daad79d4c8c17a1500d2d1a90b1b03.r2.cloudflarestorage.com"
    region = "auto"  # Required for Cloudflare R2 Storage
    skip_credentials_validation = true
    skip_region_validation = true
    skip_metadata_api_check = true
    skip_requesting_account_id = true
    skip_s3_checksum = true
    use_path_style = true
  }
}
