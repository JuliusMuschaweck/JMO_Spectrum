// for Matlab

int LinInterpol(  // return 0 if ok, else return error code > 0
	double* yq,	// output: nq interpolated values
	double* xx, // input: x array, strictly ascending
	double* yy, // input: y array
	double* xq, // input: x query array, strictly ascending
	int nx,		// input: number of xx / yy values
	int nq		// input: number of xq values
	);

int LinInterpolAdd4Async(
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
	);
