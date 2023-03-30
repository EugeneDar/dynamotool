void bar() {

}

void foo() {
    int a = 1;
    bar();
}

int main () {
    for (int i = 0; i < 10000; ++i) {
        foo();
    }
}