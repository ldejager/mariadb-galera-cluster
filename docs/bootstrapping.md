# Bootstrapping the cluster

In order to bring up the cluster, you need to bootstrap one of the nodes using the command below:

```shell
galera_new_cluster
```

In a separate terminal, run the MySQL command below:

```shell
show status like 'wsrep%';
```

Out of all the output, you should see that you have one member in the cluster, it's synced and it's write set replication ready.

```shell
wsrep_cluster_size           | 1
wsrep_local_state_comment    | Synced
wsrep_ready                  | ON
```

Proceed to start the other nodes MariaDB process as normal using the command below:

```shell
service mysql start
```

Once the other nodes are online, check the MariaDB terminal window by running the wsrep status command again. You should see that the cluster size has increased as the other nodes have joined.
