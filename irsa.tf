locals {
  create_namespace = var.irsa_config.create_kubernetes_namespace && var.irsa_config.kubernetes_namespace != "kube-system"
}

module "irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 6.0"

  create = var.irsa_config.name != "" ? true : false
  name   = var.irsa_config.name

  oidc_providers = var.irsa_config.oidc_providers

  policies = var.irsa_config.policies
  tags     = var.tags
}


resource "kubernetes_namespace_v1" "irsa" {
  count = local.create_namespace ? 1 : 0

  metadata {
    name = var.irsa_config.kubernetes_namespace
  }

  timeouts {
    delete = "15m"
  }
}

resource "kubernetes_service_account_v1" "this" {
  count = var.irsa_config.create_kubernetes_service_account ? 1 : 0

  metadata {
    name        = var.irsa_config.kubernetes_service_account
    namespace   = try(kubernetes_namespace_v1.irsa[0].metadata[0].name, var.irsa_config.kubernetes_namespace)
    annotations = var.irsa_config.policies != null ? { "eks.amazonaws.com/role-arn" : module.irsa_role.arn } : null
  }

  automount_service_account_token = true
}
