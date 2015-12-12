variable short_hostname { default = "db" }
variable public_key_filename { default = "~/.ssh/id_rsa.pub" }

resource "digitalocean_ssh_key" "default" {
  name = "${var.short_hostname}-key"
  public_key = "${file(var.public_key_filename)}"
}

output "keypair_id" {
  value = "${digitalocean_ssh_key.default.id}"
}
