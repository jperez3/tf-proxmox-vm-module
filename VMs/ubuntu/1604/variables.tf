variable "env" {
    description = "environment stg,prd,etc"
    default     = ""
}


variable "proxmox_hosts" {
    description = "list of proxmox hosts"
    default     = []
}

variable "proxmox_api" {
    description = "proxmox API eg, https://proxmox1:8006/api2/json "
    default     = ""
}





