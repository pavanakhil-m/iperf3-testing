last=$1
echo "********************************************************************************************"

single="kubectl exec -it iperf3-client-${last} -- iperf3 -c iperf3-server-service -t 30 -i 1"
multi="kubectl exec -it iperf3-client-${last} -- iperf3 -c iperf3-server-service -t 30 -i 1 -P 4"


$single > results/result-$last-single.txt
$multi > results/result-$last-multi.txt


echo "********************************************************************************************"
echo "Test completed for $last"
echo "Gathering results..."
echo "********************************************************************************************"
max_bitrate_single=$(grep 'Gbits/sec' "results/result-${last}-single.txt" | awk '{for(k=1;k<=NF;k++) if($k ~ /Gbits\/sec/) print $(k-1)}' | sort -nr | head -n 1)
SUM_SINGLE=$(tail -n 3 "results/result-${last}-single.txt" | head -n 1)

echo "Max Bitrate for single: $max_bitrate_single Gbits/sec" >> results/finaldata-$last.txt
echo "Sum for single: $SUM_SINGLE" >> results/finaldata-$last.txt

max_bitrate_multi=$(grep 'Gbits/sec' "results/result-${last}-multi.txt" | awk '{for(k=1;k<=NF;k++) if($k ~ /Gbits\/sec/) print $(k-1)}' | sort -nr | head -n 1)
SUM_MULTI=$(tail -n 3 "results/result-${last}-multi.txt" | head -n 1)

echo "Max Bitrate for single: $max_bitrate_multi Gbits/sec" >> results/finaldata-$last.txt
echo "Sum for multi: $SUM_MULTI" >> results/finaldata-$last.txt

./cleanup-res.sh

