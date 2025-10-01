terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7, < 8"
      configuration_aliases = [
        # user_project_override = false
        google,
      ]
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.13"
    }
  }

  required_version = "~> 1.10"
}
