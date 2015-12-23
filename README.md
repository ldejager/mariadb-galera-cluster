# MariaDB Cluster

MariaDB Galera Cluster deployment with `terraform` for automated infrastructure provisioning and `ansible` for software deployments. The installations are based on `MariaDB 10.1` which now includes the Galera components by default.

The goal of the repository is to make it as easy as possible for anyone to create a MariaDB Galera cluster on the providers below. If you would like support for any other provider, feel free to create a pull request.

Currently, I'm aiming to have the installation support the following list of providers.

- [x] Digital Ocean
- [x] GCE
- [ ] AWS
- [ ] OpenStack

## Installation

To get started, review and modify the configuration in the files below as required. See the provider installation docs below for further information.

```shell
ansible.cfg
providers/<provider>.sample.tf
provisioning/roles/dbhost/defaults/main.yml
```

- [x] [Digital Ocean Installation Documentation](docs/digitalocean.md)
- [x] [Google Compute Engine Installation Documentation](docs/gce.md)

### Bootstrapping

Once the MariaDB Galera cluster has been created, you'll need to bootstrap the cluster by following the [Bootstrapping](docs/bootstrapping.md) documentation.

**TODO / IMPROVEMENTS**

- [ ] Create private network (Digital Ocean) and utilize that instead of eth0
