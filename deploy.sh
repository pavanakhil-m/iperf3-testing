POD_IP=$1
last=$(echo "$POD_IP" | awk -F'.' '{print $4}')

echo "*********************************************************************************************"
echo "replacing IP address $POD_IP in the deployment file"
echo "*********************************************************************************************"

sed -i "s/name: .*/name: iperf3-client-${last}/g" iperf3-client-01.yaml
sleep 5
sed -i "s/hostname:.*/hostname: \"${POD_IP}\"/g" iperf3-client-01.yaml

sleep 5

echo "*********************************************************************************************"
echo "Deploying the pod with the new IP address"
kubectl create -f iperf3-client-01.yaml

sleep 10



