datafile=$1

echo "*********************************************************************************************" >> $datafile
echo "*********************************************************************************************" >> $datafile

echo "Starting the results processing for CSNB" >> $datafile
filenames=("result-CSNB")
START_TIME=$(date +"%T")
echo "Starting the results processing for CSNB at $START_TIME" >> $datafile

for j in {1..1}; do
    echo "Processing ${filenames[j-1]}" >> $datafile
    echo "******************************************************************************" >> $datafile
    for i in {1..5}; do

        result_file="${filenames[j-1]}-$i.txt"
        
        RX_C_max_bitrate=$(grep 'Gbits/sec' "$result_file" | grep -v 'TX-C' | awk '{for(k=1;k<=NF;k++) if($k ~ /Gbits\/sec/) print $(k-1)}' | sort -nr | head -n 1)
        TX_C_max_bitrate=$(grep 'Gbits/sec' "$result_file" | grep -v 'RX-C' | awk '{for(k=1;k<=NF;k++) if($k ~ /Gbits\/sec/) print $(k-1)}' | sort -nr | head -n 1)
        
        RX_C_last_line=$(tail -n 3 "$result_file" | head -n 1)
        TX_C_last_line=$(tail -n 13 "$result_file" | head -n 1)
        
        echo "Iteration $i - TX_C_Max Bitrate: $TX_C_max_bitrate Gbits/sec" >> $datafile
        echo "Iteration $i - RX_C_Max Bitrate: $RX_C_max_bitrate Gbits/sec" >> $datafile
        echo "TX_C_SUM: $TX_C_last_line" >> $datafile
        echo "RX_C_SUM: $RX_C_last_line" >> $datafile
        echo "-----------------------------------" >> $datafile
    done
done

echo "CANB Processing completed!"