// LinInterpol.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
// #include "LinInterpol.h"

#include<algorithm>
#include<vector>
#include<future>


#ifdef LININTERPOL_EXPORTS
#define LININTERPOL_API __declspec(dllexport)
#else
#define LININTERPOL_API __declspec(dllimport)
#endif


extern "C"
{
	LININTERPOL_API int LinInterpol(  // return 0 if ok, else return error code > 0
		double* yq,	// output: nq interpolated values
		double* xx, // input: x array, strictly ascending
		double* yy, // input: y array
		double* xq, // input: x query array, strictly ascending
		int nx,		// input: number of xx / yy values
		int nq		// input: number of xq values
		)
	{
#ifndef NDEBUG
		try {
#endif
			// check overlap
			double xxmin = *xx;
			double xxmax = *(xx + (nx - 1));
			double xqmin = *xq;
			double xqmax = *(xq + (nq - 1));
			if (xxmin > xqmax || xxmax < xqmin)
			{
				std::fill_n(yq, nq, 0.0);
				return 0;
			}
			// there is overlap
			// prepare xx yy bookkeeping
			int curixx = 0;
			double* curxx0 = xx;
			double* curxx1 = xx + 1;
			double* curyy0 = yy;
			double* curyy1 = yy + 1;
			bool done_x = false;
			auto advance_x = [&curixx, &curxx0, &curxx1, &curyy0, &curyy1, nx, &done_x]()
			{
				++curixx; ++curxx0; ++curxx1; ++curyy0; ++curyy1;
				if ((curixx + 1) == nx)
					done_x = true;
			};
			// prepare xq yq bookkeeping
			int curiq = 0;
			double* curxq = xq;
			double* curyq = yq;
			bool done_q = false;
			auto advance_q = [&curiq, &curxq, &curyq, nq, &done_q]()
			{
				++curiq; ++curxq; ++curyq;
				if (curiq == nq)
					done_q = true;
			};
			// fill yq with zero until overlap
			while (*curxq < xxmin) // cannot break: there is overlap!
			{
				*curyq = 0.0;
				advance_q();
			}
			//now: xxmin <= *curxq <= xxmax
			while (!done_q)
			{
				// compute this q value
				// 1. match interval: advance xx interval until *curxx0 <= *curxq <= *curxx1
				while ((!done_x) && (*curxx1 < *curxq))
				{
					advance_x();
				}
				if (done_x)
					break;
				// 2. compute interpolated value
				double u = (*curxq - *curxx0) / (*curxx1 - *curxx0);
				if ((u < 0.0) || (u > 1.0))
					return 100;
				*curyq = (1 - u) * (*curyy0) + u * (*curyy1);
				// 3. advance to next q
				advance_q();
			}
			if (!done_q)
			{
				if ((curyq - yq) >= nq)
					return 101;
				std::fill(curyq, yq + nq, 0.0);
			}
			return 0;
#ifndef NDEBUG
		} // try
		catch (...)
		{
			return 201;
		};
#endif
		}
} // extern C

	using Vec = std::vector<double>;
	Vec LinIntVec(
		double* xx, // input: x array, strictly ascending
		double* yy, // input: y array
		double* xq, // input: x query array, strictly ascending
		int nx,		// input: number of xx / yy values
		int nq		// input: number of xq values
		)
	{
		Vec rv(nq);
		LinInterpol(rv.data(), xx, yy, xq, nx, nq);
		return rv;
	}

extern "C"
{
	LININTERPOL_API int LinInterpolAdd4Async(
		double* yq,
		double* xq, // input: x query array, strictly ascending
		int nq,		// input: number of xq values
		double* xx0, // input: x array, strictly ascending
		double* yy0, // input: y array
		int nx0,		// input: number of xx / yy values
		double* xx1, // input: x array, strictly ascending
		double* yy1, // input: y array
		int nx1,		// input: number of xx / yy values
		double* xx2, // input: x array, strictly ascending
		double* yy2, // input: y array
		int nx2,		// input: number of xx / yy values
		double* xx3, // input: x array, strictly ascending
		double* yy3, // input: y array
		int nx3		// input: number of xx / yy values
		)
	{
		std::future<Vec> f0 = std::async(LinIntVec, xx0, yy0, xq, nx0, nq);
		std::future<Vec> f1 = std::async(LinIntVec, xx1, yy1, xq, nx1, nq);
		std::future<Vec> f2 = std::async(LinIntVec, xx2, yy2, xq, nx2, nq);
		std::future<Vec> f3 = std::async(LinIntVec, xx3, yy3, xq, nx3, nq);
		Vec yq0{ f0.get() };
		Vec yq1{ f1.get() };
		Vec yq2{ f2.get() };
		Vec yq3{ f3.get() };
		auto iy0 = yq0.cbegin();
		auto iy1 = yq1.cbegin();
		auto iy2 = yq2.cbegin();
		auto iy3 = yq3.cbegin();
		for (int i = 0; i < nq; ++i)
		{
			*yq = *iy0 + *iy1 + *iy2 + *iy3;
			++yq; ++iy0; ++iy1; ++iy2; ++iy3;
		}
		return 0;
	}


} // extern C

