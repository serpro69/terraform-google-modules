# email returns null ( https://github.com/hashicorp/terraform-provider-google/issues/18649 )
#resource "google_project_service_identity" "storage" {
#  provider = google-beta
#
#  project = data.google_project.gcs.project_id
#  service = local.service.storage.name
#
#  depends_on = [
#    data.google_project_service.storage
#  ]
#}

# This data source can be used instead of google_project_service_identity resource
# since it creates a GCS service account on demand, if it doesn't exist.
# See the note in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket#default_kms_key_name
# And resource docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_project_service_account#example-usage-%E2%80%93-cloud-kms-keys
data "google_storage_project_service_account" "main" {
  project = module.project.main.project_id
}

