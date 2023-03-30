# Stack allocations profiler

## Installation

    $ git clone https://github.com/EugeneDar/dynamotool.git

## Quick start

    $ sudo docker build -t app .
    $ sudo docker run app


## Explanation

In order to count allocations on a stack, it is necessary to keep track of how the stack pointer is being modified. The stack pointer (rsp) is used to allocate and deallocate memory on the stack.

Push instructions decrement the stack pointer (rsp) by the size of the pushed value, effectively allocating space on the stack. Call instructions push the current value of the instruction pointer (rip) onto the stack, also decrementing the stack pointer by 8 bytes.

Therefore, to count the number of allocations on the stack, it is sufficient to count the number of sub instructions that modify the stack pointer (rsp), push instructions that allocate memory on the stack, and call instructions that push the return address onto the stack. By doing so, one can accurately estimate the total amount of memory that is being allocated on the stack.