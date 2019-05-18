
resource "proxmox_vm_qemu" "vm" {

	count       = "${var.vm_count}"
    name        = "${var.vm_type}${count.index + 1}.${var.service}.${var.env}.${var.dns_suffix}"
	vmid        = "${var.vmid}"
    desc        = "${var.vm_description}"
	target_node = "${element(var.proxmox_hosts, count.index)}"
	clone       = "${var.vm_template}"
	
	cores       = "${var.vm_cpu_cores}"
	sockets     = "${var.vm_cpu_sockets}"
	memory      = "${var.vm_memory}"

    disk {
        id      = "${var.vm_disk_id}"
        type    = "${var.vm_disk_type}"
        size    = "${var.vm_disk_size}"
        storage = "${var.vm_disk_location}"
    }

    network {
        id      = "${var.vm_network_id}"
        model   = "${var.vm_network_model}"
        bridge  = "${var.vm_network_bridge}"
        tag     = "${var.vm_network_tag}"
    }
    
	ssh_user        = "${var.vm_ssh_user}"
	os_type         = "${var.vm_os_type}"
	ipconfig0       = "ip=${var.vm_network_cidr}.${count.index + var.vm_network_last_octet}${var.vm_network_cidr_netmask},gw=${var.vm_network_gateway}"

    lifecycle  {
        ignore_changes = ["target_node"]
    }

    ### fixes networking issues created by cloud-init
    provisioner "remote-exec" {
      inline = [
            "echo '    dns-nameservers ${var.vm_network_ns1} ${var.vm_network_ns2}' | sudo tee -a /etc/network/interfaces.d/50-cloud-init.cfg",
            "echo '    dns-search ${var.service}.${var.env}.${var.dns_suffix}' | sudo tee -a /etc/network/interfaces.d/50-cloud-init.cfg",
            "sudo sed -i '/ens/d' /etc/network/interfaces",
            "sudo reboot"
        ]
        on_failure = "continue"
      connection {
        type        = "${var.vm_re_connection_type}"
        user        = "${var.vm_re_connection_user}"
        private_key = "${file(var.ansible_ssh_key_private)}"
    }
  }
    ### Wait for server to reboot
    provisioner "local-exec" {
        command = "sleep 15; while ! echo exit | nc ${var.vm_network_cidr}.${count.index + var.vm_network_last_octet} 22; do sleep 3; done"
    }
    ### Run ansible
    provisioner "local-exec" {
        command = "ansible-playbook -u ${var.vm_re_connection_user} -i ${var.vm_network_cidr}.${count.index + var.vm_network_last_octet}, -e 'ansible_python_interpreter=/usr/bin/python3' --private-key ${var.ansible_ssh_key_private} base.yml"
        on_failure = "continue"
    }

    provisioner "local-exec" {
        command = "ansible-playbook -u ${var.vm_re_connection_user} -i ${var.vm_network_cidr}.${count.index + var.vm_network_last_octet}, -e 'ansible_python_interpreter=/usr/bin/python3' --private-key ${var.ansible_ssh_key_private} ${var.path_to_playbook} "
        on_failure = "continue"
    }    
    
    ### Removes host from known hosts when destroyed
    provisioner "local-exec" {
        when    = "destroy"
        command = "sed -i'' -e '/${var.vm_network_cidr}.${count.index + var.vm_network_last_octet}/d' ~/.ssh/known_hosts"
    }

}
