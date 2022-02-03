locals {
  ## Construct nginx ingress settings
  keylist = [
    for val in var.ingress_white_list_ip_ranges :
    format("controller.service.loadBalancerSourceRanges[%d]", index(var.ingress_white_list_ip_ranges, val))
  ]
  valuelist = [
    for val in var.ingress_white_list_ip_ranges :
    val
  ]
  loadBalancerSourceRanges = zipmap(local.keylist, local.valuelist)
  default_ingress_options = {
    "controller.ingressClass"              = "nginx"
    "controller.service.type"              = "LoadBalancer"
    "controller.admissionWebhooks.enabled" = "false"
  }
  ingress_settings = merge(var.ingress_settings, local.loadBalancerSourceRanges, local.default_ingress_options)

}