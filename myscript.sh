DYNAMORIO_HOME=/DynamoRIO-Linux-9.0.1

cp /my2.cpp $DYNAMORIO_HOME/samples
rm $DYNAMORIO_HOME/samples/CMakeLists.txt
cp /CMakeLists.txt $DYNAMORIO_HOME/samples

cd dynamorio && mkdir build && cd build
cmake -DDynamoRIO_DIR=$DYNAMORIO_HOME/cmake $DYNAMORIO_HOME/samples
make my2

cd /
g++ -O0 -o app /main.cpp
objdump -D /app > /disasm && cat /disasm

cd /DynamoRIO-Linux-9.0.1
bin64/drrun -c /dynamorio/build/bin/libmy2.so -only_from_app -- /app
#bin64/drrun -c samples/bin64/libinstrace_simple.so -only_from_app -- /app
#cat /DynamoRIO-Linux-9.0.1/samples/bin64/instrace.app.* | grep "mul" | wc -l


