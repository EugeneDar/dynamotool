# Stack allocations profiler

## Installation

    $ git clone https://github.com/EugeneDar/dynamotool.git

## Quick start

    $ sudo docker build -t app .
    $ sudo docker run -v <path/to/results>:/logs app

This code will profile `sample.cpp` file and generate `data.csv` file in the specified directory.

The `fmt`, `leveldb`, `spdlog` and `openssl` repositories examples in the `collector.sh` script are simply demonstrations of what can be done with the script. By uncommenting those sections and repeating the previous steps, you can include those repositories in the profiling process.

## More tests

To profile additional repositories, simply add their installation instructions to the Dockerfile. In `collector.sh` implement test builds, and place the resulting binary files paths into the `/logs/materials.txt` file.

## Visualization

To visualize the results, run following command:

    $ python3 painter.py

## Explanation

In order to count allocations on a stack, it is necessary to keep track of how the stack pointer is being modified. The stack pointer (rsp) is used to allocate and deallocate memory on the stack.

in general, the following x86 assembly instructions are commonly used to allocate space on the stack:

`sub esp, N`: This instruction subtracts a constant value N from the stack pointer (`esp`) to allocate space on the stack.

`push eax`: This instruction pushes the contents of a register (such as `eax`) onto the stack, effectively allocating space on the stack.

`mov [ebp], eax`: This instruction moves the contents of a register (such as `eax`) into a location on the stack, effectively allocating space on the stack. Note, however, that this instruction does not allocate memory as such, but uses existing memory.

`call foo`: push the current value of the instruction pointer (`rip`) onto the stack, also decrementing the stack pointer by 8 bytes.

Therefore, to count the number of allocations on the stack, it is sufficient to count the number of sub instructions that modify the stack pointer (rsp), push instructions that allocate memory on the stack, and call instructions that push the return address onto the stack. By doing so, one can accurately estimate the total amount of memory that is being allocated on the stack.

## Paradigm

There are various approaches to defining an allocation, but we choose to define it in terms of a "hardware" operation. Essentially, we consider it from the perspective of modifying a pointer to a stack. For instance, if the compiler anticipates the creation of three fixed-sized variables, it will shift esp only once, and we regard this as a single allocation.

## Limitations

Although allocations may occur during interrupts, they are a relatively insignificant portion of all allocations, and as such, this tool does not track them.
