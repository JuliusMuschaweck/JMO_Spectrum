/*
* Fast linear interpolation for scalar query value
*
* Usage : from MATLAB
*         >> yq = LinInterpolScalar( xx, yy, xq, check_optional)
* xx, yy must be double vectors of same length
* xx must be strictly ascending
* xq must be a scalar double
* check_optional: if present, must be scalar logical.
* 
* if xx(1) <= x <= xx(end): yq is linear interpolation
* else yq = 0
* 
* Error or precondition checking only if check_optional is present and true
*
* 2025-02-10 J. Muschaweck
*/

#include "mex.hpp"
#include "mexAdapter.hpp"
#include<string>

class MexFunction : public matlab::mex::Function 
{
public:
    void operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) 
    {
        bool docheck = checkArguments(outputs, inputs);
        matlab::data::TypedArray<double> xx = std::move(inputs[0]);
        matlab::data::TypedArray<double> yy = std::move(inputs[1]);
        matlab::data::TypedArray<double> xq = std::move(inputs[2]);
        double yq = doInterpol(xx, yy, xq[0], docheck);
        xq[0] = yq;
        outputs[0] = std::move(xq);
        // matlab::data::TypedArray<double> in = std::move(inputs[1]);
        // arrayProduct(in, multiplier);
        // outputs[0] = std::move(in);
    }

    void error(const char* msg)
    {
        std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr = getEngine();
        matlab::data::ArrayFactory factory;
        matlabPtr->feval(u"error", 0, std::vector<matlab::data::Array>({ factory.createScalar(msg) }));
    }

    double doInterpol(const matlab::data::TypedArray<double>& xx, 
                        const matlab::data::TypedArray<double>& yy,
                        double xq,
                        bool check) 
    {
        size_t unx = xx.getNumberOfElements();
		double yq = - (1.0e300 * 1.0e300) * 0.0; //nan
		double xmin = xx[0];
		double xmax = xx[unx - 1];
		if (xq < xmin || xq > xmax)
			{
			yq = 0;
			return yq;
			}
		if (xq == xmax)
			{
			yq = yy[unx-1];
			return yq;
			}
		// now xmin <= xq < xmax
		// binary search
		size_t i0 = 0;
		size_t ii = unx / 2;
		size_t i1 = unx - 1;
		while ((i1 - i0) > 1)
			{
			double xtest = xx[ii];
			if (xq < xtest) // lower half
				{
				i1 = ii;
				ii = i0 + (ii - i0) / 2;
				}
			else // upper half
				{
				i0 = ii;
				ii = ii + (i1 - ii) / 2;
				}
			}
        if (check && i0+1 != i1)
            error("this cannot happen: i0+1 != i1");
		// now i1 == i0 + 1
		double x0 = xx[i0];
		double x1 = xx[i1];
        if (check && (xq < x0 || xq >= x1))
            {
            std::string msg = "this cannot happen: xq < x0 || xq >= x1, x0 = "
                + std::to_string(x0) + ", xq = " + std::to_string(xq) + ", x1 = " + std::to_string(x1);
            error(msg.c_str());
            }
		double u = (xq - x0) / (x1 - x0);
		double y0 = yy[i0];
		double y1 = yy[i1];
		yq = (1 - u) * y0 + u * y1;
		return yq;
	}
        

    bool checkArguments(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) 
    {
        if (inputs.size() < 3) 
        {
            std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr = getEngine();
            matlab::data::ArrayFactory factory;
            matlabPtr->feval(u"error", 
                0, std::vector<matlab::data::Array>({ factory.createScalar("Three or four inputs required") }));
            return false;
        }
        if (inputs.size() > 3) 
        {
            auto& xx = inputs[0];
            auto& yy = inputs[1];
            auto& xq = inputs[2];
            auto& check = inputs[3];

            if (check.getType() != matlab::data::ArrayType::LOGICAL)
                error("input 4 (check_optional) must be scalar logical");
            if (check.getNumberOfElements() != 1)
                error("input 4 (check_optional) must be scalar logical");
            matlab::data::TypedArray<bool> icheck = std::move(check);
            if (icheck[0]) // do check
            {
                // xx must be double array with >= 2 elements
                if (xx.getType() != matlab::data::ArrayType::DOUBLE)
                    error("input 1 (xx) must be double array");
                if (xx.getNumberOfElements() < 2)
                    error("input 1 (xx) must have >= 2 elements");
                // yy must be double array with same # of elements as xx
                if (yy.getType() != matlab::data::ArrayType::DOUBLE)
                    error("input 2 (yy) must be double array");
                if (yy.getNumberOfElements() != xx.getNumberOfElements())
                    error("input 1 (xx) and 2 (yy) must have same size");
                // xq must be scalar double
                if (xq.getType() != matlab::data::ArrayType::DOUBLE)
                    error("input 3 (xq) must be double array");
                if (xq.getNumberOfElements() != 1)
                    error("input 3 (xq) must be scalar");
            }
            return icheck[0];
        } // if size > 3
        return false;
    }
};