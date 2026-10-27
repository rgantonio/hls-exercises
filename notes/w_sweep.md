# Lane sweep (W)

The bench sweeps **W = 1, 2, 4, 8, 16, 32** at int64. In bits per cycle per stream, that runs from 64 to 2048. Each step matches a class of shipping product. The ceiling is 2048 bits: above that, only a whole GPU SM computes that wide, and no shared-L1 cluster in the literature feeds it.

The limit is in bits per stream per cycle, not in lanes. Once narrow elements land in forge (PACK0), the same six steps are 2 to 64 lanes at int32 and 8 to 256 at int8. Lanes are read off per dtype as W = c · 64 / b, where c is the 64-bit channels per stream and b the element width.

| W (int64) | Bits/cycle | Product class | Example | Vendor document | Other source |
|---|---|---|---|---|---|
| 1 | 64 | MCU | Arm Cortex-M55 (dual-beat Helium: 2 × 32-bit beats per cycle) | [Arm, Hot Chips 32 (2020), Cortex-M55 slides](https://www.hc32.hotchips.org/assets/program/conference/day1/HotChips2020_Edge_Computing_Arm_Cortex-M55.pdf) | [WikiChip Fuse](https://fuse.wikichip.org/?p=3319) |
| 2 | 128 | Little phone core | Arm Cortex-A55 (2 × 64-bit Neon pipes) | none found | [AnandTech (2017)](https://at-web1.www.anandtech.com/show/11441/dynamiq-and-arms-new-cpus-cortex-a75-a55/4) |
| 4 | 256 | Mid-range phone, Neoverse N | SiFive Intelligence X280 (DLEN 256); Arm Neoverse N2 (2 × 128-bit) | [SiFive, Introduction to the X280 (2022)](https://sifive.com/blog/introduction-to-the-sifive-intelligence-x280) | [WikiChip Fuse, Neoverse N2/V1](https://fuse.wikichip.org/news/4795/arm-launches-new-neoverse-n2-and-v1-server-cpus-1-4x-1-5x-ipc-sve-and-armv9/2), [Chips and Cheese, Cortex-A710](https://chipsandcheese.com/p/arms-cortex-a710-winning-by-default) |
| 8 | 512 | Flagship phone, Neoverse V, Zen 4 | NVIDIA Grace / Neoverse V2 (4 × 128-bit SVE2); AMD Zen 4 (256-bit datapath, 2 pipes) | [NVIDIA Grace tuning guide](https://docs.nvidia.com/grace-perf-tuning-guide/index.html), [AMD, Hot Chips 2023, Zen 4](https://hc2023.hotchips.org/assets/program/conference/day1/CPU1/HC_Zen4_Epyc_Final_20230825%20-%20Embargoed%20until%20Aug%2029%202023.pdf) | [AnandTech, Apple Firestorm (4 × 128-bit)](https://at-web1.www.anandtech.com/show/16226/apple-silicon-m1-a14-deep-dive/2) |
| 16 | 1024 | Two-FMA Xeon, Zen 5, A64FX | AMD Zen 5 (full 512-bit datapath, 2 × 512-bit FMA); Fujitsu A64FX (2 × 512-bit SVE) | [AMD, Hot Chips 2024, Zen 5](https://www.hc2024.hotchips.org/assets/program/conference/day2/24_HC2024.AMD.Cohen.Subramony.final.pdf) | [Alappat et al., A64FX (arXiv 2103.03013)](https://arxiv.org/pdf/2103.03013), [Microway, Xeon FMA units](https://www.microway.com/?p=8834) |
| 32 | 2048 | Vector supercomputer | NEC SX-Aurora TSUBASA core (32 vector pipes, 3 FMA units each) | none found | [HLRS, NEC Aurora hardware](https://kb.hlrs.de/platforms/index.php/NEC_Aurora_HW), [WikiChip](https://en.wikichip.org/wiki/sx-aurora) |

- **Vendor document** means a document from the company that makes the part: a datasheet, a white paper, a tuning guide, or its own Hot Chips slides. Where none was found, the row says so. The other sources are press, analysis sites, papers or a computing centre's documentation.
- **Bits/cycle** is what the core computes per cycle, not the architectural vector length. Zen 4 runs 512-bit instructions on a 256-bit datapath, and SX-Aurora holds 256-element registers but computes 32 positions per cycle.
- **Helium has no 64-bit lanes.** The W = 1 row matches the Cortex-M55 in bits per cycle (64), not in int64 lanes.
- **Past W = 8, forge's 32-bank TCDM runs out.** A three-stream unit then needs more than 32 words per cycle. The HLS points at W = 16 and 32 measure the unit alone; the bank cost is forge's sweep.
- **NPUs and matrix units are on another axis.** Ethos-U, Intel AMX and tensor cores reach 128 to 16K MACs per cycle by reusing operands, and they read few words per cycle. They are not streamed lanes.

The full survey, with the sources for every product class, is the report "Vector datapath widths by market" (27 Oct 2026). It was made outside this repo, from four research notes.
