# mgr

## Quick introduction to code

- [`download_libs.py`](download_libs.py) may be used to download prerequisities. [`download_circuits.py`](download_circuits.py) may be used to download test circuits. 
- [`run_reduction.m`](run_reduction.m) contains sample usage.
- [`reducer.m`](reducer.m) defines reduction framework. It separates G to atomic parts and performs reduction on each part (each connected component).
- `graph_reduce_*.m` files defines graph algorithms reduction. Interface is defined in `graph_reduce_abstract.m`.
- `nodewise_*.m` files defines nodewise reduction algorithms. Interface is defined in `nodewise_abstract.m`.

## About MATLAB version

MATLAB 2015b+ is recommended to take advantage of [JIT-Compiler implemented in MATLAB Engine](http://www.mathworks.com/products/matlab/matlab-execution-engine/).
