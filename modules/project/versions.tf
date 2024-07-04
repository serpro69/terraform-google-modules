terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6, < 7"
      configuration_aliases = [
        # user_project_override = false
        google,
      ]
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12"
    }
  }

  required_version = "~> 1.9"
}
