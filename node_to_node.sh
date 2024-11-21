#manual addition of ips according to the case
ips=( "10.112.188.136" "10.112.188.137" "10.112.188.138" "10.112.188.140" "10.112.188.141" "10.112.188.142" "10.112.188.143" "10.112.188.144" "10.112.188.145"
"10.112.188.146")

for i in "${ips[@]}"; do
    echo "Going into deployment file for clinet IPS"
    ./deploy.sh $i
    echo "Checking the status of the pod"
    last=$(echo "$i" | awk -F'.' '{print $4}')
    pod_status=$(kubectl get pods | grep iperf3-client-${last} | awk '{print $3}')
    if [ "$pod_status" == "Running" ]; then
        echo "Pod is running..."
        ./runtest.sh $last
        
        echo "delete the pod"
        kubectl delete pod iperf3-client-${last}
        sleep 20
    else
        continue
    fi
done

