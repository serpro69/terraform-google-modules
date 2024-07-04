resource "google_project" "main" {
  # project details
  billing_account = var.billing_account
  org_id          = var.org_id
  folder_id       = var.folder_id
  project_id      = var.project_id
  name            = var.project_name
  deletion_policy = var.deletion_policy

  # Disable default network creation
  # See https://avd.aquasec.com/misconfig/avd-gcp-0010
  auto_create_network = var.auto_create_network

  labels = var.labels
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/google_project_service#mitigation---adding-sleeps
resource "time_sleep" "wait_for_project" {
  create_duration = var.time_wait_for_project
  depends_on      = [google_project.main]
}

## this will fail for external users, who need to be manually added so they
## can accept the email invitation to join the project
resource "google_project_iam_member" "owners" {
  for_each = toset(var.owners)
  project  = google_project.main.project_id
  role     = "roles/owner"
  member   = each.value
}

resource "google_project_iam_member" "editors" {
  for_each = toset(var.editors)
  project  = google_project.main.project_id
  role     = "roles/editor"
  member   = each.value
}

resource "google_project_iam_member" "viewers" {
  for_each = toset(var.viewers)
  project  = google_project.main.project_id
  role     = "roles/viewer"
  member   = each.value
}
