// Example Program
// Optimizes code for maximum speed
#pragma optimize( "2", on )

#include <cstdio>
#include <cmath>
#include <omp.h>
#include <sys/time.h>

#define NUM_THREADS 6
#pragma comment(lib, "winmm.lib")
const long int VERYBIG = 100000;

// ***********************************************************************
int main() {
    int i;
    long int j, k, sum;
    double total, global_sum = 0.0, global_total = 0.0;

    struct timeval start{}, temp{};
    long tim, utim, elapsed;
    // -----------------------------------------------------------------------
    // Output a start message
    printf("None Parallel Timings for %d iterations\n\n", (int) VERYBIG);
    // repeat experiment several times
    for (i = 0; i < 6; i++) {
        // get starting time56 x CHAPTER 3 PARALLEL STUDIO XE FOR THE IMPATIENT
        gettimeofday(&start, nullptr);
        // reset check sum & running total
        global_sum = 0;
        global_total = 0.0;
        // Work Loop, do some work by looping VERYBIG times
        omp_set_num_threads(NUM_THREADS);
#pragma omp parallel firstprivate(sum, total, k, j)
        {
            sum = 0;
            total = 0;
            double sumx, sumy;
            int id = omp_get_thread_num();
            for (j = id * VERYBIG / (2 * NUM_THREADS); j < (id + 1) * VERYBIG / (2 * NUM_THREADS); j++) {
                // increment check sum
                sum += 1;
                // Calculate first arithmetic series
                sumx = 0.0;
                for (k = 0; k < j; k++)
                    sumx = sumx + (double) k;
                // Calculate second arithmetic series
                sumy = 0.0;
                for (k = j; k > 0; k--)
                    sumy = sumy + (double) k;
                if (sumx > 0.0)total = total + 1.0 / sqrt(sumx);
                if (sumy > 0.0)total = total + 1.0 / sqrt(sumy);
            }

#pragma omp atomic
            global_total += total;
            global_sum += sum;

            sum = 0;
            total = 0;
            for (j = (2 * NUM_THREADS - id - 1) * VERYBIG / (2 * NUM_THREADS);
                 j < (2 * NUM_THREADS - id) * VERYBIG / (2 * NUM_THREADS); j++) {
                // increment check sum
                sum += 1;
                // Calculate first arithmetic series
                sumx = 0.0;
                for (k = 0; k < j; k++)
                    sumx = sumx + (double) k;
                // Calculate second arithmetic series
                sumy = 0.0;
                for (k = j; k > 0; k--)
                    sumy = sumy + (double) k;
                if (sumx > 0.0)total = total + 1.0 / sqrt(sumx);
                if (sumy > 0.0)total = total + 1.0 / sqrt(sumy);
            }
#pragma omp atomic
            global_sum += sum;
            global_total += total;
        }
        // get ending time and use it to determine elapsed time
        gettimeofday(&temp, nullptr);
        tim = temp.tv_sec - start.tv_sec;
        utim = temp.tv_usec - start.tv_usec;
        elapsed = static_cast<long>(((tim) * 1000 + utim / 1000.0) + 0.5);
        // report elapsed time
        printf("Time Elapsed % 10d mSecs Total = %lf Check Sum = %f\n",
               (int) elapsed, global_total, global_sum);
    }
    printf("END.");
    getchar();
    // return integer as required by function header
    return 0;
}
// **********************************************************************