
# WindSim

This is the branch made for benchmarking the Oceananigans library on CPUs.

Informations on the CPU used for the benchmarking:

```
$ lscpu

Architecture:             x86_64
  CPU op-mode(s):         32-bit, 64-bit
  Address sizes:          46 bits physical, 57 bits virtual
  Byte Order:             Little Endian
CPU(s):                   96
  On-line CPU(s) list:    0-95
Vendor ID:                GenuineIntel
  Model name:             Intel(R) Xeon(R) Gold 5318Y CPU @ 2.10GHz
    CPU family:           6
    Model:                106
    Thread(s) per core:   2
    Core(s) per socket:   24
    Socket(s):            2
    Stepping:             6
    CPU(s) scaling MHz:   64%
    CPU max MHz:          3400.0000
    CPU min MHz:          800.0000
    BogoMIPS:             4200.00
```

Run the project with:

```sh
julia --project=. src/OceWind.jl
```


For more infos, go see `README.md` on branch `main`.
