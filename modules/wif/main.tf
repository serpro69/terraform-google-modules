resource "google_iam_workload_identity_pool" "main" {
  project                   = var.project_id
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name
  description               = var.pool_description
  disabled                  = var.pool_disabled
}

resource "google_iam_workload_identity_pool_provider" "main" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.main.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = var.provider_display_name
  description                        = var.provider_description
  disabled                           = var.provider_disabled

  attribute_condition = var.attribute_condition
  attribute_mapping   = var.attribute_mapping

  oidc {
    allowed_audiences = var.allowed_audiences
    issuer_uri        = var.issuer_uri
  }
}

resource "google_service_account_iam_member" "main" {
  for_each = { for index, account in var.service_accounts : index => account }

  service_account_id = each.value.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "${each.value.all_identities == false ? "principal" : "principalSet"}://iam.googleapis.com/${google_iam_workload_identity_pool.main.name}/${each.value.attribute}"
}
