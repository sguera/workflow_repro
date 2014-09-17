#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
//#define WRITE_OUTPUT

#define x_max 204
#define y_max 204
#define z_max 204

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
			fprintf (file, "%f ", u[2][k][j][i]);
		fprintf (file, "\n");
	}

	fclose (file);
}


int main (int argc, char** argv)
{
	int t, i, j, k;

	const int T_MAX = 100;

	const float MIN = -1.f;
	const float MAX = 1.f;
	const float DX = (MAX - MIN) / (x_max - 3);
	const float DT = DX / 2.0f;

	const float DT_DX_SQUARE = DT * DT / (DX * DX);

 
    /* initialize the first timesteps */
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
	
#ifdef WRITE_OUTPUT
    write (0);
#endif	

    /* do the calculation */ 
    
    const float c0 = 2.0f - 7.5f * DT_DX_SQUARE;
    const float c1 = 4.0f/3.0f * DT_DX_SQUARE;
    const float c2 = -1.0f/12.0f * DT_DX_SQUARE;
    
	double fTimeStart = seconds();

	int t0 = 0;
	int t1 = 1;
	int t2 = 2;

	//with 3 loops unrolled and shifted	
    for (t = 0; t < T_MAX; t++)
    {
#pragma omp parallel for private(i, j, k)
    	for (k = 2; k < z_max - 2; k++)
    	{
		    for (j = 2; j < y_max - 2; j++)
		    {
		    	for (i = 2; i < x_max - 2; i++)
		    	{
    				u[t2][k][j][i] = c0 * u[t1][k][j][i] - u[t0][k][j][i] +
    					c1 * (u[t1][k][j][i+1] + u[t1][k][j][i-1] + u[t1][k][j-1][i] + u[t1][k][j+1][i] + u[t1][k-1][j][i] + u[t1][k+1][j][i]) +
    					c2 * (u[t1][k][j][i+2] + u[t1][k][j][i-2] + u[t1][k][j-2][i] + u[t1][k][j+2][i] + u[t1][k-2][j][i] + u[t1][k+2][j][i]);
		    	}
		    }
		}
		
		t0++;
		t1++;
		t2++;
		if (t0 >= 3)
			t0 -= 3;
		if (t1 >= 3)
			t1 -= 3;
		if (t2 >= 3)
			t2 -= 3;
    }

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
