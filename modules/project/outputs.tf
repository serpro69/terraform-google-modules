output "main" {
  value      = google_project.main
  depends_on = [time_sleep.wait_for_services]
}

output "services" {
  value = data.google_project_service.main
}

