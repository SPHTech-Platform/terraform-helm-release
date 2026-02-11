# Terraform Helm Release

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.38 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.38 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_irsa_role"></a> [irsa\_role](#module\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.4.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_service_account_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_helm_config"></a> [helm\_config](#input\_helm\_config) | Helm chart config. Repository and version required. See https://registry.terraform.io/providers/hashicorp/helm/latest/docs | `any` | n/a | yes |
| <a name="input_irsa_config"></a> [irsa\_config](#input\_irsa\_config) | Input configuration for IRSA module | <pre>object({<br/>    name                              = optional(string, "")<br/>    use_name_prefix                   = optional(bool, false)<br/>    policies                          = optional(map(string), {})<br/>    create_kubernetes_namespace       = optional(bool, false)<br/>    create_kubernetes_service_account = optional(bool, false)<br/>    kubernetes_namespace              = optional(string, "")<br/>    kubernetes_service_account        = optional(string, "")<br/>    oidc_providers                    = optional(any, null)<br/>  })</pre> | `{}` | no |
| <a name="input_set_list_values"></a> [set\_list\_values](#input\_set\_list\_values) | Forced set\_list values | `any` | `[]` | no |
| <a name="input_set_sensitive_values"></a> [set\_sensitive\_values](#input\_set\_sensitive\_values) | Forced set\_sensitive values | `any` | `[]` | no |
| <a name="input_set_values"></a> [set\_values](#input\_set\_values) | Forced set values | `any` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add the the IAM role | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_release"></a> [helm\_release](#output\_helm\_release) | Map of attributes of the Helm release created without sensitive outputs |
| <a name="output_release_metadata"></a> [release\_metadata](#output\_release\_metadata) | Map of attributes of the Helm release metadata |
