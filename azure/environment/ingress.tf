resource "helm_release" "ingress" {
  count            = var.deploy_ingress_controller ? 1 : 0
  name             = "ingress-nginx"
  create_namespace = true
  namespace        = length(var.ingress_namespace) > 0 ? var.ingress_namespace : "ingress-controller"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.ingress_controller_helm_chart_version

  dynamic "set" {
    for_each = local.ingress_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
