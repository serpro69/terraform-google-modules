variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

# identity pool vars

variable "pool_id" {
  description = "Id of the identity pool"
  type        = string
}

variable "pool_display_name" {
  description = "Display name of the identity pool\n(default: 'Terraform-managed pool')"
  type        = string
  default     = "Terraform-managed pool"
}

variable "pool_description" {
  description = "Description of the identity pool\n(default: '')"
  type        = string
  default     = ""
}

variable "pool_disabled" {
  description = "Whether the identity pool is disabled\n(default: false)"
  type        = bool
  default     = false
}

# identity pool provider vars

variable "provider_id" {
  description = "Id of the identity pool provider"
  type        = string
}

variable "provider_display_name" {
  description = "Display name of the identity pool provider\n(default: 'Terraform-managed provider')"
  type        = string
  default     = "Terraform-managed provider"
}

variable "provider_description" {
  description = "Description of the identity pool provider\n(default: '')"
  type        = string
  default     = ""
}

variable "provider_disabled" {
  description = "Whether the identity pool provider is disabled\n(default: false)"
  type        = bool
  default     = false
}

variable "attribute_mapping" {
  description = "Workload identity pool provider attribute mapping"
  type        = map(any)
}

variable "attribute_condition" {
  description = "Workload identity pool provider attribute condition expression\n(default: null)"
  type        = string
  default     = null
}

variable "allowed_audiences" {
  type        = list(string)
  description = "Allowed audiences for the workload identity pool provider"
  default     = []
}

variable "issuer_uri" {
  description = "Issuer URL for the workload identity pool provider"
  type        = string
}

# service account impersonation

variable "service_accounts" {
  type = list(object({
    name           = string
    attribute      = string
    all_identities = bool
  }))
  description = "Service Account resource names and corresponding provider attributes"
}
