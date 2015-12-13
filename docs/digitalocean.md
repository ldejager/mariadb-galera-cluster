# Digital Ocean

The following defaults exist in the terraform manifests for the Digital Ocean provisioner.

```
variable cluster_member_count { default = 3 }
variable cluster_memory_size { default = "4gb" }
variable image_name { default = "centos-7-0-x64" }
```

If you wish to override any of these, set the variable in the `terraform.tf` file accordingly. Note that if you have cluster size of less than three, you'll probably need to consider adding a galera arbitrator.

Below is a list of configuration files worth inspecting and adjusting before running the commands below.

```shell

```

The steps below can be used to get started.

- Clone the repository
```shell
git clone git@github.com:ldejager/terraform-mariadb-cluster.git
```
- Change into the repository directory
```shell
cd terraform-mariadb-cluster
```
- Copy the sample digitalocean terraform file to `terraform.tf`
```shell
cp providers/digitalocean.sample.tf terraform.tf
```
- Provide your token and check that the SSH key path is correct in `terraform.tf`
- Review the provided `cloud-config.yml` file and make any amendments if required.
- Run terraform get to download and update the required modules.
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
ansible-playbook -i ~/bin/terraform-inventory provisioning/terraform.yml
```

Once the ansible run is completed, you'll have MariaDB installed and somewhat configured but it is not started.

:exclamation: Ansible is set to enable the `mysqld` service, if using CentOS 7 as per defaults in the terraform defintion, double check that either systemd or init is configured to start MariaDB and not both.

See the [Bootstrapping](bootstrapping.md) documentation to proceed.
