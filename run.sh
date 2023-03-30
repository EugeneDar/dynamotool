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
cd /DynamoRIO-Linux-9.0.1
FILES="/materials/*"
for f in $FILES
do
  echo "Profiling $f"
  bin64/drrun -c /dynamorio/build/bin/libmy_profiler.so -only_from_app -- "$f"
done