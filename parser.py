import csv


class Structure:
    def __init__(self, name, stack_allocations, heap_allocations, heap_frees, heap_bytes_allocated):
        self.name = name
        self.stack_allocations = stack_allocations.replace(',', '')
        self.heap_allocations = heap_allocations.replace(',', '')
        self.heap_frees = heap_frees.replace(',', '')
        self.heap_bytes_allocated = heap_bytes_allocated.replace(',', '')


def fill_data(input_path):
    notes = list()
    with open(input_path, "r") as file:
        file_name = ""
        stack_allocations = ""
        heap_allocations = ""

        for line in file:
            line = line.strip()
            if "Profiling file" in line:
                file_name = (line.split()[-1]).split("/")[-1]
            elif "stack allocation instructions executed" in line:
                stack_allocations = line.split()[-5]
            elif "total heap usage" in line:
                heap_allocations = line.split()[-7]
                heap_frees = line.split()[-5]
                heap_bytes_allocated = line.split()[-3]

                notes.append(Structure(file_name, stack_allocations, heap_allocations, heap_frees, heap_bytes_allocated))
                file_name = ""
                stack_allocations = ""
    return notes


def write_data_to_csv(structures, filename):
    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Name', 'Stack Allocations', 'Heap Allocations', 'Heap Frees', 'Heap Bytes Allocated'])
        for structure in structures:
            writer.writerow([structure.name, structure.stack_allocations, structure.heap_allocations, structure.heap_frees, structure.heap_bytes_allocated])
    print(f"Structures written to {filename} successfully.")


# input_path = "/logs/log.txt"
input_path = "results_output.txt"
# output_path = "/logs/data.csv"
output_path = "data.csv"

notes = fill_data(input_path)
write_data_to_csv(notes, output_path)
