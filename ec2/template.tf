data "template_file" "prometheus_cloudinit" {
  template = file("${path.module}/templates/cloud-init.yaml")

  vars = {
    loadbalancer_dns = var.loadbalancer_dns
  }
}

data "cloudinit_config" "default" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.prometheus_cloudinit.rendered
  }
}
