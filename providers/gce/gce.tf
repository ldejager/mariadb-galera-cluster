variable "cluster_type" {default = "n1-standard-1"}
variable "cluster_size" {default = 3}
variable "cluster_volume_size" {default = "20"} # GB
variable "cluster_data_volume_size" {default = "20"} # GB
variable "datacenter" {default = "gce"}
variable "name" {default = "dbcluster"}
variable "network_ipv4" {default = "10.0.0.0/16"}
variable "region" {default = "europe-west1"}
variable "short_name" {default = "db"}
variable "ssh_key" {default = "~/.ssh/id_rsa.pub"}
variable "ssh_user" {default = "centos"}
variable "zone" {default = "europe-west1-b"}

# Network
resource "google_compute_network" "db-network" {
  name = "${var.name}"
  ipv4_range = "${var.network_ipv4}"
}

# Firewall
resource "google_compute_firewall" "db-firewall-ext" {
  name = "${var.short_name}-firewall-ext"
  network = "${google_compute_network.db-network.name}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = [
      "22",   # SSH
      "873",  # RSync
      "3306", # MySQL
      "4567"  # Galera
    ]
  }
}

resource "google_compute_firewall" "db-firewall-int" {
  name = "${var.short_name}-firewall-int"
  network = "${google_compute_network.db-network.name}"
  source_ranges = ["${google_compute_network.db-network.ipv4_range}"]

  allow {
    protocol = "tcp"
    ports = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports = ["1-65535"]
  }
}

# Instances
resource "google_compute_disk" "dbcluster-lvm" {
  name = "${var.short_name}-lvm-${format("%02d", count.index+1)}"
  type = "pd-ssd"
  zone = "${var.zone}"
  size = "${var.cluster_data_volume_size}"

  count = "${var.cluster_size}"
}

resource "google_compute_instance" "dbcluster-nodes" {
  name = "${var.short_name}-${format("%02d", count.index+1)}"
  description = "${var.name} node #${format("%02d", count.index+1)}"
  machine_type = "${var.cluster_type}"
  zone = "${var.zone}"
  can_ip_forward = false
  tags = ["${var.short_name}", "dbcluster"]

  disk {
    image = "centos-7-v20150526"
    size = "${var.cluster_volume_size}"
    auto_delete = true
  }

  disk {
    disk = "${element(google_compute_disk.dbcluster-lvm.*.name, count.index)}"
    auto_delete = false

    device_name = "lvm"
  }

  network_interface {
    network = "${google_compute_network.db-network.name}"
    access_config {}
  }

  metadata {
    dc = "${var.datacenter}"
    role = "dbhost"
    sshKeys = "${var.ssh_user}:${file(var.ssh_key)} ${var.ssh_user}"
    ssh_user = "${var.ssh_user}"
  }

  count = "${var.cluster_size}"

  provisioner "remote-exec" {
    script = "./providers/gce/disk.sh"

    connection {
      type = "ssh"
      user = "${var.ssh_user}"
    }
  }
}

output "dbhost_ips" {
  value = "${join(\",\", google_compute_instance.dbcluster-nodes.*.network_interface.0.access_config.0.nat_ip)}"
}

