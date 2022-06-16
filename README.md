# Aligned integers

Tiny experiment to check the effect of cache-line sharing for concurrent
libraries. Note: Only works on MacOS right now. Working on making this portable.

The library has one useful function -

```
val aligned_int : int -> int Atomic.t
```

This creates an atomic integer which is aligned to a cache line boundary and
padded such that it does not share the cache line with any other element.

The benchmark has an SPSC queue taken from - https://github.com/bartoszmodelski/ebsl

The benchmark consists of spawning 2 domains where one domain pushes N elements
to the queue and another pops N elements.

```
dune build
/usr/bin/time -v _build/default/bench/main.exe 0
/usr/bin/time -v _build/default/bench/main.exe 1
```

which runs cases where unaligned and aligned integers are used respectively.


On my machine the results are - 

```
* 7.28s (unaligned)
* 5.62  (aligned)
```

There is a reduction of 22.80% in the wall-clock time for the aligned case over
the unaligned case.

`htop` was manually inspected to observe about 192% utilization for the bench
process. User time reported by `time` is rougly 2x of wall-clock time, thus
double checking that 2 domains were concurrently resident throughout the process.

