provider "aws" {
  access_key = ""
  secret_key = ""
  region = ""
}

module "aws-dc" {
  source = "./providers/aws"
  availability_zone = "eu-west-1"
  ssh_username = "centos"
  source_ami = "ami-96a818fe"

  cluster_member_count = 3
}
