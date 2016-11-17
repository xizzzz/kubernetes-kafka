kubectl delete namespace kafka
rm -R ./zookeeper/data/ && kubectl delete pv datadir-zoo-0 datadir-zoo-1 datadir-zoo-2
rm -R ./data/ && kubectl delete pv datadir-kafka-0 datadir-kafka-1 datadir-kafka-2
