locals {
  kms_keyring_name = "terraform-state"
  kms_key_name     = local.state_prefix
}

# ref: https://cloud.google.com/docs/terraform/resource-management/store-state
resource "google_kms_key_ring" "terraform_state" {
  project  = var.project_id
  name     = local.kms_keyring_name
  location = var.kms_location

  depends_on = [
    module.project
  ]
}

resource "google_kms_crypto_key" "terraform_state" {
  name                       = local.kms_key_name
  key_ring                   = google_kms_key_ring.terraform_state.id
  rotation_period            = var.kms_key_rotation_period
  destroy_scheduled_duration = var.kms_key_destroy_scheduled_duration
  purpose                    = "ENCRYPT_DECRYPT" # default
}

data "google_kms_key_ring" "terraform_state" {
  project  = var.project_id
  name     = google_kms_key_ring.terraform_state.name
  location = google_kms_key_ring.terraform_state.location
}

data "google_kms_crypto_key" "terraform_state" {
  name     = google_kms_crypto_key.terraform_state.name
  key_ring = data.google_kms_key_ring.terraform_state.id
}
