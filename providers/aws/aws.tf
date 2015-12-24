variable "availability_zone" {}
variable "cluster_member_count" {default = "3"}
variable "cluster_iam_profile" {default = "" }
variable "cluster_instance_type" {default = "m3.medium"}
variable "cluster_volume_size" {default = "20"}
variable "cluster_data_volume_size" {default = "20"}
variable "datacenter" {default = "aws"}
variable "long_name" {default = "mariadb-cluster"}
variable "network_ipv4" {default = "10.0.0.0/16"}
variable "network_subnet_ip4" {default = "10.0.0.0/16"}
variable "short_name" {default = "db"}
variable "source_ami" { }
variable "ssh_key" {default = "~/.ssh/id_rsa.pub"}
variable "ssh_username"  {default = "ec2-user"}

resource "aws_vpc" "main" {
  cidr_block = "${var.network_ipv4}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.long_name}"
  }
}

resource "aws_subnet" "main" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.network_subnet_ip4}"
  availability_zone = "${var.availability_zone}"
  tags {
    Name = "${var.long_name}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.long_name}"
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "${var.long_name}"
  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_ebs_volume" "cluster-storage" {
  availability_zone = "${var.availability_zone}"
  count = "${var.cluster_member_count}"
  size = "${var.cluster_data_volume_size}"
  type = "gp2"

  tags {
    Name = "${var.short_name}-lvm-${format("%02d", count.index+1)}"
  }
}

resource "aws_instance" "db" {
  ami = "${var.source_ami}"
  availability_zone = "${var.availability_zone}"
  instance_type = "${var.cluster_instance_type}"
  count = "${var.cluster_member_count}"
  vpc_security_group_ids = ["${aws_security_group.db.id}",
    "${aws_vpc.main.default_security_group_id}"]

  key_name = "${aws_key_pair.deployer.key_name}"

  associate_public_ip_address = true

  subnet_id = "${aws_subnet.main.id}"

  iam_instance_profile = "${var.cluster_iam_profile}"

  root_block_device {
    delete_on_termination = true
    volume_size = "${var.cluster_volume_size}"
  }

  tags {
    Name = "${var.short_name}-${format("%02d", count.index+1)}"
    sshUser = "${var.ssh_username}"
    role = "dbhost"
    dc = "${var.datacenter}"
  }
}

resource "aws_volume_attachment" "db-lvm-attachment" {
  count = "${var.cluster_member_count}"
  device_name = "xvdh"
  instance_id = "${element(aws_instance.db.*.id, count.index)}"
  volume_id = "${element(aws_ebs_volume.cluster-storage.*.id, count.index)}"
  force_detach = true
}

resource "aws_security_group" "db" {
  name = "${var.short_name}"
  description = "Allow inbound traffic for MariaDB hosts"
  vpc_id = "${aws_vpc.main.id}"

  ingress { # SSH
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # MySQL
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "key-${var.short_name}"
  public_key = "${file(var.ssh_key)}"
}

output "vpc_subnet" {
  value = "${aws_subnet.main.id}"
}

output "control_security_group" {
  value = "${aws_security_group.db.id}"
}

output "default_security_group" {
  value = "${aws_vpc.main.default_security_group_id}"
}

output "cluster_ids" {
  value = "${join(\",\", aws_instance.db.*.id)}"
}

output "cluster_ips" {
  value = "${join(\",\", aws_instance.db.*.public_ip)}"
}
