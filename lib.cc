#include <cstdio>

extern "C" {

bool MY_FLAG = false;

void foo(){
    std::printf("Hello from foo!\n");
}

int add1(int x) { return x + 1; }

float add_float(float x) { return x + 41.32; }

double add_double(double x) { return x + 41.32; }


// increases internal counter by "inc".
// returns the new internal counter as return value
// returns the old internal counter (before increment) via 'old' (if not null)
int swapparoo(int inc, int * old, int * n){
    static int my_counter = 0;
    static int my_stats = 0;

    //std::printf("old: %d\n", *old);

    my_stats += 1;

    *n = my_stats;
    
    if(old){
        *old = my_counter;
    }

    my_counter += inc;

    return my_counter;
}

}
