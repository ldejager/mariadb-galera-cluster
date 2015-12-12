provider "digitalocean" {
  token = ""
}

module "do-keypair" {
	source = "./providers/digitalocean/keypair"
  public_key_filename = "~/.ssh/id_rsa.pub"
}

module "do-hosts" {
  source = "./providers/digitalocean/hosts"
  ssh_key = "${module.do-keypair.keypair_id}"
  region_name = "lon1"

  cluster_member_count = 3
}
