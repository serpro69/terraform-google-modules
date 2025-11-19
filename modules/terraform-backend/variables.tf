variable "billing_account" {
  description = "GCP Billing Account ID"
  type        = string
}

variable "folder_id" {
  description = "GCP Folder ID"
  type        = string
}

variable "project_id" {
  description = "GCP Project ID for terraform state"
  type        = string
}

variable "project_name" {
  description = "GCP Project name for terraform state"
  type        = string
}

variable "project_deletion_policy" {
  description = <<-EOT
  The deletion policy for the Project. 
  Setting PREVENT will protect the project against any destroy actions caused by a terraform apply or terraform destroy. 
  Setting ABANDON allows the resource to be abandoned rather than deleted. 
  Possible values are: "PREVENT", "ABANDON", "DELETE"
  EOT
  type        = string
}

# IAM

variable "iam_gcs_admins" {
  description = "List of members to grant storage.admin role to on the project level"
  type        = list(string)
}

variable "iam_gcs_bucket_viewers" {
  description = "List of members to grant storage.bucketViewer role to on the project level"
  type        = list(string)
}

variable "iam_gcs_object_viewers" {
  description = "List of members to grant storage.objectViewer role to on the bucket level"
  type        = list(string)
}

variable "iam_gcs_tfstate_folder_prod_admins" {
  description = "List of members to grant storage.admin role to on the 'prod' folder level"
  type        = list(string)
}

variable "iam_gcs_tfstate_folder_prod_users" {
  description = "List of members to grant storage.admin role to on the 'prod' folder level"
  type        = list(string)
}

variable "iam_gcs_tfstate_folder_test_admins" {
  description = "List of members to grant storage.admin role to on the 'test' folder level"
  type        = list(string)
}

variable "iam_gcs_tfstate_folder_test_users" {
  description = "List of members to grant storage.admin role to on the 'test' folder level"
  type        = list(string)
}

# GCS

variable "gcs_force_destroy" {
  description = "Whether to force destroy the bucket and all objects stored in it"
  type        = bool
  default     = false
}

variable "gcs_location" {
  description = "The [location of the bucket](https://cloud.google.com/storage/docs/locations#predefined)"
  type        = string
  default     = "EUR4"
}

variable "gcs_storage_class" {
  description = "The storage class of the bucket"
  type        = string
  default     = "STANDARD"
}

variable "gcs_retention_duration" {
  description = <<-EOT
  The duration in seconds that soft-deleted objects in the bucket will be retained and cannot be permanently deleted.
  Default value is 604800.
  EOT
  type        = number
  default     = 604800
}

# KMS

variable "kms_location" {
  description = <<-EOT
  The location for the KeyRing.
  A full list of valid locations can be found by running 'gcloud kms locations list'.
  EOT
  type        = string
  default     = "eur4"
}

variable "kms_key_rotation_period" {
  description = <<-EOT
  Every time this period passes, generate a new CryptoKeyVersion and set it as the primary.
  The first rotation will take place after the specified period. 
  The rotation period has the format of a decimal number with up to 9 fractional digits, 
  followed by the letter 's' (seconds). 
  It must be greater than a day (ie, 86400).
  The default rotation perioud is 30 days.
  EOT
  type        = string
  default     = "2592000s"
}

variable "kms_key_destroy_scheduled_duration" {
  description = <<-EOT
  The period of time that versions of this key spend in the DESTROY_SCHEDULED state before transitioning to DESTROYED.
  If not specified at creation time, the default duration is 30 days.
  EOT
  type        = string
  default     = "2592000s"
}
