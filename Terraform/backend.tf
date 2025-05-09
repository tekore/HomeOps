terraform {
  backend "s3" {
    bucket = "terraform-state"
    key = ""
    endpoint = var.r2_endpoint
    region = "auto"  # Required for Cloudflare R2 Storage
    skip_credentials_validation = true
    skip_region_validation = true
    skip_metadata_api_check = true
    skip_requesting_account_id = true
    skip_s3_checksum = true
    use_path_style = true
  }
}
