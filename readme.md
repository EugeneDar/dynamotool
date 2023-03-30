# Stack allocations profiler

## Installation

    $ git clone https://github.com/EugeneDar/dynamotool.git

## Quick start

    $ sudo docker build -t app .
    $ sudo docker run app

This code will profile `sample.cpp` file.

You can also uncomment last section (with `fmt` repository) in `collector.sh` and repeat previous steps.

## More tests

If you want to profile more repositories, add their installation to `Dockerfile`. In `collector.sh` implement test builds, and put the resulting binary files in the `/materials` directory.

## Explanation

In order to count allocations on a stack, it is necessary to keep track of how the stack pointer is being modified. The stack pointer (rsp) is used to allocate and deallocate memory on the stack.

in general, the following x86 assembly instructions are commonly used to allocate space on the stack:

`sub esp, N`: This instruction subtracts a constant value N from the stack pointer (ESP) to allocate space on the stack.

`push eax`: This instruction pushes the contents of a register (such as EAX) onto the stack, effectively allocating space on the stack.

`mov [esp], eax`: This instruction moves the contents of a register (such as EAX) into a location on the stack, effectively allocating space on the stack. Note, however, that this instruction does not allocate memory as such, but uses existing memory.

`call foo`: push the current value of the instruction pointer (rip) onto the stack, also decrementing the stack pointer by 8 bytes.

Therefore, to count the number of allocations on the stack, it is sufficient to count the number of sub instructions that modify the stack pointer (rsp), push instructions that allocate memory on the stack, and call instructions that push the return address onto the stack. By doing so, one can accurately estimate the total amount of memory that is being allocated on the stack.

## Limitations

Although allocations may occur during interrupts, they are a relatively insignificant portion of all allocations, and as such, this tool does not track them.

## Paradigm

There are various approaches to defining an allocation, but we choose to define it in terms of a "hardware" operation. Essentially, we consider it from the perspective of modifying a pointer to a stack. For instance, if the compiler anticipates the creation of three fixed-sized variables, it will shift esp only once, and we regard this as a single allocation.