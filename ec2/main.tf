# data "cloudinit_config" "default" {
#   gzip = false
#   base64_encode = false

#   part {
#     filename     = "cloud-init.yaml"
#     content_type = "text/cloud-config"
#     content      = templatefile("${path.module}/templates/cloud-init.yaml", {})
#   }
# }
