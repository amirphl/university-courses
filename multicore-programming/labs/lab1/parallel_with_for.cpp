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
    double sumx, sumy, total, global_total;

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
        sum = 0;
        total = 0.0;
        global_total = 0.0;
        // Work Loop, do some work by looping VERYBIG times
        int sumid = 0, sumxid = 0, sumyid = 0;

        omp_set_num_threads(NUM_THREADS);
#pragma omp parallel firstprivate(j, k, total, sumid, sumxid, sumyid)
        {
#pragma omp for schedule(dynamic) nowait
            for (j = 0; j < VERYBIG; j++) {
                // increment check sum
                sumid += 1;
                // Calculate first arithmetic series
                sumxid = 0.0;
                for (k = 0; k < j; k++)
                    sumxid = sumxid + (double) k;
                // Calculate second arithmetic series
                sumyid = 0.0;
                for (k = j; k > 0; k--)
                    sumyid = sumyid + (double) k;
                if (sumxid > 0.0)total = total + 1.0 / sqrt(sumxid);
                if (sumyid > 0.0)total = total + 1.0 / sqrt(sumyid);
            }
//            printf("%d %d\n", omp_get_thread_num(), sumid);

#pragma omp atomic
            sum += sumid;
            global_total += total;
        }
        // get ending time and use it to determine elapsed time
        gettimeofday(&temp, nullptr);
        tim = temp.tv_sec - start.tv_sec;
        utim = temp.tv_usec - start.tv_usec;
        elapsed = static_cast<long>(((tim) * 1000 + utim / 1000.0) + 0.5);
        // report elapsed time
        printf("Time Elapsed % 10d mSecs Total = %lf Check Sum = %ld\n",
               static_cast<int>(elapsed), global_total, sum);
    }
    // return integer as required by function header
    printf("END.");
    getchar();
    return 0;
}
// **********************************************************************