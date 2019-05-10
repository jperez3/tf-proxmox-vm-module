# tf-proxmox-vm-module

## General

* Description: Proxmox VM provisioning module
* Provider: [Telmate/terraform-provider-proxmox](https://github.com/Telmate/terraform-provider-proxmox)
* Requirements: Ansible, OS X, Terraform, Proxmox Cluster
* Supported VM OSes: Ubuntu 16.04


## Setup

### Proxmox

* Create an Ubuntu 16.04 VM template
* Change/note root password
* Add `ansible` user and add to sudoers 
* Create/Add `ansible` public key to VM
* Remove unneccessary `cloud-init` modules from VM (especially the `apt` one because creates problems for ansible)


### Provider configuration


#### Mac

* Download provider/provisioner

```
go install github.com/Telmate/terraform-provider-proxmox/cmd/terraform-provider-proxmox
go install github.com/Telmate/terraform-provider-proxmox/cmd/terraform-provisioner-proxmox
```

* Move provider and provisioner to `terraform` provider directory (eg `~/.terraform.d/plugins`) and append version `_v.1.0.0`:

```
~/.terraform.d/plugins$ ls
terraform-provider-proxmox_v1.0.0    terraform-provisioner-proxmox_v1.0.0
```

_Note: that's not the given version number, it's just what I set because Terraform complains about needing a version number_


* Test terraform without module first to make sure the provider is working.





### Gotchas

#### Proxmox

* Provisioning two host at a time is a no go. I speculate it's something to do with the proxmox api, but I'm not quite sure. Help would be greatly appreciated

#### Terraform

* The handling of Proxmox secrets doesn't feel right, currently using a `secret_variables.tf` file and put it in `.git-ignore` to keep it off of github. I plan on setting up `HashiCorp Vault` in the future. 

#### VMs

* The Ubuntu 16.04 image I used couldn't set the network interface nameservers right, so I added additional `remote-exec` instructions to add it.
* `cloud-init` is good for setting the hostname, IP address, gateway, but I moved away from it for anything else.



## Module Usage

```
module "test-vm" {
    source = "git::git@github.com:jperez3/tf-proxmox-vm-module.git//VMs/ubuntu/1604?ref=v1.0.0"

    vm_count                = "1"

    vm_type                 = "app"
    service                 = "test"
    env                     = "prd"
    dns_suffix              = "example.com"     
    vm_network_cidr         = "192.168.0"
    vm_network_last_octet   = "123"
    vm_network_cidr_netmask = "/24"    
    vm_network_gateway      = "192.168.0.254"
    vm_network_tag          = "1"
    vm_disk_location        = "nfs-volume"
   
    proxmox_hosts           = ["proxmox1","proxmox2"]
    vm_template             = "ubuntu1604-template-v2"
    ansible_ssh_key_private = "~/.ssh/ansible_provisioning_key"
    path_to_playbook        = "../modules/ansible/ubuntu/base.yml"

    proxmox_api             = "${var.proxmox_api}"
    proxmox_user            = "${var.proxmox_user}"
    proxmox_password        = "${var.proxmox_password}"

}



## To-Do

* Resize disk on provisioning
* Provide more examples
* Add useful outputs