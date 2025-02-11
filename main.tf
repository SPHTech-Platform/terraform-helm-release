resource "helm_release" "this" {
  # When irsa config defined, service account needs to be created and passed via helm_config
  depends_on = [
    kubernetes_service_account.this
  ]

  name  = var.helm_config.name
  chart = var.helm_config.chart

  repository       = try(var.helm_config.repository, null)
  version          = try(var.helm_config.version, null)
  namespace        = var.irsa_config.kubernetes_namespace != "" ? var.irsa_config.kubernetes_namespace : try(var.helm_config.namespace, "default")
  create_namespace = var.irsa_config.create_kubernetes_namespace ? false : try(var.helm_config.create_namespace, false)

  description = try(var.helm_config.description, "")

  repository_key_file  = try(var.helm_config.repository_key_file, "")
  repository_cert_file = try(var.helm_config.repository_cert_file, "")
  repository_username  = try(var.helm_config.repository_username, "")
  repository_password  = try(var.helm_config.repository_password, "")

  verify                = try(var.helm_config.verify, false)
  keyring               = try(var.helm_config.keyring, "")
  timeout               = try(var.helm_config.timeout, 1200)
  disable_webhooks      = try(var.helm_config.disable_webhooks, false)
  reuse_values          = try(var.helm_config.reuse_values, false)
  reset_values          = try(var.helm_config.reset_values, false)
  force_update          = try(var.helm_config.force_update, false)
  recreate_pods         = try(var.helm_config.recreate_pods, false)
  cleanup_on_fail       = try(var.helm_config.cleanup_on_fail, false)
  max_history           = try(var.helm_config.max_history, 0)
  atomic                = try(var.helm_config.atomic, false)
  skip_crds             = try(var.helm_config.skip_crds, false)
  render_subchart_notes = try(var.helm_config.render_subchart_notes, true)

  disable_openapi_validation = try(var.helm_config.disable_openapi_validation, false)
  wait                       = try(var.helm_config.wait, true)
  wait_for_jobs              = try(var.helm_config.wait_for_jobs, false)
  dependency_update          = try(var.helm_config.dependency_update, false)
  replace                    = try(var.helm_config.replace, false)
  lint                       = try(var.helm_config.lint, false)

  values = try(var.helm_config.values, null)
  dynamic "set" {
    iterator = each_item
    for_each = try(var.helm_config.set, null) != null ? distinct(concat(var.set_values, var.helm_config.set)) : var.set_values

    content {
      name  = each_item.value.name
      value = each_item.value.value
      type  = try(each_item.value.type, null)
    }
  }

  dynamic "set_sensitive" {
    iterator = each_item
    for_each = try(var.helm_config.set_sensitive, null) != null ? concat(var.helm_config.set_sensitive, var.set_sensitive_values) : var.set_sensitive_values

    content {
      name  = each_item.value.name
      value = each_item.value.value
      type  = try(each_item.value.type, null)
    }
  }

  dynamic "set_list" {
    iterator = each_item
    for_each = try(var.helm_config.set_list, null) != null ? concat(var.helm_config.set_list, var.set_list_values) : var.set_list_values

    content {
      name  = each_item.value.name
      value = each_item.value.value
    }
  }

  postrender {
    binary_path = try(var.helm_config.postrender, "")
  }
}
