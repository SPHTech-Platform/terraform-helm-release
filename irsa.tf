locals {
  create_namespace = var.irsa_config.create_kubernetes_namespace && var.irsa_config.kubernetes_namespace != "kube-system"
}

module "irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = ">= 5.5.0"

  create_role = var.irsa_config.role_policy_arns != null
  role_name   = var.irsa_config.role_name

  oidc_providers = var.irsa_config.oidc_providers

  role_policy_arns = var.irsa_config.role_policy_arns
  tags             = var.tags
}


resource "kubernetes_namespace" "irsa" {
  count = local.create_namespace ? 1 : 0
  metadata {
    name = var.irsa_config.kubernetes_namespace
  }

  timeouts {
    delete = "15m"
  }
}

resource "kubernetes_service_account" "this" {
  count = var.irsa_config.create_kubernetes_service_account ? 1 : 0

  metadata {
    name        = var.irsa_config.kubernetes_service_account
    namespace   = try(kubernetes_namespace.irsa[0].metadata[0].name, var.irsa_config.kubernetes_namespace)
    annotations = var.irsa_config.role_policy_arns != null ? { "eks.amazonaws.com/role-arn" : module.irsa_role.iam_role_arn } : null
  }

  automount_service_account_token = true
}
