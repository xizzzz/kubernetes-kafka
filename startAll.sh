kubectl create -f 00namespace.yml
kubectl create -f ./zookeeper/bootstrap/pv.yml
kubectl create -f ./zookeeper/bootstrap/pvc.yml

kubectl create -f ./bootstrap/pv.yml
kubectl create -f ./bootstrap/pvc.yml

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

#wait about 1min, everything should be running
