# TODO: create an "admin" group in the organization to avoid giving permissions to individual users
# trivy:ignore:avd-gcp-0003
resource "google_project_iam_member" "storage_admin" {
  for_each = toset(var.iam_gcs_admins)

  project = data.google_project.main.project_id
  role    = "roles/storage.admin"
  member  = each.value

  depends_on = [data.google_storage_project_service_account.main]
}

resource "google_project_iam_member" "sa_kms_encrypter_decrypter" {
  # Make sure we only use required roles
  # ref: https://cloud.google.com/kms/docs/iam
  # ref: https://cloud.google.com/kms/docs/reference/permissions-and-roles
  # ref: https://cloud.google.com/kms/docs/create-key#required-roles
  # Also go to bucket details in GCP console -> Configuration -> Ecnryption Type -> Edit
  # The warning there hints that the cloudkms.cryptoKeyEncrypterDecrypter role should be enough for the storage service account
  project = data.google_project.main.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:${data.google_storage_project_service_account.main.email_address}"

  depends_on = [data.google_storage_project_service_account.main]
}

