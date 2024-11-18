echo "starting pods deployments"
echo "------------------------------------------------------------------------------------"
echo "Cleaning up all existing pods"
echo "------------------------------------------------------------------------------------"

podnames=`kubectl get pods | grep iperf | awk '{print $1}' `
echo $podnames
sleep 5
DELETE_SUCCESS=0
DEPLOY_SUCCESS=0

if [ -z "$podnames" ]; then
    echo "No pods to delete"
    DELETE_SUCCESS=1
    break
else
    echo "Deleting pods"
    for pod in $podnames; do
        echo "kubectl delete pod $pod"
        kubectl delete pod $pod
        sleep 5
    done
fi

for i in {1..3}; do
    pod_check=`kubectl get pods | grep iperf | awk '{print $1}' `
    if [ -z "$pod_check" ]; then
        echo "All pods deleted... Proceeding to deployment"
        DELETE_SUCCESS=1
        break
    else
        
        echo "waiting for pods to be deleted ..."
        sleep 10
    fi 
done

if [ $DELETE_SUCCESS -eq 0 ]; then
    echo "Failed to delete pods. Exiting..."
    exit 1
fi

echo "------------------------------------------------------------------------------------"
echo "Deploying iperf3 pods"
echo "------------------------------------------------------------------------------------"

cores_memory=( "32" "64" )
for value in "${cores_memory[@]}"; do
    echo "Deploying Server $value cores $value GB pod"
    kubectl create -f dell-$value/is3-dell-$value.yaml
    sleep 5
    echo "Deploying Client $value cores $value GB pod"
    kubectl create -f dell-$value/ic3-dell-$value.yaml
    sleep 5

    CS_STATUS=`kubectl get pods | grep iperf | awk '{print $3}' | grep -E 'Pending|Error ' `
    sleep 5

    for i in {1..3}; do
        if [ -z "$CS_STATUS" ]; then
            echo "All pods deployed successfully"
            DEPLOY_SUCCESS=1
            break
        else
            echo "waiting for pods to be deployed ..."
            sleep 10
        fi
    done

    if [ $DEPLOY_SUCCESS -eq 0 ]; then
        echo "Failed to deploy pods. Exiting..."
        exit 1
    fi

    echo "Applpying Service"
    kubectl apply -f dell-$value/iss-dell-$value.yaml

    echo "Both client and server deployed successfully"
    echo "------------------------------------------------------------------------------------"

    ./iperf3-test.sh $value
done








