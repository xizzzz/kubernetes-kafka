
# Kafka as Kubernetes PetSet

Example of three Kafka brokers depending on three Zookeeper instances.

To get consistent service DNS names `kafka-N.broker.kafka`(`.svc.cluster.local`), run everything in a namespace:
```
kubectl create -f 00namespace.yml
```

## Set ExternalIPs
1. Change ExternalIPs in kafka-*-svc.yml, zookeeper/service.yml
2. Change advertised.listeners in kafka-0.yml, kafka-1.yml, kafka-2.yml


## Set up volume claims

This step can be skipped in clusters that support automatic volume provisioning, such as GKE.

We use nfs as persistent volume.

### Set up NFS
If you haven't set up an NFS server,
https://help.ubuntu.com/14.04/serverguide/network-file-system.html

After you start nfs server, run "exportfs -a" to make sure you export it. 

(You can use "showmount -e <NFS server name>" to check the result)

### Create persistent volumes and persistent volume claims
Change the nfs server and path to <b> your NFS server </b> in zookeeper/bootstrap/pv.yml and bootstrap/pv.yml


```
kubectl create -f ./zookeeper/bootstrap/pv.yml
kubectl create -f ./zookeeper/bootstrap/pvc.yml
```

```
kubectl create -f ./bootstrap/pv.yml
kubectl create -f ./bootstrap/pvc.yml
# check that claims are bound
kubectl get pvc --namespace=kafka
```

The volume size in the example is very small. The numbers don't really matter as long as they match. They are only for the prupose of matching persistent volume claim and persistent volume. You can use storage beyond that size.

## Set up Zookeeper

This module contains a copy of `pets/zookeeper/` from https://github.com/kubernetes/contrib/tree/master/pets/zookeeper.

Start zookeeper.
```
kubectl create -f ./zookeeper/zookeeper.yaml
kubectl create -f ./zookeeper/service.yml
```

## Start Kafka

```
kubectl create -f ./kafka-0-svc.yml
kubectl create -f ./kafka-1-svc.yml
kubectl create -f ./kafka-2-svc.yml
kubectl create -f ./kafka-0.yml
kubectl create -f ./kafka-1.yml
kubectl create -f ./kafka-2.yml
```

You might want to verify in logs that Kafka found its own DNS name(s) correctly. Look for records like:
```
kubectl logs kafka0-0 | grep "Registered broker"
# INFO Registered broker 0 at path /brokers/ids/0 with addresses: PLAINTEXT -> EndPoint(kafka-0.broker.kafka.svc.cluster.local,9092,PLAINTEXT)
```

## Testing manually

There's a Kafka pod that doesn't start the server, so you can invoke the various shell scripts.
```
kubectl create -f test/99testclient.yml
```

See `./test/test.sh` for some sample commands.

## Automated test, while going chaosmonkey on the cluster

This is WIP, but topic creation has been automated. Note that as a [Job](http://kubernetes.io/docs/user-guide/jobs/), it will restart if the command fails, including if the topic exists :(
```
kubectl create -f test/11topic-create-test1.yml
```

Pods that keep consuming messages (but they won't exit on cluster failures)
```
kubectl create -f test/21consumer-test1.yml
```

## Teardown & cleanup

Testing and retesting... delete the namespace. PVs are outside namespaces so delete them too.
```
kubectl delete namespace kafka
kubectl delete pv datadir-zoo-0 datadir-zoo-1 datadir-zoo-2
kubectl delete pv datadir-kafka-0 datadir-kafka-1 datadir-kafka-2
```
