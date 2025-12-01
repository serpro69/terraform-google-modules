# module provides out-of-the box handling for google services
# https://github.com/terraform-google-modules/terraform-google-project-factory/tree/master/modules/project_services
module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 18.1"

  project_id                  = var.project_id
  activate_apis               = var.services
  disable_services_on_destroy = var.disable_services_on_destroy

  depends_on = [
    google_project.main,
    time_sleep.wait_for_project,
  ]

  providers = {
    google = google
  }
}

# Activating a service is _eventually_ consistent in GCP. 
# There are no good workarounds for this behavior at present, and google recommends adding sleeps:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/google_project_service#mitigation---adding-sleeps
resource "time_sleep" "wait_for_services" {
  create_duration = var.time_wait_for_services
  depends_on      = [module.project_services]
}

# this will query services and make sure they're enabled before proceeding
data "google_project_service" "main" {
  for_each = toset(var.services)
  project  = var.project_id
  service  = each.value
  depends_on = [
    time_sleep.wait_for_services
  ]
}
