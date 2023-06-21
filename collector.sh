# this script should build repositories you downloaded for analysis (in docker)
# and put all test binary files to /materials directory



cd / && touch /logs/materials.txt
echo "" > /logs/materials.txt



# build your sample code
#cd /examples
#g++ -O0 -o app sample.cpp
#echo /examples/app >> /logs/materials.txt
#objdump -D app > /disasm && cat /disasm



# build tests for 'fmt' repo
cd /fmt && mkdir build && cd build
cmake ..
make
for file in /fmt/build/bin/*; do
    if [ -f "$file" ]; then
        echo "$file" >> /logs/materials.txt
    fi
done



# build tests for 'leveldb' repo
cd /leveldb && mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .
{ echo /leveldb/build/db_bench
  echo /leveldb/build/c_test
  echo /leveldb/build/env_posix_test
} >> /logs/materials.txt




# build tests for 'spdlog' repo
cd /spdlog && mkdir build && cd build
cmake -DSPDLOG_BUILD_TESTS=ON ..
cmake --build .
{ echo /spdlog/build/tests/spdlog-utests
  echo /spdlog/build/example/example
} >> /logs/materials.txt



# build tests for 'openssl' repo
cd /openssl
./config
make
for file in /openssl/test/*; do
  filename=$(basename "$file")
  if [[ "$filename" == *test* && "$filename" != *.* ]]; then
    echo "$file" >> /logs/materials.txt
  fi
done
