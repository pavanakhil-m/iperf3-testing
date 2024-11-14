#!/bin/bash

datafile=$1
echo "*********************************************************************************************" >> $datafile
echo "*********************************************************************************************" >> $datafile

echo "Starting the results processing for CSNO & CSNRO" >> $datafile
filenames=("result-CSNO" "result-CSNRO")
START_TIME=$(date +"%T")
echo "Starting the results processing for CSNO & CSNRO at $START_TIME" >> $datafile

for j in {1..2}; do
    echo "Processing ${filenames[j-1]}" >> $datafile
    echo "******************************************************************************" >> $datafile
    for i in {1..5}; do

        result_file="${filenames[j-1]}-$i.txt"
        
        max_bitrate=$(grep 'Gbits/sec' "$result_file" | grep -v 'omitted' | awk '{for(k=1;k<=NF;k++) if($k ~ /Gbits\/sec/) print $(k-1)}' | sort -nr | head -n 1)
        
        third_last_line=$(tail -n 3 "$result_file" | head -n 1)
        
        echo "Iteration $i - Max Bitrate: $max_bitrate Gbits/sec" >> $datafile
        echo "Third-to-last line: $third_last_line" >> $datafile
        echo "-----------------------------------" >> $datafile
    done
done

echo "CANO & CSNRO Processing completed!"






