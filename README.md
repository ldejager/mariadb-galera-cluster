# MariaDB Cluster

MariaDB Galera Cluster deployment with `terraform` for automated infrastructure provisioning and `ansible` for software deployments.

The following list of providers are supported.

- [x] Digital Ocean
- [ ] AWS
- [ ] OpenStack

## Installation

**WORK IN PROGRESS**

This document is still a work in progress and will be updated as progress is made.

### Digital Ocean

The following defaults exist in the terraform manifests for the Digital Ocean provisioner.

```
variable cluster_member_count { default = 3 }
variable cluster_memory_size { default = "4gb" }
variable image_name { default = "centos-7-0-x64" }
```

If you wish to override any of these, set the variable in the `terraform.tf` file accordingly.

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
ansible all --private-key ~/.ssh/terraform -i ~/bin/terraform-inventory -m ping
db-01 | success >> {
    "changed": false,
    "ping": "pong"
}
```

- If all looks good, proceed to run the ansible playbooks.
```shell
ansible-playbook -i ~/bin/terraform-inventory provisioning/terraform.yml
```


**TODO**

Document and provide sample MariaDB Galera clustering configuration.
