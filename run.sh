# set system variable
DYNAMORIO_HOME=/DynamoRIO-Linux-9.0.1



# copying files to release
cp /my_profiler.cpp $DYNAMORIO_HOME/samples
rm $DYNAMORIO_HOME/samples/CMakeLists.txt
cp /CMakeLists.txt $DYNAMORIO_HOME/samples



# create .so (from cloned repo we call release files)
cd dynamorio && mkdir build && cd build
cmake -DDynamoRIO_DIR=$DYNAMORIO_HOME/cmake $DYNAMORIO_HOME/samples
make my_profiler



# build binary for testing
cd /
g++ -O0 -o app /main.cpp

# print binary disassembler
#objdump -D /app > /disasm && cat /disasm



# run my profiler
cd /DynamoRIO-Linux-9.0.1
bin64/drrun -c /dynamorio/build/bin/libmy_profiler.so -only_from_app -- /app



# run their profiler (this section just for testing)
#cd /DynamoRIO-Linux-9.0.1
#bin64/drrun -c samples/bin64/libinscount.so -only_from_app -- /app


# build tests from downloaded repo
#cd /fmt && mkdir build && cd build
#cmake ..
#make

# run profiler for built tests
#cd /DynamoRIO-Linux-9.0.1
#FILES="/fmt/build/bin/*"
#for f in $FILES
#do
#  echo "Processing $f"
#  bin64/drrun -c samples/bin64/libinstrace_simple.so -only_from_app -- "$f"
#done
#cat /DynamoRIO-Linux-9.0.1/samples/bin64/instrace.* | grep "push" | wc -l