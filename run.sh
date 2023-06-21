#!/bin/bash

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



echo "" > /logs/log.txt
cd /DynamoRIO-Linux-9.0.1
while IFS= read -r test_name; do
  if [[ -n "$test_name" ]]; then
      echo "Profiling file $test_name" >> /logs/log.txt
      bin64/drrun -c /dynamorio/build/bin/libmy_profiler.so -only_from_app -- "$test_name" >> /logs/log.txt

      # this line profiles binary for heap allocations, and it uses valgrind
      valgrind "$test_name" >> /logs/log.txt 2>&1
  fi
done < /logs/materials.txt



# parse logs
bash /parser.sh /logs/log.txt /logs/result.csv
