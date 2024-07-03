# Terraform GCP Modules

This repository contains a collection of [terraform module](https://developer.hashicorp.com/terraform/language/modules) abstractions for various use-cases when working with Google Cloud Platform.

> [!WARNING]
> This repository is a work in progress. Expect breaking changes until the first stable release is published.

## General Dependencies

Presently, all modules try to stay up-to-date with the latest Terraform and Google Provider versions, however, versioning compatibility might be adjusted in the future to ensure backwards-compatible updates of modules.

### Current Dependencies

- [terraform](https://developer.hashicorp.com/terraform/install) ~> 1.9
- [google provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs) ~> 6.0

## Installation / Usage

Installation and usage instructions are provided in each component's README.

### Code Examples

Examples for each module are provided in the respective module's README, and can also be found in the [examples](examples) directory.

## Development / Contributing

> [!NOTE]
> A few words on code quality.
>
> - First ensure you have the necessary [requirements](#requirements) installed, particularly code-quality tools like `tflint` and `trivy`.
> - Then execute `tflint --init` to install tflint plugins from the [tflint config file](.tflint.hcl).
>   Refer to [tflint documentation](https://github.com/terraform-linters/tflint) for more usage details.
>
> Tflint supports disabling rules on specific lines via [annotation](https://github.com/terraform-linters/tflint/blob/v0.52.0/docs/user-guide/annotations.md) comments. We try avoid using these as much as possible.
>
> Trivy has support for suppressing rules via [inline comments](https://aquasecurity.github.io/trivy/v0.46/docs/configuration/filtering/#by-inline-comments) as well, which we also try to avoid, unless there are good reasons not to.
