# set system variable
DYNAMORIO_HOME=/DynamoRIO-Linux-9.0.1



# copying files to release
cp /resourses/my_profiler.cpp $DYNAMORIO_HOME/samples
rm $DYNAMORIO_HOME/samples/CMakeLists.txt
cp /resourses/CMakeLists.txt $DYNAMORIO_HOME/samples



# create .so (from cloned repo we call release files)
cd dynamorio && mkdir build && cd build
cmake -DDynamoRIO_DIR=$DYNAMORIO_HOME/cmake $DYNAMORIO_HOME/samples
make my_profiler



# build tests
bash /collector.sh



# run profiler for built tests
echo "" > /logs/results_output.txt
cd /DynamoRIO-Linux-9.0.1
FILES="/materials/*"
for f in $FILES
do
  echo "Profiling file $f" >> /logs/results_output.txt
  bin64/drrun -c /dynamorio/build/bin/libmy_profiler.so -only_from_app -- "$f" >> /logs/results_output.txt

  # this line profiles binary for heap allocations, so it's optional
  valgrind "$f" >> /logs/results_output.txt 2>&1
done



# process logs to save only important info
echo "" > /logs/processed.txt
while IFS= read -r line; do
    if [[ $line == *"Profiling file"* ]] || [[ $line == *"total heap usage"* ]] || [[ $line == *"Instrumentation results"* ]]; then
        echo "$line" >> /logs/processed.txt
    fi
done < /logs/results_output.txt



# process logs to save only numbers
echo "" > /logs/numbers.txt
while IFS= read -r line; do
  if [[ $line == *"stack allocation instructions executed"* ]]; then
    stack_allocations=$(grep -o '[0-9]\+' <<< "$line")
    echo "Stack allocations: $stack_allocations" >> /logs/numbers.txt
  elif [[ $line == *"total heap usage"* ]]; then
    heap_allocations=$(echo "$line" | awk '{print $5}')
    echo "Heap allocations: $heap_allocations" >> /logs/numbers.txt
  fi
done < /logs/processed.txt
