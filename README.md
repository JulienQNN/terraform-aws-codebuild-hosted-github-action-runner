# Github Runner on AWS Codebuild

This sample demonstrates how to deploy and run Github runners with AWS Codebuild. More informations  [here](https://aws.amazon.com/fr/blogs/devops/aws-codebuild-managed-self-hosted-github-action-runners/). A workflow trigger is visible in the `Actions` of this repository.

## Prerequisites

1. Create a connexion between AWS and your github account/organization, to do this you need to go in the console `Developer Tools > Connections > Create connection`
2. Set the connexion as [the default connexion](https://eu-west-1.console.aws.amazon.com/codesuite/codebuild/sourceCredentials/default?provider=github&region=eu-west-1) `https://**your-region**.console.aws.amazon.com/codesuite/codebuild/sourceCredentials/default?provider=github&region=eu-west-1`
## Architecture diagram

![infra-diagrams](./docs/architecture/terraform-aws-codebuild-hosted-github-action-runner.png)

Choosing a VPC is *optional*.
<!-- BEGIN_TF_DOCS -->

### Requirements

| Name                                                                      | Version  |
| ------------------------------------------------------------------------- | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >=5.59.0 |

### Inputs

| Name                                                                  | Description                            | Type          | Default                                                           | Required |
| --------------------------------------------------------------------- | -------------------------------------- | ------------- | ----------------------------------------------------------------- | :------: |
| <a name="input_app_env"></a> [app\_env](#input\_app\_env)             | Environment name of the application.   | `string`      | `"test"`                                                          |    no    |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name)          | Name of the application.               | `string`      | `"terraform-aws-codebuild-hosted-github-action-runner"`           |    no    |
| <a name="input_app_owner"></a> [app\_owner](#input\_app\_owner)       | Owner of the application.              | `string`      | `"me"`                                                            |    no    |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | A map of tags to add to all resources. | `map(string)` | `{}`                                                              |    no    |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name)       | Name of the repository.                | `string`      | `"JulienQNN/terraform-aws-codebuild-hosted-github-action-runner"` |    no    |

<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
README.md updated successfully
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
