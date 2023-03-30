# this script should build repositories you downloaded for analysis (in docker)
# and put all test binary files to /materials directory



cd / && mkdir /materials



# build your sample code
cd /
g++ -O0 -o /materials/app /examples/sample.cpp
#objdump -D /materials/app > /disasm && cat /disasm



# build tests for 'fmt' repo
#cd /fmt && mkdir build && cd build
#cmake ..
#make
#cp /fmt/build/bin/* /materials
