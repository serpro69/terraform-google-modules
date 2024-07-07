`project`

This module creates a new GCP project.

<!--toc:start-->
- [Requirements](#requirements)
- [Usage](#usage)
  - [Code Example](#code-example)
  - [Features](#features)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
<!--toc:end-->

## Requirements

Refer to [versions.tf](versions.tf) for details on terraform and providers' requirements.

## Usage

### Code Example

```hcl
module "project" {
  source           = "github.com/serpro69/terraform-google-modules//modules/project"
  billing_account  = "0123567890"
  folder_id        = "my-folder"
  project_id       = "my-project-id"
  project_name     = "my-project-name"
}
```

### Features

- Creates a new GCP project with a given `project_id` and `project_name` (optionally, under a specified `folder_id`)
- Attaches the `billing_account` to the project
- Enables specified `services` for the project
- Adds an optional set of project `labels`
- Configures project IAM `owners`, `editors` and `viewers` roles

### Inputs

Refer to [variables.tf](./variables.tf) for more details on input variables for this module.

### Outputs

The module produces the following outputs:

- `main` - exported [`google_project` attributes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project#attributes-reference)

Also refer to [outputs.tf](./outputs.tf) for more details on outputs that this module produces.
