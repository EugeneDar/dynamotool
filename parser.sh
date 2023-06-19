#!/bin/bash

foo() {
    local input_path=$1
    local output_path=$2

    echo "Name,Stack Allocations,Heap Allocations,Heap Frees,Heap Bytes Allocated,Heap Allocations Percentage" > "$output_path"

    local file_name=""
    local stack_allocations=""
    while IFS= read -r line; do
        line=$(echo "$line" | tr -d '\r')
        if [[ $line == *"Profiling file"* ]]; then
            file_name=$(echo "$line" | awk '{print $NF}' | awk -F'/' '{print $NF}')
        elif [[ $line == *"stack allocation instructions executed"* ]]; then
            stack_allocations=$(echo "$line" | awk '{print $(NF-4)}' | tr -d ',')
        elif [[ $line == *"total heap usage"* ]]; then
            heap_allocations=$(echo "$line" | awk '{print $(NF-6)}' | tr -d ',')
            heap_frees=$(echo "$line" | awk '{print $(NF-4)}' | tr -d ',')
            heap_bytes_allocated=$(echo "$line" | awk '{print $(NF-2)}' | tr -d ',')

            percentage=$(echo "scale=5; ($heap_allocations * 100.0) / ($heap_allocations + $stack_allocations)" | bc)

            echo "$file_name,$stack_allocations,$heap_allocations,$heap_frees,$heap_bytes_allocated,$percentage%" >> "$output_path"

            file_name=""
            stack_allocations=""
        fi
    done < "$input_path"
}


input_path="$1"
output_path="$2"

foo "$input_path" "$output_path"
