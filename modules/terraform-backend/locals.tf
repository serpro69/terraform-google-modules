resource "random_id" "prefix" {
  byte_length = 8
}

locals {
  state_prefix = "${random_id.prefix.hex}-tfstate"

  services = [
    "cloudkms.googleapis.com",
    "storage.googleapis.com",
    # Allows setting this project as quota project
    "cloudresourcemanager.googleapis.com",
    # By enabling the Service Usage API, the project will be able to accept quota checks! 
    "serviceusage.googleapis.com"
  ]
}
