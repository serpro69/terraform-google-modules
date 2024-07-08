terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6, < 7"
      configuration_aliases = [
        # user_project_override = true
        google,
      ]
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6, < 7"
      configuration_aliases = [
        # user_project_override = true
        google-beta,
      ]
    }
  }

  required_version = "~> 1.9"
}
