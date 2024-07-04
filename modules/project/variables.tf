variable "billing_account" {
  description = <<-EOT
  The alphanumeric ID of the billing account this project belongs to. 
  The user or service account performing this operation with Terraform must have Billing Account Administrator privileges (roles/billing.admin) in the organization.
  See Google Cloud Billing API Access Control for more details.
  EOT
  type        = string
  default     = ""
  sensitive   = true
}

variable "org_id" {
  description = <<-EOT
  The numeric ID of the organization this project belongs to.
  Changing this forces a new project to be created.
  Only one of org_id or folder_id may be specified.
  If the org_id is specified then the project is created at the top level.
  Changing this forces the project to be migrated to the newly specified organization.
  EOT
  default     = ""
  type        = string
}

variable "folder_id" {
  description = <<-EOT
  The numeric ID of the folder this project should be created under. 
  Only one of org_id or folder_id may be specified. 
  If the folder_id is specified, then the project is created under the specified folder. 
  Changing this forces the project to be migrated to the newly specified folder.
  EOT
  default     = ""
  type        = string
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "project_name" {
  description = "GCP Project name"
  type        = string
}

variable "deletion_policy" {
  description = <<EOL
    The deletion policy for the Project. 
    Setting PREVENT will protect the project against any destroy actions caused by a terraform apply or terraform destroy. 
    Setting ABANDON allows the resource to be abandoned rather than deleted. 
    Possible values are: "PREVENT", "ABANDON", "DELETE"
  EOL
  type        = string
}

variable "auto_create_network" {
  description = "Create the 'default' network automatically"
  type        = bool
  default     = false
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the project"
  type        = map(string)
  default     = {}
}

variable "services" {
  description = "A list of services to enable for the project"
  type        = list(string)
  default     = []
}

# IAM
variable "owners" {
  description = "Optional list of IAM-format members to set as project owners"
  type        = list(string)
  default     = []
}

variable "editors" {
  description = "Optional list of IAM-format members to set as project editor"
  type        = list(string)
  default     = []
}

variable "viewers" {
  description = "Optional list of IAM-format members to set as project viewers"
  type        = list(string)
  default     = []
}

# Misc

variable "time_wait_for_project" {
  description = <<-EOT
  [Time duration](https://golang.org/pkg/time/#ParseDuration)
  to wait after project creation before provisioning dependent resources.
  For example, `30s` for 30 seconds or `5m` for 5 minutes.
  EOT
  type        = string
  default     = "30s"
}

variable "time_wait_for_services" {
  description = <<-EOT
  Activating a service is _eventually_ consistent in GCP. 
  There are no good workarounds for this behavior at present, 
  and [google recommends adding sleeps](# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/google_project_service#mitigation---adding-sleeps).
  [Time duration](https://golang.org/pkg/time/#ParseDuration) 
  to wait after enabling services before provisioning dependent resources.
  For example, `30s` for 30 seconds or `5m` for 5 minutes.
  EOT
  type        = string
  default     = "30s"
}
