`wif` (aka workload identity federation)

This module provides capabilities to manage [Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation) for OIDC in a given GCP project.

## ToC

<!--toc:start-->
- [ToC](#toc)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Code Example](#code-example)
- [Features](#features)
- [Inputs](#inputs)
- [Outputs](#outputs)
<!--toc:end-->

## Prerequisites

Refer to [versions.tf](versions.tf) for details on terraform provider requirements and their configurations.

[Required GCP APIs/services](https://cloud.google.com/iam/docs/workload-identity-federation-with-other-providers#configure):

- `cloudresourcemanager.googleapis.com`
- `iam.googleapis.com`
- `iamcredentials.googleapis.com`
- `sts.googleapis.com`

## Usage

### Code Example

Let's assume we want to create an identity pool for authenticating in GitHub Actions.
This could be done in the following way:

```hcl
data "google_service_account" "gh_actions" {
  account_id = "github-actions"
}

module "github-wif" {
  source      = "github.com:serpro69/terraform-google-modules//modules/wif"

  project_id = var.project_id

  pool_id     = "github-pool"
  provider_id = "github-provider"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
  }
  issuer_uri = "https://token.actions.githubusercontent.com"

  service_accounts = [
    {
      name           = data.google_service_account.gh_actions.name
      attribute      = "attribute.repository/repo-owner/repo-name"
      all_identities = true
    }
  ]

  providers = {
    # refer to versions.tf file for pvovider configuration requirements
  }
}
```

## Features

- Creates a new identity pool.
- Adds an OIDC provider to the pool.
- (Optionally) Grants the `roles/iam.workloadIdentityUser` role (via [service account memebership](https://cloud.google.com/iam/docs/manage-access-service-accounts)) to a list of service accounts.

## Inputs

Refer to [variables.tf](./variables.tf) for more details on input variables for this module.

## Outputs

Refer to [outputs.tf](./outputs.tf) for more details on output variables that this module produces.
