# Digital Ocean

The steps below explains how to get a MariaDB Galera cluster built on Digital Ocean using `terraform` and `ansible`.

Before you get started, review the terraform manifest below's default values.

```shell
./providers/digitalocean/hosts/main.tf
```

```
variable cluster_member_count { default = 3 }
variable cluster_memory_size { default = "4gb" }
variable image_name { default = "centos-7-0-x64" }
```

If you wish to override any of these, set the variable in the `digitalocean.tf` file accordingly. Note that if you have cluster size of less than three, you'll probably need to consider adding a galera arbitrator.

Run the following steps to get started.

- Clone the repository
```shell
git clone git@github.com:ldejager/terraform-mariadb-cluster.git
```
- Change into the repository directory
```shell
cd terraform-mariadb-cluster
```
- Copy the sample digitalocean terraform file to `digitalocean.tf`
```shell
cp providers/digitalocean.sample.tf digitalocean.tf
```
- Provide your token and check that the SSH key path is correct in `terraform.tf`

```shell
terraform get
```
- Run terraform plan and review the output.
```shell
terraform plan
```
- If you are satisfied with what terraform is going to do, run the `apply` step below.
```shell
terraform apply
```

Once the hosts have been created on Digital Ocean, you will need to run the ansible playbooks to install the common packages as well as the MariaDB server and client software.

:exclamation: The ansible run process depends on `terraform-inventory` which can be obtained from the URL below.

https://github.com/adammck/terraform-inventory

Review the configuration in `ansible.cfg`, specifically the path to the SSH key you've used in terraform.

- To test the connectivity to the newly deployed hosts, run the ansible ping module.
```shell
ansible all -i ~/bin/terraform-inventory -m ping
db-01 | success >> {
    "changed": false,
    "ping": "pong"
}
```

- If all looks good, proceed to run the ansible playbooks.
```shell
ansible-playbook -u root -i ~/bin/terraform-inventory provisioning/terraform.yml
```

Once the ansible run is completed, you'll have MariaDB installed and configured with the root password set to what you have defined in `provisioning/roles/dbhost/defaults/main.yml`

See the [Bootstrapping](bootstrapping.md) documentation to proceed.
