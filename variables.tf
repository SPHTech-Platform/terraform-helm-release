#######
# Helm
#######
variable "helm_config" {
  description = "Helm chart config. Repository and version required. See https://registry.terraform.io/providers/hashicorp/helm/latest/docs"
  type        = any
}

variable "set_values" {
  description = "Forced set values"
  type        = any
  default     = []
}

variable "set_sensitive_values" {
  description = "Forced set_sensitive values"
  type        = any
  default     = []
}

#######
# IRSA
#######
variable "irsa_config" {
  description = "Input configuration for IRSA module"
  type = object({
    role_name                         = optional(string, "")
    role_policy_arns                  = optional(map(string), {})
    create_kubernetes_namespace       = optional(bool, false)
    create_kubernetes_service_account = optional(bool, false)
    kubernetes_namespace              = optional(string, "")
    kubernetes_service_account        = optional(string, "")
    oidc_providers                    = optional(any, null)
  })
  default = {}
}

variable "tags" {
  description = "A map of tags to add the the IAM role"
  type        = map(string)
  default     = {}
}
