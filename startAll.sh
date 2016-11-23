kubectl create -f 00namespace.yml
./zookeeper/bootstrap/pv.sh
kubectl create -f ./zookeeper/bootstrap/pvc.yml
./bootstrap/pv.sh
kubectl create -f ./bootstrap/pvc.yml
sleep 10
# check that claims are bound
kubectl get pvc --namespace=kafka

#start zookeeper
kubectl create -f ./zookeeper/zookeeper.yaml
kubectl create -f ./zookeeper/service.yml

#start kafka service and pods
kubectl create -f kafka-0-svc.yml 
kubectl create -f kafka-0.yml
kubectl create -f kafka-1-svc.yml
kubectl create -f kafka-1.yml
kubectl create -f kafka-2-svc.yml
kubectl create -f kafka-2.yml

