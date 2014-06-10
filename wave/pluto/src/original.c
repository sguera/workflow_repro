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

#pragma scop
    for (t = 0; t < T_MAX; t++)
    {
        for (i = 2; i < z_max - 2; i++)
        {
            for (j = 2; j < y_max - 2; j++)
            {
                for (k = 2; k < x_max - 2; k++)
                {
                    u[(t+2)%3][i][j][k] = c0 * u[(t+1)%3][i][j][k] - u[(t)%3][i][j][k] +
                    	c1 * (u[(t+1)%3][i+1][j][k] + u[(t+1)%3][i-1][j][k] + u[(t+1)%3][i][j+1][k] + u[(t+1)%3][i][j-1][k] + u[(t+1)%3][i][j][k-1] + u[(t+1)%3][i][j][k+1]) +
                    	c2 * (u[(t+1)%3][i+2][j][k] + u[(t+1)%3][i-2][j][k] + u[(t+1)%3][i][j+2][k] + u[(t+1)%3][i][j-2][k] + u[(t+1)%3][i][j][k-2] + u[(t+1)%3][i][j][k+2]);
                }
            }
        }
    }
#pragma endscop

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
