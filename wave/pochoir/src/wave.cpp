#include <cstdio>
#include <cstddef>
#include <iostream>
#include <cstdlib>
#include <sys/time.h>
#include <cmath>

#include <pochoir.hpp>


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
void write (Pochoir_Array<float, 3> &u, int timestep, int x_max, int y_max, int z_max)
{
	char szFilename[255];
	sprintf (szFilename, "%04d.txt", timestep);
	printf ("Writing file %s...\n", szFilename);
	FILE* file = fopen (szFilename, "w");

	const int k = z_max / 3;
	for (int j = 0; j < y_max; j++)
	{
		for (int i = 0; i < x_max; i++)
			fprintf (file, "%f ", u.interior (0, i, j, k));
		fprintf (file, "\n");
	}

	fclose (file);
}


Pochoir_Boundary_3D(wave_bv, u, t, i, j, k)
    return 0;
Pochoir_Boundary_End



int main(int argc, char * argv[])
{
	if (argc != 4)
	{
		printf ("Wrong number of parameters. Syntax:\n%s <x_max> <y_max> <z_max>\n", argv[0]);
		exit (-1);
	}
	
	int x_max = atoi (argv[1]) + 4;
	int y_max = atoi (argv[2]) + 4;
	int z_max = atoi (argv[3]) + 4;

	const int T_MAX = 100;

	const float MIN = -1.f;
	const float MAX = 1.f;
	const float DX = (MAX - MIN) / (x_max - 3);
	const float DT = DX / 2.0f;

	const float DT_DX_SQUARE = DT * DT / (DX * DX);
    
	// declare the shape of the stencil
    Pochoir_Shape_3D wave_shape[] = {
    	// center point at t=0
    	{0, 0, 0, 0},
    	// points at t=-1
    	{-1, 0, 0, 0},
    	{-1, -1, 0, 0}, {-1, 1, 0, 0}, {-1, 0, -1, 0}, {-1, 0, 1, 0}, {-1, 0, 0, -1}, {-1, 0, 0, 1},
    	{-1, -2, 0, 0}, {-1, 2, 0, 0}, {-1, 0, -2, 0}, {-1, 0, 2, 0}, {-1, 0, 0, -2}, {-1, 0, 0, 2},
    	// point at t=-2
    	{-2, 0, 0, 0}
    };
    
    // create the Pochoir object
    Pochoir_3D wave (wave_shape);
    
    // declare and register the stencil arrays
	Pochoir_Array_3D(float) u(x_max, y_max, z_max);	
	wave.Register_Array(u);	// NO SPACE BETWEEN FUNCTION NAME AND (!
	
	// declare and register the domain
	Pochoir_Domain I(2, x_max-2), J(2, y_max-2), K(2, z_max-2);
	wave.Register_Domain (I, J, K);
	
	// register the boundary treatment
	//u.Register_Boundary (wave_bv);
    
    // define the actual stencil computation
    const float c0 = 2.0f - 7.5f * DT_DX_SQUARE;
    const float c1 = 4.0f/3.0f * DT_DX_SQUARE;
    const float c2 = -1.0f/12.0f * DT_DX_SQUARE;
    
    Pochoir_Kernel_3D(wave_fn, t, i, j, k)
		u(t, i, j, k) = c0 * u(t-1, i, j, k) - u(t-2, i, j, k) +
			c1 * (u(t-1, i-1, j, k) + u(t-1, i+1, j, k) + u(t-1, i, j-1, k) + u(t-1, i, j+1, k) + u(t-1, i, j, k-1) + u(t-1, i, j, k+1)) +
			c2 * (u(t-1, i-2, j, k) + u(t-1, i+2, j, k) + u(t-1, i, j-2, k) + u(t-1, i, j+2, k) + u(t-1, i, j, k-2) + u(t-1, i, j, k+2));
    Pochoir_Kernel_End

	// initialize
    for (int k = 0; k < z_max; k++)
    {
		for (int j = 0; j < y_max; j++)
		{
			for (int i = 0; i < x_max; i++)
			{
				float v = 0.0f;
				
				if ((2 <= i && i < x_max - 2) || (2 <= j && j < y_max - 2) || (2 <= k && k < z_max - 2))
				{
					float x = (i - 1) * DX + MIN;
					float y = (j - 1) * DX + MIN;
					float z = (k - 1) * DX + MIN;

					v = sinf (2 * M_PI * x) * sinf (2 * M_PI * y) * sinf (2 * M_PI * z);
				}
				
	        	u(0, i, j, k) = v;
	         	u(1, i, j, k) = v;
			}
		}
	}
    write (u, 0, x_max, y_max, z_max);
	
	// run the computation
	double t1 = seconds ();
    wave.Run(T_MAX, wave_fn);	// NO SPACE BETWEEN FUNCTION NAME AND (!
    double t2 = seconds ();
    
    // write the result
    write (u, 1, x_max, y_max, z_max);
    
    // print statistics
    double fNumFlops = (double) (x_max-4) * (double) (y_max-4) * (double) (z_max-4) * T_MAX * 16.0;
    printf ("FLOPs in stencil code:      %e\n", fNumFlops);    
	printf ("Time spent in stencil code: %f\n", t2 - t1);
	printf ("Performance in GFlop/s:     %f\n", fNumFlops / (1e9 * (t2 -t1)));

	return 0;
}
