# Directive reference

Notes on the Vitis HLS directives used in this repo, written as they come up in the exercises. Tool version: Vitis HLS 2023.2.

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