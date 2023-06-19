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



# run profiler for built tests
echo "" > /logs/log.txt
cd /DynamoRIO-Linux-9.0.1
FILES="/materials/*"
for f in $FILES
do
  echo "Profiling file $f" >> /logs/log.txt
  bin64/drrun -c /dynamorio/build/bin/libmy_profiler.so -only_from_app -- "$f" >> /logs/log.txt

  # this line profiles binary for heap allocations, and it uses valgrind
  valgrind "$f" >> /logs/log.txt 2>&1
done



# parse logs
bash /parser.sh /logs/log.txt /logs/result.csv
