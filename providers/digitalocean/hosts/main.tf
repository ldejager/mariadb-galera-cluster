variable cluster_member_count { default = 3 }
variable cluster_memory_size { default = "4gb" }
variable image_name { default = "centos-7-0-x64" }
variable region_name { default = "lon1" }
variable short_hostname { default = "db" }
variable ssh_key { }

resource "digitalocean_droplet" "db" {
  count = "${var.cluster_member_count}"
  name = "${var.short_hostname}-${format("%02d", count.index+1)}"
  image = "${var.image_name}"
  region = "${var.region_name}"
  size = "${var.cluster_memory_size}"
  ssh_keys = ["${var.ssh_key}"]
  user_data = "${file("cloud-config.yml")}"
}

output "cluster_ip_addresses" {
  value = "${join(\",\", digitalocean_droplet.db.*.ipv4_address)}"
}
