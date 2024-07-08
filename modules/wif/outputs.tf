data "google_iam_workload_identity_pool" "github" {
  provider                  = google-beta
  project                   = var.project_id
  workload_identity_pool_id = google_iam_workload_identity_pool.main.workload_identity_pool_id
}

data "google_iam_workload_identity_pool_provider" "github" {
  provider = google-beta
  project  = var.project_id

  workload_identity_pool_id          = google_iam_workload_identity_pool.main.workload_identity_pool_id
  workload_identity_pool_provider_id = google_iam_workload_identity_pool_provider.main.workload_identity_pool_provider_id
}

output "github_pool" {
  value = data.google_iam_workload_identity_pool.github
}

output "github_provider" {
  value = data.google_iam_workload_identity_pool_provider.github
}

