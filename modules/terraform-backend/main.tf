module "project" {
  source          = "../project"
  billing_account = var.billing_account
  folder_id       = var.folder_id
  project_id      = var.project_id
  project_name    = var.project_name
  deletion_policy = var.project_deletion_policy

  auto_create_network = false

  services = local.services

  # TODO: is this needed?
  owners  = []
  editors = []
  viewers = []

  providers = {
    google = google
  }
}

data "google_project" "main" {
  project_id = module.project.main.project_id
}

output "project" {
  value = data.google_project.main
}

