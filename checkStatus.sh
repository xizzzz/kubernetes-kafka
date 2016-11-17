kubectl logs kafka0-0 --namespace=kafka | grep "Registered broker"
kubectl logs kafka1-0 --namespace=kafka | grep "Registered broker"
kubectl logs kafka2-0 --namespace=kafka | grep "Registered broker"

echo ""
echo "get service status"
kubectl get service --namespace=kafka
echo ""
echo "get pods status"
kubectl get pods --namespace=kafka
