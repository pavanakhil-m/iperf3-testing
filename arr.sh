#!/bin/bash

# # Define the result file
# result_file="result-CSN-1.txt"  # You can change this to your actual file name

# # Step 1: grep to find lines containing 'Gbits/sec'
# echo "Step 1: grep 'Gbits/sec' from the file:"
# grep 'Gbits/sec' "$result_file"
# echo "-----------------------------"

# # Step 2: awk to extract the number before 'Gbits/sec'
# echo "Step 2: awk to extract values before 'Gbits/sec':"
# grep 'Gbits/sec' "$result_file" | awk '{for(i=1;i<=NF;i++) if($i ~ /Gbits\/sec/) print $(i-1)}'
# echo "-----------------------------"

# # Step 3: sort the extracted values in descending order
# echo "Step 3: sort the values in descending order:"
# grep 'Gbits/sec' "$result_file" | awk '{for(i=1;i<=NF;i++) if($i ~ /Gbits\/sec/) print $(i-1)}' | sort -nr
# echo "-----------------------------"

# # Step 4: Get the maximum value (first line after sorting)
# echo "Step 4: Get the maximum value (first line):"
# max_bitrate=$(grep 'Gbits/sec' "$result_file" | awk '{for(i=1;i<=NF;i++) if($i ~ /Gbits\/sec/) print $(i-1)}' | sort -nr | head -n 1)
# echo "Max bitrate: $max_bitrate"

# current_time=$(date +"%T")
# echo "Current time: $current_time"

for i in {1..1}; do
    echo "Iteration $i"
done

