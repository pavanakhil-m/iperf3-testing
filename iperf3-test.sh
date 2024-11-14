CLIENT_POD="iperf3-client-dell"
SERVER_POD="iperf3-server-dell"

CSN="kubectl exec -it $CLIENT_POD -- iperf3 -c $SERVER_POD -t 30 -i 1 -P 4"
CSNR="kubectl exec -it $CLIENT_POD -- iperf3 -c $SERVER_POD -t 30 -i 1 -P 4 --reverse"
CSNO="kubectl exec -it $CLIENT_POD -- iperf3 -c $SERVER_POD -t 35 -i 1 -P 4 -O 5"
CSNRO="kubectl exec -it $CLIENT_POD -- iperf3 -c $SERVER_POD -t 35 -i 1 -P 4 -O 5 --reverse"
CSNB="kubectl exec -it $CLIENT_POD -- iperf3 -c $SERVER_POD -t 30 -i 1 -P 4 --bidir"
CSNOB="kubectl exec -it $CLIENT_POD -- iperf3 -c $SERVER_POD -t 35 -i 1 -P 4 -O 5 --bidir"


COMMANDS=("$CSN" "$CSNR" "$CSNO" "$CSNRO" "$CSNB" "$CSNBR" "$CSNOB" "$CSNROB")
COMMAND_NAMES=("CSN" "CSNR" "CSNO" "CSNRO" "CSNB" "CSNBR" "CSNOB" "CSNROB")

START_TIME=$(date +"%T")
echo "Starting the test at $START_TIME"

HR=$(date +"%H")
MIN=$(date +"%M")
SEC=$(date +"%S")

echo "creating final result file"
FILENAME="finaldata_${HR}_${MIN}_${SEC}.txt"
> "$FILENAME"

echo "starting test in 5 secs"
sleep 5

for i in "${!COMMANDS[@]}"; do
    for k in {1..5}; do
        cmd_start_time=$(date +"%T")

        echo "Starting test ${COMMAND_NAMES[i]} iteration $k at $cmd_start_time"
        echo "------------------------------------------------------------------------------------" >> "$FILENAME"
        echo "STARTING TEST ${COMMAND_NAMES[i]} ITERATION $k AT $cmd_start_time" >> "$FILENAME"
        echo "------------------------------------------------------------------------------------" >> "$FILENAME"


        ${COMMANDS[i]} > "result-${COMMAND_NAMES[i]}-$k.txt"

        for j in {1..30}; do
            echo "$j"
        done
        
        echo "Test ${COMMAND_NAMES[i]} iteration $k complete. Sleeping for 10 seconds..."
        sleep 10
    done
    echo "All iterations for ${COMMAND_NAMES[i]} complete...."
    echo "------------------------------------------------------------------------------------" >> "$FILENAME"

done

END_TIME=$(date +"%T")
TIME_DIFF=$(dateutils.ddiff "$START_TIME" "$END_TIME" -f "%H:%M:%S")

echo "Test completed in $TIME_DIFF"

echo "files generation completed"
sleep 10

echo "starting results processing"

echo "CSN & CSNR"
./CSN-results.sh "$FILENAME"
sleep 10

echo "CSNO & CSNRO"
./CSNO-results.sh "$FILENAME"
sleep 10

echo "CSNB & CSNBR"
./CSNB-results.sh "$FILENAME"
sleep 10

echo "CSNOB & CSNROB"
./CSNOB-results.sh "$FILENAME"
sleep 10

echo "cleaning up"
./cleanup-res.sh

echo "DONE! Get back to Work"