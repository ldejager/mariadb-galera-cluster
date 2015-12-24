# AWS

The steps below explains how to get a MariaDB Galera cluster built on AWS (with VPC) using `terraform` and `ansible`.

Before you get started, review the default values in the terraform manifest below.

```shell
./providers/aws/aws.tf
```

```
variable "cluster_instance_type" {default = "m3.medium"}
variable "cluster_volume_size" {default = "20"}
variable "cluster_data_volume_size" {default = "20"}
variable "ssh_username"  {default = "ec2-user"}
```

If you wish to override any of these, set the variable in the `aws.tf` file accordingly. Note that if you have cluster size of less than three, you'll probably need to consider adding a galera arbitrator.

Run the following steps to get started.

- Clone the repository
```shell
git clone git@github.com:ldejager/terraform-mariadb-cluster.git
```
- Change into the repository directory
```shell
cd terraform-mariadb-cluster
```
- Copy the sample AWS terraform file to `aws.tf`
```shell
cp providers/aws.sample.tf aws.tf
```
- Provide your credentials and region.

To setup credentials, login to your AWS EC2 console and navigate to the **Identity & Access Management (IAM)** service. From there create a new user. Make sure that you leave the "Generate an access key for each user" option checked and click the “Create” button.

Download and store the newly generated details safely. Next you'll need to attach a policy to the newly created user, even though the "AmazonEC2FullAccess" assigns permissions that are technically not needed, it's the easiest.

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

Once the hosts have been created on AWS, you will need to run the ansible playbooks to install the common packages as well as the MariaDB server and client software.

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
ansible-playbook --sudo -u ec2-user -i ~/bin/terraform-inventory provisioning/terraform.yml
```

:exclamation: For AWS, the default user for image `ami-1f5dfe6c` is ec2-user and you need to use sudo when running the playbooks.

Once the ansible run is completed, you'll have MariaDB installed and configured with the root password set to what you have defined in `provisioning/roles/dbhost/defaults/main.yml`

See the [Bootstrapping](bootstrapping.md) documentation to proceed.
