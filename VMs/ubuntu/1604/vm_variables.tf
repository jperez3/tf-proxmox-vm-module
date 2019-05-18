
#####################
# Network Variables #
#####################


variable "vm_network_gateway" {
    description = "default gateway for VM network interface"
    default     = ""
}

variable "vm_network_ns1" {
    description = "first nameserver for VM network interface"
    default     = "1.1.1.1"
}

variable "vm_network_ns2" {
    description = "second nameserver for VM network interface"
    default     = "8.8.8.8"
}

variable "vm_network_id" {
    description = "network id for VM interface"
    default     = "0"
}


variable "vm_network_model" {
    description = "network interface type"
    default     = "virtio"
}

variable "vm_network_bridge" {
    description = "network bridge for VM communication"
    default     = "vmbr0"
}

variable "vm_network_tag" {
    description = "VLAN tag for network interface"
    default     = ""
}

variable "vm_network_cidr" {
    description = "CIDR block for VMs"
    default     = ""
}

variable "vm_network_last_octet" {
    description = "last octet starting ip eg. 101 if you want to start at 192.168.0.101"
    default     = ""
}

variable "vm_network_cidr_netmask" {
    description = "netmask in slash notation, eg /24"
    default     = ""
}

##################
# Disk Variables #
##################
variable "vm_disk_id" {
    description = "disk ID for VM"
    default     = "0"
}
variable "vm_disk_size" {
    description = "Size of VM's disk in GB"
    default     = "30"
}

variable "vm_disk_type" {
    description = "Type of disk for VM"
    default     = "scsi"
}

variable "vm_disk_location" {
    description = "Proxmox datastore"
    default     = ""
}




########################
# CPU/Memory Variables #
########################

variable "vm_cpu_cores" {
    description = "VM cores"
    default     = "2"
}

variable "vm_cpu_sockets" {
    description = "VM sockets"
    default     = "2"
}

variable "vm_memory" {
    description = "VM memory in MB"
    default     = "4096"
}

##################
# Misc Variables #
##################

variable "vm_type" {
    description = "node type or beginning of fqdn"
    default = "app"
}

variable "vm_description" {
    description = "Description for VM in Proxmox"
    default     = ""
}

variable "vm_count" {
    description = "VM count"
    default     = "1"
}

variable "vm_ssh_user" {
    description = "initial config user for VM"
    default     = "root"
}

variable "vm_os_type" {
    description = "OS Provisioning type"
    default     = "cloud-init"
}

variable "vm_re_connection_type" {
    description = "remote-exec connection type"
    default     = "ssh"  
}

variable "vm_re_connection_user" {
    description = "remote-exec connection user"
    default     = "ansible"
}

variable "service" {
    description = "name of application"
    default     = ""
}

variable "path_to_playbook" {
    description = "path to playbook to run"
    default     = ""
}

variable "vm_template" {
    description = "Name of Ubuntu 16.04 template in Proxmox"
    default     = ""
}

variable "dns_suffix" {
    description = "domain name, eg example.com"
    default     = ""
}

variable "ansible_ssh_key_private" {
    description = "ansible key to use when provisioning VM"
    default     = ""
}

variable "vmid" {
    description = "vmid for instance"
    default     = ""
}
