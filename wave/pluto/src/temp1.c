#include <omp.h>
#include <math.h>
#define ceild(n,d)  ceil(((double)(n))/((double)(d)))
#define floord(n,d) floor(((double)(n))/((double)(d)))
#define max(x,y)    ((x) > (y)? (x) : (y))
#define min(x,y)    ((x) < (y)? (x) : (y))

/*
 * Discretized 3D heat equation stencil with non periodic boundary conditions
 * Adapted from Pochoir test bench
 *
 * Irshad Pananilath: irshad@csa.iisc.ernet.in
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <math.h>

#define x_max 204L
#define y_max 204L
#define z_max 204L

#define WRITE_OUTPUT

/* Define our arrays */
float u[3][z_max][y_max][x_max];

/**
 * Get current time in seconds.
 */
double seconds ()
{
    struct timeval tv;
    gettimeofday (&tv, NULL);
    return ((double) tv.tv_sec) + 1e-6 * tv.tv_usec;
}

/**
 * Write a cross section of the solution in u to a file.
 */
void write (int timestep)
{
	int i, j;
	char szFilename[255];
	sprintf (szFilename, "%04d.txt", timestep);
	printf ("Writing file %s...\n", szFilename);
	FILE* file = fopen (szFilename, "w");

	const int k = z_max / 3;
	for (j = 0; j < y_max; j++)
	{
		for (i = 0; i < x_max; i++)
			fprintf (file, "%f ", u[2][i][j][k]);
		fprintf (file, "\n");
	}

	fclose (file);
}

int main(int argc, char * argv[])
{
    int t, i, j, k;

    /* Initialization */
	const float MIN = -1.f;
	const float MAX = 1.f;
	const float DX = (MAX - MIN) / (x_max - 3);
	const float DT = DX / 2.0f;
	const float DT_DX_SQUARE = DT * DT / (DX * DX);
	const int T_MAX = 100;

	memset (u, 0, 3 * x_max * y_max * z_max * sizeof (float));
    for (k = 2; k < z_max - 2; k++)
    {
		for (j = 2; j < y_max - 2; j++)
		{
			for (i = 2; i < x_max - 2; i++)
			{
				float x = (i - 1) * DX + MIN;
				float y = (j - 1) * DX + MIN;
				float z = (k - 1) * DX + MIN;
				
	        	u[0][k][j][i] = u[1][k][j][i] = u[2][k][j][i] = sinf (2 * M_PI * x) * sinf (2 * M_PI * y) * sinf (2 * M_PI * z);
			}
		}
	}

    const float c0 = 2.0f - DT_DX_SQUARE * 7.5f;
    const float c1 = DT_DX_SQUARE * 4.0f / 3.0f;
    const float c2 = DT_DX_SQUARE * (-1.0f / 12.0f);

	double fTimeStart = seconds();




  int t1, t2, t3, t4, t5, t6, t7, t8;

 int lb, ub, lbp, ubp, lb2, ub2;
 register int lbv, ubv;

/* Start of CLooG code */
if ((T_MAX >= 1) && (x_max >= 5) && (y_max >= 5) && (z_max >= 5)) {
  for (t1=0;t1<=floord(3*T_MAX+z_max-6,16);t1++) {
    lbp=max(ceild(2*t1,3),ceild(16*t1-T_MAX+1,16));
    ubp=min(min(floord(2*T_MAX+z_max-5,16),floord(32*t1+z_max+27,48)),t1);
#pragma omp parallel for private(lbv,ubv)
    for (t2=lbp;t2<=ubp;t2++) {
      for (t3=max(ceild(16*t2-z_max-9,16),2*t1-2*t2);t3<=min(min(floord(2*T_MAX+y_max-5,16),floord(16*t2+y_max+9,16)),floord(32*t1-32*t2+y_max+27,16));t3++) {
        for (t4=max(max(ceild(4*t1-4*t2-124,125),ceild(16*t2-z_max-993,1000)),ceild(16*t3-y_max-993,1000));t4<=min(min(min(floord(2*T_MAX+x_max-5,1000),floord(16*t2+x_max+9,1000)),floord(16*t3+x_max+9,1000)),floord(32*t1-32*t2+x_max+27,1000));t4++) {
          for (t5=max(max(max(ceild(16*t2-z_max+3,2),ceild(16*t3-y_max+3,2)),ceild(1000*t4-x_max+3,2)),16*t1-16*t2);t5<=min(min(min(min(T_MAX-1,8*t2+6),8*t3+6),500*t4+498),16*t1-16*t2+15);t5++) {
            for (t6=max(16*t2,2*t5+2);t6<=min(16*t2+15,2*t5+z_max-3);t6++) {
              for (t7=max(16*t3,2*t5+2);t7<=min(16*t3+15,2*t5+y_max-3);t7++) {
                lbv=max(1000*t4,2*t5+2);
                ubv=min(1000*t4+999,2*t5+x_max-3);
#pragma ivdep
#pragma vector always
                for (t8=lbv;t8<=ubv;t8++) {
                  u[t5+2][-2*t5+t6][-2*t5+t7][-2*t5+t8]=c0*u[t5+1][-2*t5+t6][-2*t5+t7][-2*t5+t8]-u[t5][-2*t5+t6][-2*t5+t7][-2*t5+t8]+c1*(u[t5+1][-2*t5+t6+1][-2*t5+t7][-2*t5+t8]+u[t5+1][-2*t5+t6-1][-2*t5+t7][-2*t5+t8]+u[t5+1][-2*t5+t6][-2*t5+t7+1][-2*t5+t8]+u[t5+1][-2*t5+t6][-2*t5+t7-1][-2*t5+t8]+u[t5+1][-2*t5+t6][-2*t5+t7][-2*t5+t8-1]+u[t5+1][-2*t5+t6][-2*t5+t7][-2*t5+t8+1])+c2*(u[t5+1][-2*t5+t6+2][-2*t5+t7][-2*t5+t8]+u[t5+1][-2*t5+t6-2][-2*t5+t7][-2*t5+t8]+u[t5+1][-2*t5+t6][-2*t5+t7+2][-2*t5+t8]+u[t5+1][-2*t5+t6][-2*t5+t7-2][-2*t5+t8]+u[t5+1][-2*t5+t6][-2*t5+t7][-2*t5+t8-2]+u[t5+1][-2*t5+t6][-2*t5+t7][-2*t5+t8+2]);;
                }
              }
            }
          }
        }
      }
    }
  }
}
/* End of CLooG code */

	double fTimeEnd = seconds ();

#ifdef WRITE_OUTPUT
	/* Note: this can't be in the "scop" (Pluto can't handle function calls within scops) */
	write (T_MAX + 1);
#endif

    /* print statistics */    
    double fNumFlops = (double) (x_max-4) * (double) (y_max-4) * (double) (z_max-4) * T_MAX * 16.0;
    printf ("FLOPs in stencil code:      %e\n", fNumFlops);    
	printf ("Time spent in stencil code: %f\n", fTimeEnd - fTimeStart);
	printf ("Performance in GFlop/s:     %f\n", fNumFlops / (1e9 * (fTimeEnd - fTimeStart)));

    return 0;
}

// icc -O3 -fp-model precise heat_1d_np.c -o op-heat-1d-np -lm
// /* @ begin PrimeTile (num_tiling_levels=1; first_depth=1; last_depth=-1; boundary_tiling_level=-1;) @*/
// /* @ begin PrimeRegTile (scalar_replacement=0; T1t5=4; T1t6=4; T1t7=4; T1t8=4; ) @*/
// /* @ end @*/
