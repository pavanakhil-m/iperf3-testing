echo "------------------------------------------------------------------------------------"
echo "Cleaning up all existing pods"
echo "------------------------------------------------------------------------------------"

podnames=`kubectl get pods | grep iperf | awk '{print $1}' `

if [ -z "$podnames" ]; then
    echo "No pods to delete"
else
    echo "Deleting pods"
    for pod in $podnames; do
        kubectl delete pod $pod
        sleep 5
    done
fi

DELETE_SUCCESS=0
for i in {1..3}; do
    if [ -z "$podnames" ]; then
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