# MariaDB Cluster

MariaDB Galera Cluster deployment with `terraform` for automated infrastructure provisioning and `ansible` for software deployments.

The following list of providers are supported.

- [x] Digital Ocean
- [ ] AWS
- [ ] OpenStack

## Installation

See the [Digital Ocean](docs/digitalocean.md) installation documentation.

### Bootstrapping

See the [Bootstrapping](docs/bootstrapping.md) documentation.

**TODO**

- Create playbook for `mysql_secure_installation`
- Create playbook that sets up the sst_user and password
- Create private network (Digital Ocean) and utilize that instead of eth0
