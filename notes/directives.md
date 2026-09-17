# Directive reference

Notes on the Vitis HLS directives used in this repo, written as they come up in the exercises. Tool version: Vitis HLS 2023.2. We would find almost all directive documentation in [here](https://docs.amd.com/r/2023.2-English/ug1399-vitis-hls/HLS-Optimization-Directives).

**General rules (repo conventions):**
- Directives live in `directives_<top>_<solution>.tcl`, never as pragmas in the source, so the C code stays identical across solutions.
- Every `set_directive_*` command has an in-source `#pragma HLS ...` equivalent. The pragma goes inside the function or loop it applies to; the directive names that place instead.
- The last argument is the **location**: `"function"` or `"function/LABEL"`. Loops can only be addressed through their label, which is why every loop in the repo is labelled.
- Directives change *how* the C code is built, never *what* it computes. The one exception is a false promise made with `set_directive_dependence` (see below).
- For the full option list on this install: `vitis_hls -i`, then `help <command>`. Options marked *(check `help`)* below have not been confirmed on 2023.2.

---

## `set_directive_pipeline`

**As used in S2.1.3:**

```tcl
set_directive_pipeline -II 1 "acc_index/ACC"
```

### What it does

Turns a loop (or a whole function) into a pipeline: a new iteration starts every $I$ cycles while earlier iterations are still in progress, instead of each iteration finishing before the next starts. The loop's cycle count follows

$$C = L_p + I \cdot (N - 1)$$

where $L_p$ is the pipeline depth, $I$ the achieved II, and $N$ the trip count.

`-II` is a *target*. If a loop-carried dependency or a memory port limit makes it impossible, Vitis tries $I+1$, $I+2$, ... and prints one `II Violation` line per rejected value. The achieved II is in the loop table (`achieved` sub-column) and in the log's `Pipelining result` line.

### Arguments in our command

| part | meaning |
|---|---|
| `set_directive_pipeline` | build this loop as a pipeline |
| `-II 1` | target: start a new iteration every cycle |
| `"acc_index/ACC"` | the loop labelled `ACC` inside function `acc_index` |

### When to use it

- **The main loop of any throughput-oriented kernel.** It is the first thing to try on a loop that processes many elements, and every S1 and S2 exercise starts from it.
- **To expose a blocker.** Asking for II=1 and reading the violation lines tells you exactly what stops the loop: a dependency (S1.2 `accf`) or a port limit (S1.2 `fir3`).
- **With `-off`**, to keep one loop sequential while the tool would otherwise auto-pipeline it.
- **On a function** (not a loop), when the whole function is called repeatedly and should itself accept a new call every $I$ cycles.

### Where it applies

- **Loops and functions.** Location is `"function/LABEL"` for a loop, `"function"` for a function.
- **Loops inside a pipelined loop are unrolled automatically** (for example `SHIFT` inside `ACC` in `acc_shift`). They must have constant trip counts. Pipelining an outer loop of a large nest can therefore create a lot of hardware; the usual choice is to pipeline the innermost loop and let Vitis flatten the nest (S2.5).
- **Pipelining a function unrolls every loop inside it**, with the same constant-bound requirement.
- **`config_compile -pipeline_loops` has no effect on an explicit pipeline directive.** It only controls *automatic* pipelining. On this install, loops with trip counts of 63 and above are auto-pipelined by default (probe D in S1.1). `common/part.tcl` sets `-pipeline_loops 0` so baselines stay sequential.

### Full syntax

```tcl
set_directive_pipeline [-II <int>] [-off] [-rewind] [-style <stp|flp|frp>] <location>
```

| argument | description | possible values | default |
|---|---|---|---|
| `-II <int>` | target initiation interval: cycles between the start of one iteration (or call) and the next | positive integer | 1 |
| `-off` | disable pipelining for this location. Use it to stop Vitis auto-pipelining a specific loop | flag | not set |
| `-rewind` | removes the idle cycle between finishing the last iteration and restarting the loop on the next call, for continuous operation. Only useful on a loop, or perfect loop nest, in the top-level function | flag | not set |
| `-style <stp\|flp\|frp>` *(check `help`)* | how the pipeline behaves when input stops or output is blocked. `stp`: the whole pipeline stalls; smallest. `flp`: flushable, keeps draining data already inside; more area. `frp`: free-running, never stalls; needs valid signals and more area, but less control fanout | `stp`, `flp`, `frp` | `stp` |
| `<location>` | where the directive applies | `"function"` or `"function/LABEL"` | required |

### How to confirm

- **Loop table** in the (per-module) `<top>_csynth.rpt`: `Pipelined = yes`, and the II `achieved` and `target` sub-columns.
- **Log:** `grep -nE "II Violation|Pipelining result" run.log`. The number of violation lines equals achieved II − 1.
- **If the loop was extracted into a submodule** (`<top>_Pipeline_<LABEL>`), its loop table is in that module's report, not the top report.

### Notes from the exercises

- **Depth readout:** on a pipelined loop, the report's `Iteration Latency` column and the log's `Depth` both read $L_p + 1$. Get $L_p$ from loop C instead (S1.1, S1.2).
- **Core choice follows the target:** under a pipeline target the tool may pick a faster operator core than in `seq`. `fadd` went from latency 10 to 7 in S1.2, trading timing margin for a lower II. Record II together with the timing estimate and any HLS 200-871 warning.
- **II between 2 and $L$ is free:** it reused `seq`'s register boundaries in S1.1 (`pipe_ii2` had the same area as `seq`). The area cost of pipelining came from the step to II=1.

---

## `set_directive_array_partition`

**As used in S2.1.3:**

```tcl
set_directive_array_partition -type complete -dim 1 "acc_index" lane
```

### What it does

Tells Vitis how to store an array: as smaller pieces, each with its own storage and its own ports, instead of one memory block. With `-type complete`, every element becomes a separate register, so `data_t lane[10]` becomes ten 32-bit registers, `lane_0` to `lane_9`.

It changes nothing about what the C code computes; it removes the port limit that a single memory puts on how many elements can be touched per cycle.

### Arguments in our command

| part | meaning |
|---|---|
| `set_directive_array_partition` | split an array into smaller pieces |
| `-type complete` | split all the way down: every element is its own register |
| `-dim 1` | which dimension to split. `lane` is one-dimensional, so 1 is the only choice |
| `"acc_index"` | the function where the array is declared |
| `lane` | the array variable |

### When to use it

- **An array is accessed more times per iteration than its memory has ports.** S1.2's rule: $I \ge \lceil A/P \rceil$, where $A$ is accesses per iteration and $P$ ports. A RAM has at most 2 ports; registers have no limit.
- **Small state arrays in a pipeline.** Examples: interleaving lanes (S2.1.3), shift-register taps (S2.2), window registers.
- **Vectorization and replication** (S3.1, S3.2). Unrolled logic needs each copy to reach its own element in the same cycle; without partitioning the copies queue on the port (S3.0 shows this first).
- **To remove guesswork.** Vitis may or may not partition a small array on its own, depending on its `config_array_partition` settings. An explicit directive makes the choice visible in the solution.

### Where it applies

- **Local arrays** inside a function, including `static` arrays.
- **Top-level array arguments** with `ap_memory` (and similar) interfaces. Each piece becomes its own port set. `complete` on a top-level argument gives one scalar port per element.
- **Not on `m_axi` arguments.** Those are an address space in external memory, not an array Vitis can split.
- **Cost scales with array size.** `complete` is sensible for a few to a few tens of elements. On 1024 elements it would mean about 33,000 flip-flops, plus a 1024-to-1 mux wherever the index is a variable; use `block` or `cyclic` there.
- **Variable-index access creates muxes.** A read of `lane[c]` needs a K-to-1 mux, and a write needs an enable decoder. Constant-index access (`lane[K-1]`) needs neither, which is why the shift form is cheaper in LUT than the index form.

### Full syntax

```tcl
set_directive_array_partition [-type <complete|block|cyclic>] [-factor <int>] [-dim <int>] <location> <array>
```

| argument | description | possible values | default |
|---|---|---|---|
| `-type` | how elements are divided into pieces | `complete`, `block`, `cyclic` | `complete` |
| `-factor <int>` | number of pieces for `block` and `cyclic`. Ignored for `complete` | positive integer | required for `block` and `cyclic` |
| `-dim <int>` | which dimension of a multi-dimensional array to split | `1`, `2`, ... for that dimension; `0` for all dimensions | `1` |
| `<location>` | the function where the array is declared (or, for a top-level argument, the top function) | `"function"` | required |
| `<array>` | the array variable name | variable name | required |

**How the three types split an 8-element array** (factor 2):

| type | pieces | result |
|---|---|---|
| `block -factor 2` | contiguous chunks | `{0,1,2,3}` and `{4,5,6,7}`: two memories |
| `cyclic -factor 2` | element $i$ goes to piece $i \bmod 2$ | `{0,2,4,6}` and `{1,3,5,7}`: two memories |
| `complete` | every element alone | 8 registers |

`block` and `cyclic` multiply the number of ports by the factor while keeping memory blocks. `complete` removes the port limit altogether.

**For a 2D array** `a[R][C]`: `-dim 1` splits it into $R$ row pieces, `-dim 2` into $C$ column pieces, and `-dim 0` splits both (with `complete`, $R \cdot C$ registers).

### How to confirm

- **Report:** the array should not appear in the Memory section of `csynth.rpt` (for `complete`), or should appear as several smaller memories (for `block`/`cyclic`).
- **Verilog:** the pieces show up by name. `ACC` may have been extracted into a submodule, so search the whole directory:

  ```bash
  grep -rhoE "lane_[0-9]+" <proj>/<sol>/syn/verilog | sort -u
  ```

- **Log:** a partition that could not be applied (for example, a wrong variable name or location) prints a warning. Grep for the variable name.

### Notes from the exercises

- **Shift form (S2.1.3):** every iteration writes all $K$ lanes, so $A \approx K$. As a RAM this would become a port blocker of about $K/2$; as registers it is $K$ register copies in one cycle.
- **Expected FF cost:** about $32K$ extra flip-flops for $K$ 32-bit lanes. This is the "FF grows about 32 per lane" check in S2.1.3 section 5.1.

---

## `set_directive_dependence`

**As used in S2.1.3:**

```tcl
set_directive_dependence -variable lane -type inter -dependent true -distance $K "acc_index/ACC"
```

### What it does

Gives Vitis information about data dependencies that its own analysis cannot work out, so it does not have to assume the worst case. Here it says: a read of `lane` in this loop depends on the write made $K$ iterations earlier, not the previous iteration.

Without it, Vitis sees `lane[c]` read and written in every iteration, cannot tell which element `c` selects, and assumes distance 1. With a slow adder that forces a large II (II=7 in `index_k10/pipe`). With the stated distance, the tool only needs $I \cdot K \ge \delta$, where $\delta$ is the latency on the dependency path.

**The tool does not check the statement.** If it is false, Vitis builds hardware that computes the wrong result. csim cannot catch this, because C runs one iteration at a time; only cosim can.

### Arguments in our command

| part | meaning |
|---|---|
| `set_directive_dependence` | tell the tool about a dependency |
| `-variable lane` | the dependency concerns the array `lane` |
| `-type inter` | between different iterations of the loop (not within one iteration) |
| `-dependent true` | a real dependency exists; do not remove it |
| `-distance $K` | the read depends on the write from $K$ iterations earlier. `$K` is a Tcl variable set in `run_hls.tcl` before this file is sourced |
| `"acc_index/ACC"` | the loop labelled `ACC` in function `acc_index` |

### When to use it

- **The tool assumes a dependency distance that is too short**, and you know the real one. Example: counter-indexed lanes (S2.1.3 index form). Use `-dependent true -distance <d>`.
- **The tool assumes a dependency that does not exist at all.** Example: a data-dependent index that you know never repeats within the window, or a read-modify-write made safe by a forwarding buffer (S2.3 histogram). Use `-dependent false`.
- **Only after reading the violation lines.** The log names the variable and the assumed distance; that is what tells you the analysis was conservative rather than the dependency being real.
- **Not as a way to force a lower II.** If the dependency is real at the distance the tool assumed, the directive cannot legally help; restructure the code instead (S2.1 interleaving, S2.2 delay buffering).

### Where it applies

- **Loops**, with location `"function/LABEL"`, for dependencies between iterations (`-type inter`). **Functions or loops** for dependencies within one iteration (`-type intra`).
- **Arrays** (through `-variable` or `-class array`) and **scalars** (through `-variable`) that are read and written in the loop.
- **Safe only when the statement is true or conservative:**
  - `-dependent true -distance d` is safe if $d \le$ the real distance. A smaller $d$ may cost II; a larger $d$ produces wrong hardware (S2.1.3 extra 5.5a).
  - `-dependent false` is safe only if no dependency exists at all, or if the code handles it (for example with forwarding).
- **Always verify with cosim**, with directed test vectors that hit the dependency (for example, repeated values in the histogram case).
- *Not yet confirmed on this install:* whether `-variable lane` is still found after `lane` has been partitioned into `lane_0` ... `lane_9` (S2.1.3 section 4.3 note).

### Full syntax

```tcl
set_directive_dependence [-variable <name> | -class <array|pointer>] [-type <inter|intra>] [-dependent <true|false>] [-direction <RAW|WAR|WAW>] [-distance <int>] <location>
```

| argument | description | possible values | default |
|---|---|---|---|
| `-variable <name>` | the variable the dependency concerns. Use this or `-class`, not both | variable name | — |
| `-class <array\|pointer>` *(check `help`)* | apply to every variable of that class in the location, instead of one named variable | `array`, `pointer` | — |
| `-type <inter\|intra>` | `inter`: between different iterations of a loop. `intra`: within one iteration (for example, the order of a read and a write of the same element in the same iteration) | `inter`, `intra` | `inter` |
| `-dependent <true\|false>` | `true`: a dependency exists; use `-distance` to say how far apart. `false`: no dependency exists; the tool removes it | `true`, `false` | write it explicitly every time |
| `-direction <RAW\|WAR\|WAW>` *(check `help`)* | which access pattern the dependency is about. `RAW`: read after write (a true data dependency). `WAR`: write after read. `WAW`: write after write | `RAW`, `WAR`, `WAW` | — |
| `-distance <int>` | for `-type inter -dependent true`: how many iterations separate the write and the read that depends on it. Ignored otherwise | positive integer | — |
| `<location>` | where the dependency applies | `"function/LABEL"` for a loop; `"function"` | required |

### How to confirm

- **Log:** the `II Violation` lines naming the variable should disappear, and `Pipelining result` should show the lower `Final II`.
- **Correctness:** the testbench must pass in **cosim**, not just csim. A false statement passes csim and fails cosim.

### Notes from the exercises

- **Shift form needs no directive (S2.1.3):** the distance is visible to the tool as a chain of register copies. Only the index form needs the promise.
- **The promise rule:** stated distance $\le$ real distance is safe; stated distance $>$ real distance is a bug the tool will not report (S2.1.3 Q3 and extra 5.5a).
- **Fallback in S2.1.1 (`gemm_trans/pipe_dist`):** `-variable acc -distance 32` on `"gemm_trans/COL"`, used only if the tool does not prove the distance on its own after `PROD`·`COL` is flattened. 32 is the true distance, so the promise is safe. Not needed on 2023.2.2: `trans/pipe` reached II = 1 with no violations, so whether the directive survives flattening is still untested.

---

## `set_directive_bind_storage`

**As used in S2.1.1:**

```tcl
set_directive_bind_storage -type ram_2p "gemm_trans" acc
```

### What it does

Chooses the kind of memory an array is built from: how many ports it has and which FPGA resource implements it. Without it, Vitis picks both by itself, usually a one-port RAM (`ram_1p`) for a local array that is only accessed once per cycle.

The number of ports matters for pipelining. S1.2's rule is $I \ge \lceil A/P \rceil$ ($A$ accesses per iteration, $P$ ports). A read and a write of `acc` in the same iteration give $A = 2$. On `ram_1p` ($P = 1$) that forces II = 2. On `ram_2p` ($P = 2$) the read and the write each have a port, so II = 1 is possible.

Like `array_partition`, it does not change what the C code computes. Unlike `array_partition`, it keeps the array as one memory and only changes that memory's ports and implementation.

### Arguments in our command

| part | meaning |
|---|---|
| `set_directive_bind_storage` | choose the memory type for a variable |
| `-type ram_2p` | a dual-port RAM: one port can only read, the other can read and write |
| `"gemm_trans"` | the function where the array is declared |
| `acc` | the array variable |

`-impl` is not given, so the tool decides. In S2.1.1 it chose BRAM for a 32 × 32 `acc` (`RAM_2P_AUTO_1R1W`, 1 BRAM_18K); S4.5 varies it.

### When to use it

- **A memory port limit is the II blocker**, and the array is too large to partition into registers. One read and one write per iteration, as with an accumulator buffer (S2.1.1 `acc`) or the FIR delay line on a RAM (S1.2 `fir3_pipe_2p`).
- **To keep solutions comparable.** S2.1.1 puts the same `ram_2p` line in `trans/seq` and `trans/pipe`, so that going from `seq` to `pipe` changes only the pipelining, not the memory.
- **To choose the resource** (`-impl`): BRAM for large arrays, LUTRAM for small ones or to save BRAM blocks, URAM for very large ones on UltraScale+ (S4.5).
- **To set the read latency** (`-latency`) when a larger memory needs an output register to meet timing.

### Where it applies

- **Local arrays** inside a function, including `static` arrays. The location is the function where the array is declared.
- **Top-level array arguments** with an `ap_memory` interface. Here it does not create a memory. It tells Vitis what kind of external memory the port connects to (for example `ram_2p` gives the port a second address/data set).
- **Not on arrays that are partitioned with `complete`.** They become registers, so there is no memory left to bind.
- **Not on `m_axi` arguments.** Their memory is outside the design.
- **Two ports is the maximum for a RAM.** If an iteration needs more than 2 accesses, `bind_storage` alone cannot reach II = 1; partition the array (or restructure the code) instead.

### Full syntax

```tcl
set_directive_bind_storage [-type <type>] [-impl <impl>] [-latency <int>] <location> <variable>
```

| argument | description | possible values | default |
|---|---|---|---|
| `-type <type>` | the memory's behaviour and port count (see table below) | `fifo`, `ram_1p`, `ram_1wnr`, `ram_2p`, `ram_s2p`, `ram_t2p`, `rom_1p`, `rom_2p`, `rom_np` *(check `help`)* | chosen by the tool |
| `-impl <impl>` | the FPGA resource used to build it | `bram`, `lutram`, `uram`, `srl`, `memory`, `auto`; not every combination with `-type` is allowed *(check `help`)* | `auto` (tool decides) |
| `-latency <int>` | read latency in cycles. Higher values add output registers, which helps timing on large memories but deepens the pipeline | non-negative integer | depends on type and impl |
| `<location>` | the function where the variable is declared (or the top function, for an argument) | `"function"` | required |
| `<variable>` | the array (or FIFO stream) name | variable name | required |

**The RAM types:**

| type | ports | what each port can do |
|---|---|---|
| `ram_1p` | 1 | read or write, one access per cycle |
| `ram_1wnr` | 1 write + N read | one write port and several read-only ports *(check `help`)* |
| `ram_2p` | 2 | port 0 reads and writes, port 1 only reads |
| `ram_s2p` | 2 | simple dual port: one port only writes, the other only reads |
| `ram_t2p` | 2 | true dual port: both ports can read and write |

For S2.1.1's `acc` (one read, one write), `ram_2p`, `ram_s2p` and `ram_t2p` would all give II = 1. `ram_2p` is the one the README uses.

**Argument order confirmed on 2023.2.2** (options, then location, then variable): the log echoes `set_directive_bind_storage -type ram_2p gemm_trans acc`.

### How to confirm

- **Log:** the directive is echoed when the directives file is sourced. A wrong variable name or location prints a warning; grep for the variable name.
- **Report, Memory section:** the array appears as one memory instance with its words × bits. Look in the top module report first, then the other `*_csynth.rpt` files if the loop was extracted into a submodule:

  ```bash
  grep -n -A8 "+ Memory" <proj>/<sol>/syn/report/<top>_csynth.rpt
  ```

- **Report, `== Storage Report`** in the design-wide `syn/report/csynth.rpt`: usage (`ram_2p array`), `Pragma = yes`, `Impl` (`auto`), latency, and bitwidth/depth/banks. The chosen resource shows in the BRAM/URAM columns and in the per-module Memory section.
- **II:** if the directive did not take effect and the array stayed on `ram_1p`, the log shows II = 2 with a reason naming the array and a port or resource limitation (S2.1.1 section 3.C, risk 3).

### Notes from the exercises

- **S2.1.1:** `acc` (32 words × 32 bits) went to 1 BRAM_18K as `RAM_2P_AUTO_1R1W`, read latency 1. The log prints `BIND 205-102` ("the specified resource core for memory 'acc' will be ignored if a simpler one can be used"): `ram_2p` was built as a simple 1R1W RAM, which is enough for one read and one write.
- **S2.1.1 RTL:** `acc` is read at pipeline stage 8 and written at stage 21, so each element must be written at least 14 trips before it is read again. With $M = 32$ that holds at II = 1.
- **The area cost of transposition is this buffer.** Its size grows with $M$, which is what tiling (S2.1.2) bounds.

---

## `set_directive_loop_flatten`

**As used in S2.1.1 (extra 5.5a):**

```tcl
set_directive_loop_flatten -off "gemm_trans/COL"
```

### What it does

Loop flattening turns a nest of loops into one loop whose trip count is the product of the individual trip counts. For example, `PROD` (32) around `COL` (32) becomes one loop of 1024 trips.

When the inner loop is pipelined, flattening means the pipeline runs once per iteration of the *remaining* outer loop instead of once per iteration of the loop it was flattened into. Each run pays the pipeline fill and drain, plus the cycles to enter and leave the loop. So fewer, longer runs save cycles:

| design (S2.1.1) | pipeline runs per call | trips per run |
|---|---|---|
| `naive/pipe` (auto-flattened, 3 levels) | 1 | $N \cdot M \cdot K = 32\,768$ |
| `trans/pipe` (flattened) | $N = 32$ | $K \cdot M = 1024$ |
| `trans/pipe_noflat` | $N \cdot K = 1024$ | $M = 32$ |

**Vitis flattens automatically** when the inner loop of a perfect or semi-perfect nest is pipelined. So in practice this directive is mostly used **with `-off`**, to stop that, or to force flattening where the tool would not do it on its own.

Flattening can also change which dependencies the tool has to prove. In S2.1.1, `acc[m]` is only reused across different `k`. Without flattening, each `COL` run drains before the next `k`, so there is no carried dependency inside the pipeline. With flattening, consecutive `k` share one pipeline, and the tool must prove distance $M$ (Q4).

### Arguments in our command

| part | meaning |
|---|---|
| `set_directive_loop_flatten` | control flattening of a loop nest |
| `-off` | do **not** flatten this loop into its parent |
| `"gemm_trans/COL"` | the loop labelled `COL` in function `gemm_trans` (the inner loop of the nest) |

### When to use it

- **To measure what flattening buys** (S2.1.1 extra 5.5a): the same design with and without it, so the II and the number of pipeline runs can be compared separately.
- **To keep a loop hierarchy on purpose**, for example when a flattened loop's combined exit condition makes the critical path longer, or when the outer loop body must stay a separate state.
- **To flatten where the tool did not** (without `-off`), after making the nest perfect or semi-perfect. Pipelined loop flattening is S2.5.

### Where it applies

- **Loops only.** The location is `"function/LABEL"`, normally the **innermost** loop of the nest.
- **Which nests can be flattened:**

  | nest | definition | flattened? |
  |---|---|---|
  | perfect | only the innermost loop has a body; all bounds are constant | yes |
  | semi-perfect | only the innermost loop has a body; the innermost bound is constant, outer bounds may be variable | yes |
  | imperfect | code between the loop headers (before or after an inner loop) | often yes on 2023.2.2: the tool first moves that code into the inner loop behind conditions (HLS 200-2061). Not when a second loop follows the inner loop |

- **S2.1.1 examples:** `gemm_trans` `PROD`·`COL` is perfect, because `k == 0` and the `A[n][k]` read are *inside* `COL`. `gemm_naive` `COL`·`PROD` is imperfect, because `acc = C[n][m]` comes before `PROD` and `C[n][m] = acc` comes after it, yet 2023.2.2 converted it (HLS 200-2061) and flattened all three levels into `ROW_COL_PROD`. `gemm_trans` `ROW` is not flattened into `PROD_COL`, because the `WRITE` loop follows `PROD`.
- **`-off` placement (confirmed on 2023.2.2):** `-off` on the inner loop `COL` alone is enough. `pipe_noflat` shows `COL` (32 trips) inside `PROD`.

### Full syntax

```tcl
set_directive_loop_flatten [-off] <location>
```

| argument | description | possible values | default |
|---|---|---|---|
| `-off` | prevent flattening at this location, while other loops may still be flattened | flag | not set (flattening allowed) |
| `<location>` | the loop, normally the innermost loop of the nest | `"function/LABEL"` | required |

### How to confirm

- **Log:** `HLS 200-2061` (nest converted to perfect) and `XFORM 203-541 Flattening a loop nest '<outer>'`. Check this for every pipelined nest:

  ```bash
  grep -nE "200-2061|[Ff]latten" run.log
  ```

- **Loop table:** a flattened nest shows **one** pipelined loop with the product trip count (1024) and the labels joined outer to inner (`PROD_COL`, `ROW_COL_PROD`). The pipeline may be extracted into a submodule `<top>_Pipeline_<name>` with its own report. An unflattened nest shows the inner loop (32 trips) indented under the outer one.
- **Function latency:** the flattened design is shorter by about (fill/drain + entry/exit cycles) × (runs saved).

### Notes from the exercises

- **S2.1.1 measured:** flattened `trans/pipe` 36 641 cycles per call, `pipe_noflat` 61 537 (1.68×). Both have II = 1; the difference is 1024 − 32 pipeline runs × about 25 cycles each.
- **Flattening costs a stage and clock margin:** depth 21 against 20, estimate 2.781 ns against 2.451 ns. In both S2.1.1 pipelines, the critical path is the flattened loop counter (compare → select → add → select).
- **The `config_compile -pipeline_loops 0` line in `common/part.tcl`** only turns off automatic *pipelining*. It does not stop flattening of a nest whose inner loop is explicitly pipelined (confirmed in S2.1.1).