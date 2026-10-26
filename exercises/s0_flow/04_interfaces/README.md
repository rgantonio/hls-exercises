# S0.4 — Interfaces and Control

**Section:** S0 — Driving Vitis HLS (final exercise)
**Kernel:** `iface` (new, self-contained)
**Flow:** csim once, then `csynth_design` across seven solutions. No cosim, no export.
**Goal:** learn to read and control the *port list* — what the RTL block looks like from the outside.

---

## 0. Why this exercise exists

Everything in S0.1–S0.3 was about the inside of the block: does it compile, does it
synthesize, how long does it take. This exercise is about the outside.

When Vitis HLS synthesizes a C function, every argument becomes a set of RTL ports, and
the *function itself* becomes a set of control ports. Which ports you get is a choice,
not a fact. That choice decides:

- whether the block can be driven from a CPU register write or needs a dedicated FSM,
- whether an array argument becomes a BRAM port, a FIFO, or an AXI master,
- whether the block can be cosimulated at all,
- how much logic the interface adapters cost you before any compute happens.

This is also the one place where an SDFG-based flow and an HLS flow differ most visibly:
an SDFG describes data movement explicitly, whereas in HLS the data movement at the
boundary is implied by a directive. Knowing the catalogue of implied behaviours is the
point of this exercise.

Reference: AMD/Xilinx *Vitis HLS User Guide* (UG1399), "Defining Interfaces" chapter, and
the `INTERFACE` pragma reference. Version-specific — this exercise is written against
**2023.2**.

---

## 1. The kernel

One kernel, used by all seven solutions. It is deliberately shaped so that every interface
mode we want to try is legal on it.

`src/iface.h`

```cpp
#ifndef IFACE_H
#define IFACE_H

typedef int data_t;
#define N 64

void iface(data_t a, const data_t x[N], data_t y[N], data_t *sum);

#endif
```

`src/iface.cpp`

```cpp
#include "iface.h"

void iface(data_t a, const data_t x[N], data_t y[N], data_t *sum) {
  data_t acc = 0;

SCALE_LOOP:
  for (int i = 0; i < N; i++) {
    data_t v = x[i] * a;
    y[i]     = v;
    acc     += v;
  }

  *sum = acc;
}
```

Three properties are on purpose:

1. **`x` and `y` are accessed strictly in order, once each.** That is the legality
   requirement for `ap_fifo`. If the loop read `x[N-1-i]`, or read `x[i]` twice, the FIFO
   solution would fail to synthesize.
2. **`*sum` is written exactly once, at the end.** That is what makes `ap_vld` meaningful —
   the valid strobe fires once, when the value is final.
3. **`SCALE_LOOP` is labelled**, per the S0.1 convention. Nothing targets it here, but
   labels are unconditional.

Note on `N = 64`: that is exactly the default `config_compile -pipeline_loops` threshold,
so this loop would auto-pipeline if left alone. `common/part.tcl` already sets
`-pipeline_loops 0`, so it will not. Do not change that here — pipelining would shift the
latency numbers between solutions and muddy the port diff, which is the actual subject.

---

## 2. The testbench

Same shape as `tiny` and `scale`: separate reference model, poison the outputs, directed
vectors first, then seeded randoms, count errors instead of bailing on the first one,
non-zero return on failure.

`src/tb.cpp`

```cpp
#include <cstdio>
#include <cstdlib>
#include "iface.h"

static const data_t POISON = (data_t)0xDEADBEEF;

// Reference model. Overflow is computed through unsigned so the reference wraps
// the same way the RTL does; signed overflow is UB in C++.
static void ref(data_t a, const data_t x[N], data_t y[N], data_t *sum) {
  unsigned acc = 0u;
  for (int i = 0; i < N; i++) {
    unsigned v = (unsigned)x[i] * (unsigned)a;
    y[i] = (data_t)v;
    acc += v;
  }
  *sum = (data_t)acc;
}

static int check(const char *name, data_t a, const data_t x[N]) {
  data_t y_dut[N], y_ref[N];
  data_t s_dut, s_ref;

  for (int i = 0; i < N; i++) y_dut[i] = POISON;
  s_dut = POISON;

  iface(a, x, y_dut, &s_dut);
  ref(a, x, y_ref, &s_ref);

  int errors = 0;
  for (int i = 0; i < N; i++) {
    if (y_dut[i] != y_ref[i]) {
      if (errors < 5)
        printf("FAIL %-10s y[%2d] got %d want %d\n", name, i, y_dut[i], y_ref[i]);
      errors++;
    }
  }
  if (s_dut != s_ref) {
    printf("FAIL %-10s sum   got %d want %d\n", name, s_dut, s_ref);
    errors++;
  }
  return errors;
}

int main() {
  int errors = 0;
  data_t x[N];

  // ---- directed cases -------------------------------------------------
  for (int i = 0; i < N; i++) x[i] = 0;        errors += check("zeros",   3, x);
  for (int i = 0; i < N; i++) x[i] = 1;        errors += check("ones",    3, x);
  for (int i = 0; i < N; i++) x[i] = i;        errors += check("ramp_a0", 0, x);
  for (int i = 0; i < N; i++) x[i] = i;        errors += check("ramp_a1", 1, x);
  for (int i = 0; i < N; i++) x[i] = i;        errors += check("ramp_an1", -1, x);
  for (int i = 0; i < N; i++) x[i] = 0x7FFFFFFF; errors += check("maxint", 2, x);
  for (int i = 0; i < N; i++) x[i] = (data_t)0x80000000; errors += check("minint", 2, x);

  // ---- randoms, fixed seed -------------------------------------------
  srand(1);
  for (int t = 0; t < 20; t++) {
    for (int i = 0; i < N; i++) x[i] = (data_t)rand() - (data_t)rand();
    data_t a = (data_t)rand() - (data_t)rand();
    errors += check("rand", a, x);
  }

  if (errors) {
    printf("TEST FAILED with %d errors\n", errors);
    return 1;
  }
  printf("TEST PASSED\n");
  return 0;
}
```

The vector count is small and fixed. There is no `__RTL_SIMULATION__` split here because
this exercise does not run cosim — the port list is a synthesis result, not a simulation
result.

---

## 3. The script and the seven solutions

One project, seven solutions, one invocation. This is the S0.1 convention (naive/opt as
two solutions in one script) extended from two to seven. Because the solutions differ in
their directives, the single `directives.tcl` convention does not fit — use one
`directives_<solution>.tcl` per solution, named after the solution, and note the deviation
in `notes/findings.md`.

`run_hls.tcl`

```tcl
# exercises/s0_flow/04_interfaces/run_hls.tcl
open_project -reset iface_proj
set_top iface
add_files     src/iface.cpp -cflags "-I./src"
add_files -tb src/tb.cpp    -cflags "-I./src"

# --- solution 1: tool defaults. The only solution that runs csim. --------
open_solution -reset "default" -flow_target vivado
source ../../../common/part.tcl
csim_design
csynth_design

# --- solutions 2..7: same source, different interface directives --------
foreach sol {ctrl_chain ctrl_none axilite fifo maxi scalar_vld} {
  open_solution -reset $sol -flow_target vivado
  source ../../../common/part.tcl
  source ./directives_$sol.tcl
  csynth_design
}

close_project
```

Three things worth pointing at:

- `-flow_target vivado` is mandatory here. The default Vitis kernel flow forces `m_axi` on
  pointer/array arguments and `s_axilite` on the control, which is exactly the one port
  configuration this exercise wants to reach *deliberately*. The Vivado IP flow gives you
  `ap_memory` + `ap_ctrl_hs` defaults, so you can see the whole catalogue.
- `-reset` on both `open_project` and `open_solution`: interface directives accumulate
  across runs otherwise, and a solution would silently inherit the previous solution's
  ports.
- `csim_design` is called once, on the first solution. The C behaviour is identical across
  all seven — only the RTL boundary changes — so re-running it would be wasted time.

Run it, as always:

```bash
vitis_hls -f run_hls.tcl 2>&1 | tee run.log
```

### The directive files

`directives_ctrl_chain.tcl`

```tcl
set_directive_interface -mode ap_ctrl_chain "iface" return
```

`directives_ctrl_none.tcl`

```tcl
set_directive_interface -mode ap_ctrl_none "iface" return
```

`directives_axilite.tcl`

```tcl
set_directive_interface -mode s_axilite -bundle control "iface" return
set_directive_interface -mode s_axilite -bundle control "iface" a
set_directive_interface -mode s_axilite -bundle control "iface" sum
```

`directives_fifo.tcl`

```tcl
set_directive_interface -mode ap_fifo "iface" x
set_directive_interface -mode ap_fifo "iface" y
```

`directives_maxi.tcl`

```tcl
set_directive_interface -mode m_axi -bundle gmem -offset slave -depth 64 "iface" x
set_directive_interface -mode m_axi -bundle gmem -offset slave -depth 64 "iface" y
set_directive_interface -mode s_axilite -bundle control "iface" a
set_directive_interface -mode s_axilite -bundle control "iface" sum
set_directive_interface -mode s_axilite -bundle control "iface" return
```

`directives_scalar_vld.tcl`

```tcl
set_directive_interface -mode ap_vld "iface" a
```

`-bundle control` is passed explicitly rather than relying on the default bundle name.
The default has changed across tool generations; pinning it means the port names in your
notes are reproducible.

---

## 4. Extracting the port lists

The interface summary lives at the **end** of the synthesis report:

```
iface_proj/<solution>/syn/report/iface_csynth.rpt
```

under a `== Interface` heading, as a table with columns
`RTL Ports | Dir | Bits | Protocol | Source Object | C Type`.

Dump all seven:

```bash
for s in default ctrl_chain ctrl_none axilite fifo maxi scalar_vld; do
  echo "=================== $s ==================="
  awk '/^== Interface/{f=1} f' iface_proj/$s/syn/report/iface_csynth.rpt
done | tee interfaces.txt
```

Then reduce each to a sorted list of port names so you can diff them mechanically:

```bash
for s in default ctrl_chain ctrl_none axilite fifo maxi scalar_vld; do
  awk -F'|' '/^== Interface/{f=1} f && NF>3 {gsub(/^ +| +$/,"",$2); print $2}' \
      iface_proj/$s/syn/report/iface_csynth.rpt | sort -u > ports_$s.txt
done

diff ports_default.txt ports_ctrl_chain.txt
diff ports_default.txt ports_axilite.txt
diff ports_default.txt ports_fifo.txt
```

(If the table formatting on your install differs slightly, adjust the `awk` — the point is
the diff, not the one-liner.)

Then, we also extract some FPGA resource usage:

```bash
./collect_resources.sh
```

Although not 
---

## 5. Step-by-step: what to look for, solution by solution

Work through these in order. For each one, look at the diff *first* and try to explain it
before reading the explanation.

### 5.1 `default` — the baseline

| RTL Port     | Dir | Bits | Protocol     | Source Object | C Type       |
|--------------|-----|-----:|--------------|---------------|--------------|
| `ap_clk`     | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_rst`     | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_start`   | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_done`    | out |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_idle`    | out |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_ready`   | out |    1 | `ap_ctrl_hs` | iface         | return value |
| `a`          | in  |   32 | `ap_none`    | a             | scalar       |
| `x_address0` | out |    6 | `ap_memory`  | x             | array        |
| `x_ce0`      | out |    1 | `ap_memory`  | x             | array        |
| `x_q0`       | in  |   32 | `ap_memory`  | x             | array        |
| `y_address0` | out |    6 | `ap_memory`  | y             | array        |
| `y_ce0`      | out |    1 | `ap_memory`  | y             | array        |
| `y_we0`      | out |    1 | `ap_memory`  | y             | array        |
| `y_d0`       | out |   32 | `ap_memory`  | y             | array        |
| `sum`        | out |   32 | `ap_vld`     | sum           | pointer      |
| `sum_ap_vld` | out |    1 | `ap_vld`     | sum           | pointer      |
Four defaults are on display here, and they are the ones to memorise:

- **function return → `ap_ctrl_hs`**: a four-wire start/done handshake.
- **scalar by value → `ap_none`**: a bare wire, no handshake at all. The caller must hold
  it stable; nothing in the RTL enforces that.
- **array argument → `ap_memory`**: address / chip-enable / write-enable / data ports, i.e.
  the block expects to be wired to a RAM *outside* itself. Note `x` gets no `we`/`d`
  because it is `const` — read-only.
- **output pointer → `ap_vld`**: data plus a one-cycle valid strobe.

Contrast with S0.1's `tiny`, where `ap_rst` was absent: that design had no registers, so
there was no state to reset. This one has a loop counter and an accumulator, so `ap_rst`
appears.

Also note the `x_address0` width: 6 bits for `N = 64`. The tool sized the address bus from
the declared array extent. This is why `const data_t x[N]` and `const data_t *x` are not
interchangeable at the interface — the array form carries a size, the pointer form does not.

Note: `y` is declared `data_t y[N]` — an array. An array has `N` elements, so selecting one requires an address bus and a chip enable. That's a memory protocol by necessity, and the 6-bit width falls straight out of the declared extent. `sum` is declared `data_t *sum` and is dereferenced exactly once, never indexed. There's nothing to address, so all the boundary needs is the data plus a strobe saying "this is final now."

Direction then comes from the access pattern on top of that. `x` is only read, so its `ap_memory` group has `_q0` but no `_we0/_d0`. `y` is only written, so it has `_we0/_d0` but no `_q0.` Nothing in the declaration said "output" — the tool worked it out from the loop body. Same for `sum`: if you had written `acc = *sum;` at the top to seed the accumulator, sum would have become `ap_ovld` with an input data port alongside.

Why `sum` gets a valid strobe while `a` gets bare `ap_none`: for an input, the caller is responsible for holding the value stable, so a wire suffices. For an output, the consumer has no way to know which cycle the value became final — the output register holds intermediate junk until the last write. `ap_vld` pulses on exactly that cycle. Written twice in the function, it would pulse twice.

### 5.2 `ctrl_chain` — one extra wire

| RTL Port      | Dir | Bits | Protocol        | Source Object | C Type       |
|---------------|-----|-----:|-----------------|---------------|--------------|
| `ap_clk`      | in  |    1 | `ap_ctrl_chain` | iface         | return value |
| `ap_rst`      | in  |    1 | `ap_ctrl_chain` | iface         | return value |
| `ap_start`    | in  |    1 | `ap_ctrl_chain` | iface         | return value |
| `ap_done`     | out |    1 | `ap_ctrl_chain` | iface         | return value |
| `ap_continue` | in  |    1 | `ap_ctrl_chain` | iface         | return value |
| `ap_idle`     | out |    1 | `ap_ctrl_chain` | iface         | return value |
| `ap_ready`    | out |    1 | `ap_ctrl_chain` | iface         | return value |
| `a`           | in  |   32 | `ap_none`       | a             | scalar       |
| `x_address0`  | out |    6 | `ap_memory`     | x             | array        |
| `x_ce0`       | out |    1 | `ap_memory`     | x             | array        |
| `x_q0`        | in  |   32 | `ap_memory`     | x             | array        |
| `y_address0`  | out |    6 | `ap_memory`     | y             | array        |
| `y_ce0`       | out |    1 | `ap_memory`     | y             | array        |
| `y_we0`       | out |    1 | `ap_memory`     | y             | array        |
| `y_d0`        | out |   32 | `ap_memory`     | y             | array        |
| `sum`         | out |   32 | `ap_vld`        | sum           | pointer      |
| `sum_ap_vld`  | out |    1 | `ap_vld`        | sum           | pointer      |

Diff against `default` should show exactly one addition: **`ap_continue`** (input).

`ap_ctrl_chain` is `ap_ctrl_hs` plus back-pressure. With `ap_ctrl_hs`, the block asserts
`ap_done` and moves on regardless of whether anyone consumed the result. With
`ap_ctrl_chain`, the downstream block drives `ap_continue`, and this block stalls at
`ap_done` until it is asserted. That is what lets two HLS blocks be chained into a pipeline
without a handshake adapter between them.

Practical consequence: if you instantiate an `ap_ctrl_chain` block and leave `ap_continue`
tied low, it runs exactly once and then hangs forever. This is a common first-bring-up bug.

Walk through the timeline for a non-pipelined block like iface:

1. `ap_start` high, `ap_idle` drops, the block runs `SCALE_LOOP` for its ~64 iterations. `ap_continue` is irrelevant during all of this — the block is inside a transaction, and back-pressure has no meaning there because nothing is finished yet.
2. The last write lands. The block asserts `ap_done` and holds it.
3. Now `ap_continue` matters. Low → `ap_done` stays asserted and the block sits there. It does not return to idle, does not sample `ap_start`, does not begin anything new. Outputs are held valid. High → the handshake completes on that clock edge, ap_done drops, and the block is free to start the next transaction on the next `ap_start`.

### 5.3 `ctrl_none` — four wires gone

| RTL Port     | Dir | Bits | Protocol       | Source Object | C Type       |
|--------------|-----|-----:|----------------|---------------|--------------|
| `ap_clk`     | in  |    1 | `ap_ctrl_none` | iface         | return value |
| `ap_rst`     | in  |    1 | `ap_ctrl_none` | iface         | return value |
| `a`          | in  |   32 | `ap_none`      | a             | scalar       |
| `x_address0` | out |    6 | `ap_memory`    | x             | array        |
| `x_ce0`      | out |    1 | `ap_memory`    | x             | array        |
| `x_q0`       | in  |   32 | `ap_memory`    | x             | array        |
| `y_address0` | out |    6 | `ap_memory`    | y             | array        |
| `y_ce0`      | out |    1 | `ap_memory`    | y             | array        |
| `y_we0`      | out |    1 | `ap_memory`    | y             | array        |
| `y_d0`       | out |   32 | `ap_memory`    | y             | array        |
| `sum`        | out |   32 | `ap_vld`       | sum           | pointer      |
| `sum_ap_vld` | out |    1 | `ap_vld`       | sum           | pointer      |

Diff should show `ap_start`, `ap_done`, `ap_idle`, `ap_ready` all **removed**. `ap_clk` and
`ap_rst` stay.

`ap_ctrl_none` produces a free-running block: it starts on reset release and never signals
completion. Useful when the block is purely streaming and the surrounding fabric provides
flow control some other way (typically `ap_fifo` or AXI-Stream on every port).

Two things to record:

- **Cosim does not work with `ap_ctrl_none`.** C/RTL cosimulation drives the design through
  the block-level handshake and waits for `ap_done`; with no handshake there is nothing to
  drive and nothing to wait for. If you try, the tool will refuse. This is the reason this
  whole exercise is csynth-only.
- `ap_ctrl_none` on a block whose data ports still use `ap_memory` is *dangerous* rather
  than wrong: the block will keep issuing addresses whether or not anything is listening.
  It only makes sense combined with self-flow-controlling data ports.

### 5.4 `axilite` — the control plane moves into registers

| RTL Port                | Dir | Bits | Protocol     | Source Object | C Type       |
|-------------------------|-----|-----:|--------------|---------------|--------------|
| `s_axi_control_AWVALID` | in  |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_AWREADY` | out |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_AWADDR`  | in  |    5 | `s_axi`      | control       | pointer      |
| `s_axi_control_WVALID`  | in  |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_WREADY`  | out |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_WDATA`   | in  |   32 | `s_axi`      | control       | pointer      |
| `s_axi_control_WSTRB`   | in  |    4 | `s_axi`      | control       | pointer      |
| `s_axi_control_ARVALID` | in  |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_ARREADY` | out |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_ARADDR`  | in  |    5 | `s_axi`      | control       | pointer      |
| `s_axi_control_RVALID`  | out |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_RREADY`  | in  |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_RDATA`   | out |   32 | `s_axi`      | control       | pointer      |
| `s_axi_control_RRESP`   | out |    2 | `s_axi`      | control       | pointer      |
| `s_axi_control_BVALID`  | out |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_BREADY`  | in  |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_BRESP`   | out |    2 | `s_axi`      | control       | pointer      |
| `ap_clk`                | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_rst_n`              | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `interrupt`             | out |    1 | `ap_ctrl_hs` | iface         | return value |
| `x_address0`            | out |    6 | `ap_memory`  | x             | array        |
| `x_ce0`                 | out |    1 | `ap_memory`  | x             | array        |
| `x_q0`                  | in  |   32 | `ap_memory`  | x             | array        |
| `y_address0`            | out |    6 | `ap_memory`  | y             | array        |
| `y_ce0`                 | out |    1 | `ap_memory`  | y             | array        |
| `y_we0`                 | out |    1 | `ap_memory`  | y             | array        |
| `y_d0`                  | out |   32 | `ap_memory`  | y             | array        |

Measured diff:

- **removed:** `ap_start`, `ap_done`, `ap_idle`, `ap_ready`, `a`, `sum`, `sum_ap_vld`
- **added:** a 17-port `s_axi_control_*` bundle —
  `AWVALID/AWREADY/AWADDR`, `WVALID/WREADY/WDATA/WSTRB`,
  `ARVALID/ARREADY/ARADDR`, `RVALID/RREADY/RDATA/RRESP`,
  `BVALID/BREADY/BRESP` — plus an `interrupt` output.
- **changed:** `ap_rst` becomes **`ap_rst_n`**.

Note what the Protocol column says for `ap_clk`, `ap_rst_n` and `interrupt`: still
`ap_ctrl_hs`, source object `iface`, C type `return value`. The block-level protocol did not
change to something else — it is still the same start/done/idle/ready handshake, just
implemented as register bits instead of pins. `s_axilite` on `return` is an *implementation*
of `ap_ctrl_hs`, not a replacement for it. This also explains why `interrupt` is attributed
to the return value rather than to the control bundle.

`AWADDR` and `ARADDR` are 5 bits wide, so the register map is 32 bytes. That is enough for
the control/interrupt registers plus `a` and `sum` with its valid-strobe register, and
nothing more. The address width is a direct readout of how many arguments you pushed into
the bundle — watch it grow in the `maxi` solution below.

Three lessons:

1. Nothing disappeared functionally. `ap_start` is now bit 0 of the control register at
   offset `0x00`; `ap_done` is bit 1, `ap_idle` bit 2, `ap_ready` bit 3, and auto-restart is
   bit 7. `a` and `sum` are at their own offsets. The tool writes a driver header
   (`xiface_hw.h` and friends) under `<solution>/impl/misc/drivers/` — **open it**, it is
   the authoritative offset map and it is the thing you would actually program against from
   a CPU.
2. The reset polarity flipped. AXI requires an active-low reset, so as soon as any AXI
   interface exists the top-level reset becomes `ap_rst_n`. If you had a testbench or a
   block design wired for `ap_rst`, it now silently holds the block in reset.
3. `x` and `y` are untouched — still `ap_memory`. Control plane and data plane are
   independent choices. This is the normal shape for an IP-integrator block: registers for
   configuration, BRAM ports for bulk data.

### 5.5 `fifo` — streaming data ports

| RTL Port     | Dir | Bits | Protocol     | Source Object | C Type       |
|--------------|-----|-----:|--------------|---------------|--------------|
| `ap_clk`     | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_rst`     | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_start`   | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_done`    | out |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_idle`    | out |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_ready`   | out |    1 | `ap_ctrl_hs` | iface         | return value |
| `a`          | in  |   32 | `ap_none`    | a             | scalar       |
| `x_dout`     | in  |   32 | `ap_fifo`    | x             | pointer      |
| `x_empty_n`  | in  |    1 | `ap_fifo`    | x             | pointer      |
| `x_read`     | out |    1 | `ap_fifo`    | x             | pointer      |
| `y_din`      | out |   32 | `ap_fifo`    | y             | pointer      |
| `y_full_n`   | in  |    1 | `ap_fifo`    | y             | pointer      |
| `y_write`    | out |    1 | `ap_fifo`    | y             | pointer      |
| `sum`        | out |   32 | `ap_vld`     | sum           | pointer      |
| `sum_ap_vld` | out |    1 | `ap_vld`     | sum           | pointer      |

Diff against `default`:

- **removed:** `x_address0`, `x_ce0`, `x_q0`, `y_address0`, `y_ce0`, `y_we0`, `y_d0`
- **added:** `x_dout`, `x_empty_n`, `x_read`, `y_din`, `y_full_n`, `y_write`

Look at the **C Type** column for `x` and `y`: it changed from `array` to `pointer`. Nothing
in the C source changed. The column reports how the tool now *models* the argument, and a
FIFO has no extent to speak of — only a next element. This is the report telling you that
the declared size `[N]` is no longer carried into the RTL, which is also why the 6-bit
address bus vanished rather than shrinking.

The block no longer addresses memory; it pops from an input FIFO and pushes to an output
FIFO, and it stalls automatically when `x_empty_n` is low or `y_full_n` is low. Flow control
is now built into the data ports, which is what makes `ap_fifo` the natural partner of
`ap_ctrl_none`.

Compare the latency numbers in the report against `default`. They should be close, but the
*meaning* changed: an `ap_memory` latency is a best case that assumes the RAM always
responds, whereas an `ap_fifo` design can stall indefinitely on an empty input. The report
still reports the no-stall case.

**Try it and watch it fail** (then revert): change the loop body to read `x[i]` twice, or to
read `x[N-1-i]`, and re-run just this solution. Vitis will reject it — a FIFO has no address
and cannot re-read a consumed element. Record the exact error text in `notes/findings.md`;
you will see it again in S3.3 when dataflow canonical form is violated.

### 5.6 `maxi` — the block becomes a bus master

| RTL Port                | Dir | Bits | Protocol     | Source Object | C Type       |
|-------------------------|-----|-----:|--------------|---------------|--------------|
| `s_axi_control_AWVALID` | in  |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_AWREADY` | out |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_AWADDR`  | in  |    6 | `s_axi`      | control       | pointer      |
| `s_axi_control_WVALID`  | in  |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_WREADY`  | out |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_WDATA`   | in  |   32 | `s_axi`      | control       | pointer      |
| `s_axi_control_WSTRB`   | in  |    4 | `s_axi`      | control       | pointer      |
| `s_axi_control_ARVALID` | in  |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_ARREADY` | out |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_ARADDR`  | in  |    6 | `s_axi`      | control       | pointer      |
| `s_axi_control_RVALID`  | out |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_RREADY`  | in  |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_RDATA`   | out |   32 | `s_axi`      | control       | pointer      |
| `s_axi_control_RRESP`   | out |    2 | `s_axi`      | control       | pointer      |
| `s_axi_control_BVALID`  | out |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_BREADY`  | in  |    1 | `s_axi`      | control       | pointer      |
| `s_axi_control_BRESP`   | out |    2 | `s_axi`      | control       | pointer      |
| `ap_clk`                | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_rst_n`              | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `interrupt`             | out |    1 | `ap_ctrl_hs` | iface         | return value |
| `m_axi_gmem_AWVALID`    | out |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_AWREADY`    | in  |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_AWADDR`     | out |   64 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_AWID`       | out |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_AWLEN`      | out |    8 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_AWSIZE`     | out |    3 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_AWBURST`    | out |    2 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_AWLOCK`     | out |    2 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_AWCACHE`    | out |    4 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_AWPROT`     | out |    3 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_AWQOS`      | out |    4 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_AWREGION`   | out |    4 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_AWUSER`     | out |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_WVALID`     | out |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_WREADY`     | in  |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_WDATA`      | out |   32 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_WSTRB`      | out |    4 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_WLAST`      | out |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_WID`        | out |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_WUSER`      | out |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARVALID`    | out |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARREADY`    | in  |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARADDR`     | out |   64 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARID`       | out |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARLEN`      | out |    8 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARSIZE`     | out |    3 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARBURST`    | out |    2 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARLOCK`     | out |    2 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARCACHE`    | out |    4 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARPROT`     | out |    3 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARQOS`      | out |    4 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARREGION`   | out |    4 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_ARUSER`     | out |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_RVALID`     | in  |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_RREADY`     | out |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_RDATA`      | in  |   32 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_RLAST`      | in  |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_RID`        | in  |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_RUSER`      | in  |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_RRESP`      | in  |    2 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_BVALID`     | in  |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_BREADY`     | out |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_BRESP`      | in  |    2 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_BID`        | in  |    1 | `m_axi`      | gmem          | pointer      |
| `m_axi_gmem_BUSER`      | in  |    1 | `m_axi`      | gmem          | pointer      |


Measured: `x` and `y` collapse into one `m_axi_gmem_*` bundle carrying the full AXI4 channel
set (`AW*`, `W*`, `AR*`, `R*`, `B*` — 45 ports), alongside the 17-port `s_axi_control`
bundle from 5.4 and the three surviving top-level pins. 65 ports in total.

Points to take away:

- **Direction inverted.** With `ap_memory`, something else owns the memory and feeds the
  block. With `m_axi`, the block owns the transaction and goes and fetches data itself. This
  is the difference between an IP core in a block design and a kernel sitting on a DDR
  controller.
- **`-offset slave`** means the base address of `x` and `y` is itself a register in the
  AXI-Lite control bundle, written by the host at runtime. That is why `-offset slave`
  requires `s_axilite` on `return`. The alternatives are `-offset direct` (base address as a
  top-level input port) and `-offset off` (hardcoded to zero).
- **Two directives per `m_axi` argument, not one.** The `m_axi` line says where the *data*
  goes; a second `s_axilite` line on the same argument says where its *offset register*
  goes. Omitting the second one is the bundle-splitting trap below.
- **The address bus width is a readout of the register map.** `AWADDR`/`ARADDR` are 6 bits
  here (64 bytes), against 5 bits (32 bytes) in the `axilite` solution. The extra space holds
  the two 64-bit base addresses, two 32-bit words each.
- **`AWADDR`/`ARADDR` on the master side are 64 bits** while `WDATA`/`RDATA` are 32. The
  address space is 64-bit; the data bus is sized from `data_t`. These are independent, and
  widening the data bus is the S4.3 lever.
- **`WID` is present** even though AXI4 dropped write-ID ordering (it is an AXI3 signal).
  Xilinx emits it for compatibility. It is not a sign you did something wrong.
- Look at the **resource numbers** for this solution against `default`. The AXI adapters cost
  real LUTs and FFs — often more than this kernel's entire datapath. Write both numbers into
  `results.csv`. "The interface costs more than the compute" is a result worth having on
  record before S4.3.

#### The bundle-splitting trap

Write `directives_maxi.tcl` with only the `m_axi` lines plus `s_axilite` on the scalars and
`return`, and the solution synthesizes without complaint into **two** AXI-Lite bundles:

| Bundle | Addr width | Source object | C Type | Ports |
|---|---|---|---|---|
| `s_axi_control` | 5 bits | `control` | pointer | 17 |
| `s_axi_control_r` | 6 bits | `control_r` | scalar | 17 |

`-offset slave` creates an AXI-Lite bundle of its own to hold the two base addresses, and
that bundle also defaults to the name `control`. Two bundles wanted the same name, so the
tool kept the pointer-offset one as `control` and renamed the scalar bundle — the one
carrying `a`, `sum` and the `ap_ctrl_hs` registers — to `control_r`. The `_r` suffix is
disambiguation, not meaning.

The result is a block with two separate register maps at two separate base addresses. A
driver written against one of them silently misses the other, and nothing in the log warns
you. The fix is to name the bundle explicitly for the `m_axi` arguments as well:

```tcl
# directives_maxi.tcl
set_directive_interface -mode m_axi -bundle gmem -offset slave -depth 64 "iface" x
set_directive_interface -mode m_axi -bundle gmem -offset slave -depth 64 "iface" y
set_directive_interface -mode s_axilite -bundle control "iface" x
set_directive_interface -mode s_axilite -bundle control "iface" y
set_directive_interface -mode s_axilite -bundle control "iface" a
set_directive_interface -mode s_axilite -bundle control "iface" sum
set_directive_interface -mode s_axilite -bundle control "iface" return
```

That merges the maps: one `s_axi_control` bundle, no `_r`, 6-bit address, and the port count
drops from 82 to 65. Keep both port lists in `notes/findings.md` — the broken one is the more
useful of the two, because the symptom is invisible unless you count `s_axi_*` prefixes.

One thing the merge does *not* tidy up: the C Type column still reads `pointer` for all 17
rows of the merged bundle, even though it now holds scalars too. That column describes how
the bundle was classified, not what ended up inside it. The authoritative contents are in the
generated driver header under `<solution>/impl/misc/drivers/`.

One-line variation worth trying: change `-bundle gmem` to `-bundle gmem0` on `x` and
`-bundle gmem1` on `y`. You get two complete AXI masters and roughly double the adapter cost,
in exchange for two independent memory channels. That is the striping transformation, covered
properly in S4.3.

### 5.7 `scalar_vld` — the smallest possible diff

| RTL Port     | Dir | Bits | Protocol     | Source Object | C Type       |
|--------------|-----|-----:|--------------|---------------|--------------|
| `ap_clk`     | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_rst`     | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_start`   | in  |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_done`    | out |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_idle`    | out |    1 | `ap_ctrl_hs` | iface         | return value |
| `ap_ready`   | out |    1 | `ap_ctrl_hs` | iface         | return value |
| `a`          | in  |   32 | `ap_vld`     | a             | scalar       |
| `a_ap_vld`   | in  |    1 | `ap_vld`     | a             | scalar       |
| `x_address0` | out |    6 | `ap_memory`  | x             | array        |
| `x_ce0`      | out |    1 | `ap_memory`  | x             | array        |
| `x_q0`       | in  |   32 | `ap_memory`  | x             | array        |
| `y_address0` | out |    6 | `ap_memory`  | y             | array        |
| `y_ce0`      | out |    1 | `ap_memory`  | y             | array        |
| `y_we0`      | out |    1 | `ap_memory`  | y             | array        |
| `y_d0`       | out |   32 | `ap_memory`  | y             | array        |
| `sum`        | out |   32 | `ap_vld`     | sum           | pointer      |
| `sum_ap_vld` | out |    1 | `ap_vld`     | sum           | pointer      |

Diff against `default`: one port added, **`a_ap_vld`** (input), and `a`'s protocol changes
from `ap_none` to `ap_vld`.

The kernel reads `a` once, so this is a small change, but it makes the contract explicit:
the block now waits for the producer to assert `a_ap_vld` rather than assuming `a` is
already stable. The related mode to know about is **`ap_stable`**, which is not a handshake
at all but a promise to the tool that the value never changes during execution — the tool
uses it to avoid re-registering the value. `ap_stable` on a configuration input is free;
`ap_vld` costs a wire and a wait state.

---

## 6. Port protocol catalogue

Consolidated reference. Fill in the "seen in" column as you go.

**Block-level (applied to `return`)**

| Mode | Ports | Use when |
|---|---|---|
| `ap_ctrl_hs` | `ap_start`, `ap_done`, `ap_idle`, `ap_ready` | default; standalone block driven by an FSM |
| `ap_ctrl_chain` | the above + `ap_continue` | block feeds another HLS block directly |
| `ap_ctrl_none` | none | free-running/streaming block; **blocks cosim** |
| `s_axilite` | AXI4-Lite slave bundle + `interrupt` | driven by a CPU over a register map |

**Port-level (applied to arguments)**

| Mode | Ports | Applies to |
|---|---|---|
| `ap_none` | data only | scalar in (default) |
| `ap_stable` | data only, tool assumes it never changes | configuration scalars |
| `ap_vld` | data + `_ap_vld` | scalar in/out (default for output pointers) |
| `ap_ack` | data + `_ap_ack` | rarely used by hand |
| `ap_hs` | data + `_ap_vld` + `_ap_ack` | full two-way handshake on a scalar |
| `ap_ovld` | output data + `_ap_vld` | in-out pointer, valid on the output half only |
| `ap_memory` | `_address`, `_ce`, `_we`, `_d`, `_q` | array (default in the Vivado IP flow) |
| `bram` | same signals, packaged as one BRAM interface | array, when you want a single IP-integrator port |
| `ap_fifo` | `_dout/_empty_n/_read`, `_din/_full_n/_write` | array accessed strictly in order, once each |
| `axis` | AXI4-Stream | `hls::stream<ap_axis<...>>` arguments |
| `m_axi` | full AXI4 master bundle | array/pointer where the block fetches its own data |

`ap_memory` and `bram` produce identical signals; they differ only in how the ports are
grouped when the IP is packaged, which matters in Vivado IP integrator and nowhere else.

---

## 7. Gotchas

- **Directives accumulate without `-reset`.** Removing a line from a directive file does not
  remove the directive from an existing solution. Always `open_solution -reset`.
- **The flow target changes the defaults.** `-flow_target vitis` forces `m_axi` + `s_axilite`;
  `-flow_target vivado` gives `ap_memory` + `ap_ctrl_hs`. If your ports are not what you
  expected, check this before checking anything else.
- **Any AXI interface flips the reset to `ap_rst_n`.**
- **`ap_ctrl_none` and cosim are mutually exclusive.** Plan verification before you choose
  the control protocol, not after.
- **`m_axi` without `-depth` fails at cosim**, not at synthesis. The error arrives late.
- **`ap_fifo` legality is a property of the C code, not the directive.** The directive just
  asks; the access pattern decides.
- **`m_axi -offset slave` silently creates a second AXI-Lite bundle** unless you also give
  each `m_axi` argument an explicit `s_axilite` directive naming the bundle you want. The
  second bundle appears with an `_r` suffix and its own base address. Always check the
  Interface table for more than one `s_axi_*` prefix.
- **`s_axilite` on an argument and `m_axi` on the same argument are different things.**
  `s_axilite` on a pointer passes the *value*; `m_axi -offset slave` passes the *address*.
  Mixing these up produces a design that reads from address `0x2A`.
- **The driver headers under `impl/misc/drivers/` are generated output worth reading.** They
  are the only place the register offsets are written down.

---

## 8. Questions

**Q1. Why can't `ap_ctrl_none` be cosimulated?**

Cosim generates an RTL testbench that asserts `ap_start`, waits for `ap_done`, and then
compares outputs against the C reference for that transaction. With `ap_ctrl_none` there is
no `ap_start` to assert and no `ap_done` to wait on, so there is no way to delimit one
transaction from the next. Verification of such a block has to happen at the system level,
with the flow control supplied by the surrounding FIFOs or streams.

**Q2. With `s_axilite`, where did `ap_start` go, and how would software actually start the block?**

Into bit 0 of the control register at offset `0x00` of the AXI-Lite bundle. Software writes
`0x01` there to start; it polls the same register and checks bit 1 (`ap_done`) or bit 2
(`ap_idle`), or enables the `interrupt` output through the interrupt-enable registers at
`0x04`/`0x08`. Setting bit 7 turns on auto-restart, which makes the block re-trigger itself
continuously. The generated `xiface_hw.h` lists the exact offsets for this design.

**Q3. The `fifo` solution has essentially the same reported latency as `default`. Is the
FIFO version therefore free?**

No — the reported latency assumes no stalls in both cases, which is a stronger assumption
for the FIFO version. With `ap_memory` the block drives an address and the RAM is assumed to
respond; the surrounding system guarantees availability. With `ap_fifo` the block will stall
whenever `x_empty_n` is low or `y_full_n` is low, and the report does not model the
producer or consumer at all. The two numbers are comparable only as best cases. Real numbers
come from cosim with realistic stimulus, or from system simulation.

**Q4. The `maxi` solution produced `s_axi_control` and `s_axi_control_r`. Which one holds
`ap_start`, and how would you have found out without guessing?**

`s_axi_control_r` — the one whose Source Object column says `control_r` and whose C Type is
`scalar`. That is the bundle the scalar arguments and the block-level control were assigned
to. The way to find out is the generated driver header under
`<solution>/impl/misc/drivers/`: with two bundles the tool emits the offsets for each, and
the control register is in whichever one owns the `ap_ctrl_hs` registers. Reading the port
table alone gets you the C Type hint; reading the driver header gets you the answer.

**Q5. Why does `x` get `x_q0` (a data input) while `y` gets `y_d0` (a data output)?**

Because `x` is declared `const` and only read, so the block needs an address out and data
in; `y` is written, so it needs address out, write-enable out, and data out. The tool derives
the port direction from the access pattern in C, not from the argument's syntax. Dropping
`const` from `x` would not change this as long as the code only reads it — but it would
remove the compile-time guarantee, so keep it.

---

## 9. What to record

**`notes/env.md`**
- The exact default bundle name the tool produced for `s_axilite` on this install.
- Whether the reset is `ap_rst` or `ap_rst_n` per solution, confirming the AXI flip.
- The address-bus width for `N = 64` (expect 6 bits), as a check on how array extents
  propagate to ports.

**`notes/findings.md`**
- The seven `ports_*.txt` diffs, or at least the added/removed lines for each.
- The exact error text from the `ap_fifo` illegal-access experiment in 5.5.
- The deviation from the `directives.tcl` convention: this exercise uses
  `directives_<solution>.tcl` because it has seven solutions rather than a naive/opt pair.

**`results.csv`** — one row per solution. The interesting columns here are `LUT`, `FF`, and
`notes`; `II_target`/`II_achieved` are not applicable. The row that matters most is `maxi`,
for the interface-adapter cost.

---

## 10. Clean up and finish S0

```bash
make clean EX=s0_flow/04_interfaces
```

Then delete `ports_*.txt` and `interfaces.txt` if you dumped them into the exercise
directory — or keep the diffs by pasting them into `notes/findings.md` first.

That closes S0. You can now write a project script from scratch, read a synthesis report
and a schedule, and control the block boundary. S1.1 starts on the performance model —
latency, initiation interval, and `C = L + I(N-1)` — and carries the outstanding
auto-pipelining threshold probe, which needs its own two-solution script.

---

## References

- AMD/Xilinx, *Vitis HLS User Guide* (UG1399), 2023.2 — "Defining Interfaces", `INTERFACE`
  pragma reference, and the `config_interface` command.
- J. de Fine Licht, M. Besta, S. Meierhans, T. Hoefler, "Transformations of High-Level
  Synthesis Codes for High-Performance Computing," *IEEE TPDS* 32(5), 2021; arXiv:1805.08288.
  Interface choice is not one of the 15 transformations, but Section 3 (memory access
  extraction) and the striping discussion depend directly on it.
- R. Kastner, J. Matai, S. Neuendorffer, *Parallel Programming for FPGAs* (open access) —
  worked examples of the same kernels under different interface assumptions.