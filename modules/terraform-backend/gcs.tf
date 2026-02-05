resource "google_storage_bucket" "tfstate" {
  project       = var.project_id
  name          = local.state_prefix
  force_destroy = var.gcs_force_destroy
  location      = var.gcs_location
  storage_class = var.gcs_storage_class
  # https://cloud.google.com/storage/docs/uniform-bucket-level-access#should-you-use
  # https://cloud.google.com/storage/docs/using-uniform-bucket-level-access#command-line_1
  uniform_bucket_level_access = true

  # Prevent public access irrespective of org policy
  public_access_prevention = "enforced"

  versioning {
    enabled = true
  }

  soft_delete_policy {
    retention_duration_seconds = var.gcs_retention_duration
  }

  encryption {
    default_kms_key_name = data.google_kms_crypto_key.terraform_state.id
  }

  # Keep current + last 30 versions of the .tfstate object, delete the rest.
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      matches_suffix        = [".tfstate"]
      with_state            = "ARCHIVED" # noncurrent
      matches_storage_class = ["STANDARD"]
      num_newer_versions    = 31
    }
  }

  # Keep current + last 3 versions in prod of the .tflock object, delete the rest.
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      matches_suffix        = [".tflock"]
      with_state            = "ARCHIVED" # noncurrent
      matches_storage_class = ["STANDARD"]
      num_newer_versions    = 4
    }
  }

  depends_on = [
    google_project_iam_member.storage_admin,
    google_project_iam_member.sa_kms_encrypter_decrypter,
  ]
}

# Bucket permissions

# IAM roles for cloud storage: https://cloud.google.com/storage/docs/access-control/iam-roles
data "google_iam_policy" "storage" {
  binding {
    role    = "roles/storage.admin"
    members = var.iam_gcs_admins
  }
  binding {
    role    = "roles/storage.objectViewer"
    members = var.iam_gcs_object_viewers
  }
}

resource "google_storage_bucket_iam_policy" "policy" {
  bucket      = google_storage_bucket.tfstate.name
  policy_data = data.google_iam_policy.storage.policy_data
}

# Managed folders and their permissions

moved {
  from = google_storage_managed_folder.terraform_state_prod
  to   = google_storage_managed_folder.state["prod"]
}

moved {
  from = google_storage_managed_folder.terraform_state_test
  to   = google_storage_managed_folder.state["test"]
}

resource "google_storage_managed_folder" "state" {
  for_each = var.gcs_state_folders
  bucket   = google_storage_bucket.tfstate.name
  name     = "${var.gcs_state_base}/${each.key}/"
}

# IAM roles for cloud storage: https://cloud.google.com/storage/docs/access-control/iam-roles

moved {
  from = data.google_iam_policy.storage_folder_tfstate_prod
  to   = data.google_iam_policy.storage_folder_tfstate["prod"]
}

moved {
  from = data.google_iam_policy.storage_folder_tfstate_test
  to   = data.google_iam_policy.storage_folder_tfstate["test"]
}

data "google_iam_policy" "storage_folder_tfstate" {
  for_each = var.gcs_state_folders
  binding {
    role    = "roles/storage.admin"
    members = each.value.admins
  }
  binding {
    role    = "roles/storage.objectUser"
    members = each.value.users
  }
}

moved {
  from = google_storage_managed_folder_iam_policy.terraform_state_prod
  to   = google_storage_managed_folder_iam_policy.terraform_state["prod"]
}

moved {
  from = google_storage_managed_folder_iam_policy.terraform_state_test
  to   = google_storage_managed_folder_iam_policy.terraform_state["test"]
}

resource "google_storage_managed_folder_iam_policy" "terraform_state" {
  for_each       = var.gcs_state_folders
  bucket         = google_storage_managed_folder.state[each.key].bucket
  managed_folder = google_storage_managed_folder.state[each.key].name
  policy_data    = data.google_iam_policy.storage_folder_tfstate[each.key].policy_data
}
