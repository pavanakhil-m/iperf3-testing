CLIENT="10.28.45.70"
SERVER="10.28.45.68"
CLIENT_POD="iperf3-client-70"
SERVER_POD="iperf3-server-68"
echo "Iperf3 automation between client $CLIENT and server $SERVER"
echo "Starting iperf3 client"

threadArray=(1 2 3 4 8 12)
for th in ${threadArray[@]}; do
    echo "Starting iperf3 client with $th threads"
    kubectl exec -it $CLIENT_POD -- iperf3 -c $SERVER_POD -t 30 -i 1 -P $th > result-$th.txt
    for j in {1..30}; do
        echo $j
    done
    echo "Test with $th threads complete. Sleeping for 10 seconds..."
    sleep 10
done

echo "All tests completed. Processing results..."

> final.txt

# Loop through each result file to extract the maximum bitrate and third-to-last line
for th in ${threadArray[@]}; do
    result_file="result-$th.txt"

    # Extract the maximum bitrate by finding the highest "Gbits/sec" value in the file
    max_bitrate=$(grep 'Gbits/sec' "$result_file" | awk '{for(i=1;i<=NF;i++) if($i ~ /Gbits\/sec/) print $(i-1)}' | sort -nr | head -n 1)

    # Get the third-to-last line from the result file
    third_last_line=$(tail -n 3 "$result_file" | head -n 1)

    # Save to final.txt
    echo "Thread count $th - Max Bitrate: $max_bitrate Gbits/sec" >> final.txt
    echo "Third-to-last line: $third_last_line" >> final.txt
    echo "-----------------------------------" >> final.txt
done

echo "Final summary saved to final.txt."