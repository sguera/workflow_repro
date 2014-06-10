#include <iostream>
#include <fstream>

#include "Halide.h"
#include "PerfStats.h"


using Halide::Image;

#define NX 200L
#define NY 200L
#define NZ 200L

#define T_MAX 100L

//#define WRITE

#define SCHEDULE 13


using namespace Halide;


template<typename T> void write (Image<T> img, int t)
{
	std::cout << "Writing t=" << t << "\n";

	char szFilename[200];
	sprintf (szFilename, "%04d.txt", t);
	std::ofstream out (szFilename, std::ios::out);
	
	const int k = img.size (2) / 3;
	for (int j = 0; j < img.size (1); j++)
	{
		for (int i = 0; i < img.size (0); i++)
			out << img(i, j, k) << " ";
		out << "\n";
	}

    out.close ();
}


int main (int argc, char **argv)
{
	const float MIN = -1.f;
	const float MAX = 1.f;
	const float DX = (MAX - MIN) / (NX - 3);
	const float DT = DX / 2.0f;

	const float DT_DX_SQUARE = DT * DT / (DX * DX);
	
	const float c0 = 2.0f - 7.5f * DT_DX_SQUARE;
	const float c1 = 4.0f / 3.0f * DT_DX_SQUARE;
	const float c2 = -1.0f / 12.0f * DT_DX_SQUARE;


	Image<float> u0 (NX,NY,NZ,"u0");
	Image<float> um1 (NX,NY,NZ,"um1");

    Func clU0, wave;
//    Func v;
    Var x ("x"), y ("y"), z ("z");
    Var xi ("xi"), yi ("yi"), zi ("zi"),xo ("xo") ,yo ("yo"),zo ("zo"),tile_index;
    
    // define the algorithm
    //*
    clU0(x, y, z) = u0(clamp (x, 0, u0.width() - 1), clamp (y, 0, u0.height() - 1), clamp (z, 0, u0.channels() - 1));
    wave(x, y, z) = select (x < 2 || y < 2 || z < 2 || x >= u0.width() - 2 || y >= u0.height() - 2 || z >= u0.channels() - 2,
		0,
		c0 * u0(y, x, z) - um1(x, y, z) +
			c1 * (clU0(x+1, y, z) + clU0(x-1, y, z) + clU0(x, y+1, z) + clU0(x, y-1, z) + clU0(x, y, z+1) + clU0(x, y, z-1)) +
			c2 * (clU0(x+2, y, z) + clU0(x-2, y, z) + clU0(x, y+2, z) + clU0(x, y-2, z) + clU0(x, y, z+2) + clU0(x, y, z-2))
	);
	//*/
	/*
	v(x, y, z) = select (x < 2 || y < 2 || z < 2 || x >= u0.size (0) - 2 || y >= u0.size (1) - 2 || z >= u0.size (2) - 2, 0, u0(clamp (x, 0, u0.size (0) - 1), clamp (y, 0, u0.size (1) - 1), clamp (z, 0, u0.size (2) - 1)));
	wave(x, y, z) = c0 * u0(y, x, z) - um1(x, y, z) +
		c1 * (v(x+1, y, z) + v(x-1, y, z) + v(x, y+1, z) + v(x, y-1, z) + v(x, y, z+1) + v(x, y, z-1)) +
		c2 * (v(x+2, y, z) + v(x-2, y, z) + v(x, y+2, z) + v(x, y-2, z) + v(x, y, z+2) + v(x, y, z-2));
	*/
    
    // define the schedule
//    clU0.split (z, z, zi, 4).parallel (z).vectorize (x, 4);
//	wave.split (z, z, zi, 1).parallel (z).vectorize (x, 4);
//	wave.parallel (z).vectorize (x, 4);
//	wave.parallel (z).split (y, y, yi, 2).vectorize (x, 4);
#if (SCHEDULE == 0)
	wave.root ();
	// 1.18 GFlop/s
#elif (SCHEDULE == 1)
	wave.root ().split(z, z, zi, 4).parallel (z);
	// 5.52 GFlop/s
#elif (SCHEDULE == 2)
	wave.root ().split(z, z, zi, 4).parallel (z).vectorize (x, 4);
	// 8.85 GFlop/s
#elif (SCHEDULE == 3)
	wave.root ().split(z, z, zi, 4).parallel (zi);
	// 2.81 GFlop/s
#elif (SCHEDULE == 4)
	wave.parallel (z).split (y, y, yi, 2).vectorize (x, 4);
	// 10.12 GFlop/s
#elif (SCHEDULE == 5)
	wave.root ().parallel (z).split (y, y, yi, 2).vectorize (x, 4);
	// 10.11 GFlop/s
#elif (SCHEDULE == 6)
	wave.parallel (z).split (y, yo, yi, 2).unroll (x, 2).vectorize (x, 4);
	// 10.32 GFlop/s
#elif (SCHEDULE == 7)
	wave.parallel (z).split (y, y, yi, 2).unroll (y, 2).vectorize (x, 4);
	// 9.59 GFlop/s
#elif (SCHEDULE == 8)
	wave.parallel (z).split (y, y, yi, 2).unroll (y, 2).unroll (x, 2).vectorize (x, 4);
	// 9.63 GFlop/s
#elif (SCHEDULE == 9)
	wave.parallel (z).split (y, y, yi, 2).unroll (y, 2).vectorize (x, 4).unroll (x, 2);
	// 10.06 GFlop/s
#elif (SCHEDULE == 10)
	wave.parallel (z).split (z, z, zi, 2).split (y, y, yi, 8).vectorize (x, 4).unroll (x, 2);
	// 10.26 GFlop/s
#elif (SCHEDULE == 11)
	wave.parallel (z).split (y, y, yi, 8).unroll (x, 2).vectorize (x, 4);
	// 10.33 GFlop/s
#elif (SCHEDULE == 12)
	wave.parallel (z).split (y, y, yi, 2).unroll (y, 2).vectorize (x, 4);
	// 9.59 GFlop/s
#elif (SCHEDULE == 13)
	wave.tile(y,z,yo,zo,yi,zi,2,2);
	wave.fuse(yo,zo,tile_index);
	wave.parallel(tile_index);
#endif
	
	
	// initialize the input
	Image<float> _u0 (NX, NY, NZ);
	Image<float> _u1 (NX, NY, NZ);
	Image<float> _um1 (NX, NY, NZ);
	for (int k = 2; k < _u0.channels() - 2; k++)
	  for (int j = 2; j < _u0.height() - 2; j++)
	    for (int i = 2;  i < _u0.width() - 2; i++)
			{
				float x = (i - 1) * DX + MIN;
				float y = (j - 1) * DX + MIN;
				float z = (k - 1) * DX + MIN;

				_u1(i, j, k) = _u0(i, j, k) = sinf (2 * M_PI * x) * sinf (2 * M_PI * y) * sinf (2 * M_PI * z);
			}

    // JIT-compile and run the halide pipeline
	//wave.compileJIT ();
	
	PerfStats ps (16L * NX * NY * NZ * T_MAX);
	ps.tic ();
	for (int t = 0; t < T_MAX; t++)
	{
		um1 = _u0;
		u0 = _u1;
		_u0 = _u1;
		_u1 = wave.realize (_u0.width(), _u0.height(), _u0.channels());
		
#ifdef WRITE
		write (_u1, t);
#endif
	}	
	ps.toc ();

	// performance statistics    
    ps.print (std::cout);

    return 0;
}
