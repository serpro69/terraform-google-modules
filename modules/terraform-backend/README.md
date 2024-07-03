<!--toc:start-->
- [Requirements](#requirements)
- [Usage](#usage)
  - [Code Example](#code-example)
  - [First-time Setup](#first-time-setup)
    - [Create GCS Bucket](#create-gcs-bucket)
    - [Change the backend configuration](#change-the-backend-configuration)
  - [Using the backends](#using-the-backends)
  - [Migrating State](#migrating-state)
<!--toc:end-->

This module provisions resources for [gcs](https://developer.hashicorp.com/terraform/language/backend/gcs) [terraform backend](https://developer.hashicorp.com/terraform/language/backend).

Refer to <https://cloud.google.com/docs/terraform/resource-management/store-state> for more details.

## Requirements

- See the [versions.tf](versions.tf) file for details on terraform and providers requirements.

## Usage

### Code Example

```tf
module "tfstate" {
  source = "github.com/serpro69/terraform-google-modules//modules/terraform-backend"

  billing_account = var.billing_account

  # project details
  folder_id    = "my-folder"
  project_id   = "my-project-id"
  project_name = "my-project-name"

  # permissions for the bucket
  iam_gcs_admins                     = []
  iam_gcs_object_viewers             = []
  iam_gcs_tfstate_folder_prod_admins = []
  iam_gcs_tfstate_folder_prod_users  = []
  iam_gcs_tfstate_folder_test_admins = []
  iam_gcs_tfstate_folder_test_users  = []

  providers = {
    google = google,
  }
}

output "tfstate_url" {
  value = module.tfstate.bucket.url
}
```

### First-time Setup

#### Create GCS Bucket

> [!NOTE]
> You should authenticate with `gcloud` prior to running terraform: `gcloud auth login` and `gcloud auth application-default login`
>
> See [Terraform provider for Google Cloud](https://registry.terraform.io/providers/hashicorp/google/latest/docs) documentation for more details.

First we need to create the infrastructure to store terraform state files in Google Cloud Storage.

In the following steps, we will create a Cloud Storage bucket and a KMS key to encrypt the state file.

- `terraform init`
- let's assume that we're going to use a separate workspace, e.g. `state`, just for the backend-related resources, which in most cases makes most sence
  - `terraform workspace select state` (or `terraform workspace new state` when using for the first time)
- `terraform apply`

#### Change the backend configuration

Afterwards, we need to update the terraform backend configuration:

```hcl
terraform {
 backend "gcs" {
   bucket  = "<BUCKET_NAME>"
   prefix  = "terraform/state/<SUFFIX>"
 }
}
```

> [!NOTE]
> Make sure to update the `<BUCKET_NAME>` to match the name of your new Cloud Storage bucket.
>
> We also use `<SUFFIX>` subfolders to distinguish between state files for production and non-production workspaces (environments).

And then run `terraform init` to configure our Terraform backend.

Terraform detects that we already have a state file locally and prompts us to copy it to the new Cloud Storage bucket. Enter "yes", and Bob's your uncle, we have our Terraform state is stored in the Cloud Storage bucket. Terraform pulls the latest state from this bucket before running a command, and pushes the latest state to the bucket after running a command.

### Using the backends

When using different sub-folders in the same bucket for different environments, you will often find yourself switching between backends, and hence storing the backend configuration in the `terraform {}` block will be quite inconvenient.

Terraform supports [backend configuration files](https://developer.hashicorp.com/terraform/language/backend#file), as well as [command-line key=value pairs](https://developer.hashicorp.com/terraform/language/backend#command-line-key-value-pairs).

As an example, let's use the file-based backend configuration, which looks something like:

```
bucket = "1234567890-tfstate"
prefix = "terraform/state/test"
```

And for production state files:

```
bucket = "1234567890-tfstate"
prefix = "terraform/state/prod"
```

After the state file is has been pushed to the bucket, we can initialize the desired backend and pull the state. Since the backend supports workspaces, we will automatically see all available workspaces after running `terraform init` command:

```bash
$ terraform init -backend-config=.test.gcs.tfbackend

Initializing the backend...

Successfully configured the backend "gcs"! Terraform will automatically
use this backend unless the backend configuration changes.
Initializing modules...

Initializing provider plugins...
- Reusing previous version of hashicorp/time from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Reusing previous version of hashicorp/google from the dependency lock file
- Reusing previous version of hashicorp/google-beta from the dependency lock file
- Using previously-installed hashicorp/google-beta v5.36.0
- Using previously-installed hashicorp/time v0.11.2
- Using previously-installed hashicorp/random v3.6.2
- Using previously-installed hashicorp/google v5.36.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

➜ tf workspace list
* default
  test
```

When we re-initialize with `prod` backend, the existing workspaces are automatically updated:

```bash
$ terraform init -reconfigure -backend-config=.prod.gcs.tfbackend

Initializing the backend...

Successfully configured the backend "gcs"! Terraform will automatically
use this backend unless the backend configuration changes.
Initializing modules...

Initializing provider plugins...
- Reusing previous version of hashicorp/time from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Reusing previous version of hashicorp/google from the dependency lock file
- Reusing previous version of hashicorp/google-beta from the dependency lock file
- Using previously-installed hashicorp/time v0.11.2
- Using previously-installed hashicorp/random v3.6.2
- Using previously-installed hashicorp/google v5.36.0
- Using previously-installed hashicorp/google-beta v5.36.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

$ terraform workspace list
* default
  state
```

### Migrating State

One can migrate state between backends, e.g. if for whateveer reasons we want to completely re-create the GCP project and move the state to a new bucket.

- `terraform workspace select --or-create new`
- `terraform apply`
- update the backend configuration files to use the new bucket (and possibly folder structure)

  ```bash
  cat > .test.gcs.tfbackend << EOF
  bucket = "$(tfo --json | jq '.tfstate_url.value' | tr -d '"' | sed 's/gs:\/\///')"
  prefix = "terraform/state/test"
  EOF

  cat > .prod.gcs.tfbackend << EOF
  bucket = "$(tfo --json | jq '.tfstate_url.value' | tr -d '"' | sed 's/gs:\/\///')"
  prefix = "terraform/state/prod"
  EOF
  ```

- init terraform with new state and migrate state files for each of the backend configs:

  ```bash
  terraform init -backend-config=.test.gcs.tfbackend -migrate-state
  terraform init -backend-config=.prod.gcs.tfbackend -migrate-state
  ```

- double-check state files in the new bucket
- select the previous workspace and `terraform destroy`
- profit
