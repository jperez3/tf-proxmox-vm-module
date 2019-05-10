provider "proxmox" {
    version         = "1.0.0"
	pm_tls_insecure = true
    pm_user         = "${var.proxmox_user}"
    pm_password     = "${var.proxmox_password}"
    pm_api_url      = "${var.proxmox_api}"
}