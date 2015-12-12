# MariaDB Cluster

MariaDB Galera Cluster deployment with `terraform` for automated infrastructure provisioning and `cloud-config` and `ansible` for software deployments.

:exclamation: The cloud config will with time be translated into ansible playbooks. See the contribution document if you'd like to contribute.

The following list of providers are supported.

- [x] Digital Ocean
- [ ] AWS
- [ ] OpenStack

## Installation

**WORK IN PROGRESS**

This document is still a work in progress and will be updated as progress is made. The following defaults exist in the terraform manifests:

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

Once the hosts have been installed, you will need to manually configure MariaDB clustering. As mentioned above, this document and repository is work in progress so as time goes on, these tasks will be added into ansible playbooks for ease of consumption.

**TODO**

Document and provide sample MariaDB Galera clustering configuration.
