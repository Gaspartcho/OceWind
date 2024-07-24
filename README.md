
# WindSim

This Repository contains the code used during my internship at the IGE institute, during which my main task was to benchmark the [Oceananigans](https://github.com/CliMA/Oceananigans.jl) library on different computer architectures.


## Organization of the repository

This repository contains four branches:

-	main: Original source code - made for parallel 
-	large_cpu: Adapted for CPU benchmarking
-	large_gpu: Adapted for GPU benchmarking
-	long-gpu: Adapted for larger simulation on GPU


Each branch contains the following structure

```
.
├── Notebooks: A collection of jupyter notebooks I used for development
│              (graphs.ipynb usually contains the same figures present in
│              results/visuals)
│
├── results
│   ├── data
│   │   ├── A collection of files (in NetCDF format) containing the data obtained
│   │   │   from the code. Used to plot the figures.
│   │   └── time.txt: File containing the data obtained from timing the simulation.
│   │
│   ├── visuals: Collection 
```

## Instructions to run the code

The following need to be installed on your computer first:

-	Julia (preferably the latest stable version) [https://julialang.org/downloads/]
-	Git [https://git-scm.com/downloads]


Then, run the following commands: 

```sh
git clone https://github.com/Gaspartcho/OceWind.git
cd OceWind
julia --project=. -e "using Pkg; Pkg.instantiate()"
```

Once the project has finished pre-compiling, you can run it with the following command:

```sh
julia --project=. src/OceWind.jl
```

Warning: the Oceananigans
