DAEPreprocessingToolbox
====

MATLAB toolbox for structural preprocessing of differential-algebraic equations (DAEs).

### Description
In solving high-index DAEs using [`ode15i`](https://www.mathworks.com/help/matlab/ref/ode15i.html), index reduction is important preprocessing prior to numerical integration.
The Mattsson–Söderlind index reduction method (MS-method), which is implemented as [`reduceDAEIndex`](https://www.mathworks.com/help/symbolic/reducedaeindex.html) in MATLAB, is effective and commonly used; however, it is known to fail for some DAEs.
This toolbox provides a preprocessing function that modifies a given DAE system to an equivalent system that can be handled by the MS-method.

### Requirement
* MATLAB R2019a (this toolbox might work on older MATLAB versions, but not confirmed)
* [Symbolic Math Toolbox](https://www.mathworks.com/products/symbolic.html)&trade;

### Usage
See [doc/demo.md](doc/demo.md) and [doc/document.md](doc/document.md).

### Install
Download and add `src` directory to the search path in MATLAB as follows:

* Windows:
```matlab
addpath('c:\path\to\DAEPreprocessingToolbox\src') 
```

* Mac, Linux:
```matlab
addpath('/path/to/DAEPreprocessingToolbox/src') 
```
See [MATLAB `addpath` help page](https://www.mathworks.com/help/matlab/ref/addpath.html) and [MATLAB help page for adding a search path at startup](https://www.mathworks.com/help/matlab/matlab_env/add-folders-to-matlab-search-path-at-startup.html).

### Licence
[MIT](LICENSE)

### Author
[Taihei Oki](https://www.opt.mist.i.u-tokyo.ac.jp/~oki/en/) (University of Tokyo)

### Reference
https://dl.acm.org/citation.cfm?id=3326236

Cite as:
> T. Oki. Improved structural methods for nonlinear differential-algebraic equations via combinatorial relaxation. In Proceedings of the 44th International Symposium on Symbolic and Algebraic Computation (ISSAC ’19), pp. 315−322, 2019.

### Acknowledgment

This project is supported by [JST CREST “Developing Optimal Modeling Methods for Large-Scale Complex Systems” Team](https://www.opt.mist.i.u-tokyo.ac.jp/crest-model/).
