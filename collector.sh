# this script should build repositories you downloaded for analysis (in docker)
# and put all test binary files to /materials directory



cd / && mkdir /materials



# build your sample code
#cd /
#g++ -O0 -o /materials/app /examples/sample.cpp
#objdump -D /materials/app > /disasm && cat /disasm



# build tests for 'fmt' repo
cd /fmt && mkdir build && cd build
cmake ..
make
cp /fmt/build/bin/* /materials



# build tests for 'leveldb' repo
cd /leveldb && mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .
cp /leveldb/build/db_bench /materials
cp /leveldb/build/c_test /materials
cp /leveldb/build/env_posix_test /materials



# build tests for 'spdlog' repo
cd /spdlog && mkdir build && cd build
cmake -DSPDLOG_BUILD_TESTS=ON ..
cmake --build .
cp /spdlog/build/tests/spdlog-utests /materials
cp /spdlog/build/example/example /materials
