# Google Compute Engine

The steps below explains how to get a MariaDB Galera cluster built on Google Compute Engine using `terraform` and `ansible`.

Before you get started, review the default values in the terraform manifest below.

```shell
./providers/gce/gce.tf
```

```
variable "cluster_type" {default = "n1-standard-1"}
variable "cluster_size" {default = 3}
variable "cluster_volume_size" {default = "20"} # GB
variable "cluster_data_volume_size" {default = "20"} # GB
variable "region" {default = "europe-west1"}
variable "zone" {default = "europe-west1-b"}
```

If you wish to override any of these, set the variable in the `gce.tf` file accordingly. Note that if you have cluster size of less than three, you'll probably need to consider adding a galera arbitrator.

Run the following steps to get started.

- Clone the repository
```shell
git clone git@github.com:ldejager/terraform-mariadb-cluster.git
```
- Change into the repository directory
```shell
cd terraform-mariadb-cluster
```
- Copy the sample GCE terraform file to `gce.tf`
```shell
cp providers/gce.sample.tf gce.tf
```
- Provide your credentials, project ID and check that the SSH key path is correct in `terraform.tf`

To setup credentials, login to your Google Cloud Platform console and navigate to the **API Manager** section. From there navigate to the **Credentials** menu item and create a new "Service account key".

Give it a useful name and select JSON as the key type. This is the file you will reference in your `gce.tf` under the credentials section.

Next, run the list of commands below.

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

Once the hosts have been created on Google Cloud Compute, you will need to run the ansible playbooks to install the common packages as well as the MariaDB server and client software.

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
ansible-playbook --sudo -u centos -i ~/bin/terraform-inventory provisioning/terraform.yml
```

:exclamation: For GCE, the default user is centos and you need to use sudo when running the playbooks.

Once the ansible run is completed, you'll have MariaDB installed and configured with the root password set to what you have defined in `provisioning/roles/dbhost/defaults/main.yml`

See the [Bootstrapping](bootstrapping.md) documentation to proceed.
