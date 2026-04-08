
# Helix-100: High-Performance Systolic Array for Smith-Waterman Sequence Alignment

## Project Overview
**Helix-100** is a hardware-accelerated implementation of the Smith-Waterman algorithm, designed for high-throughput local sequence alignment. Utilizing a 1D parameterized systolic array architecture, the system offloads computationally intensive dynamic programming tasks from general-purpose processors to dedicated FPGA logic. 

This implementation supports real-time scoring of genetic sequences (DNA/RNA) with a focus on low-latency data streaming and efficient hardware resource utilization through internal Block RAM (BRAM) management.

---

## Architectural Design
The design follows a 1D systolic array paradigm where each **Processing Element (PE)** represents a cell in the alignment matrix. Data flows spatially across the array, allowing for $O(m+n)$ time complexity compared to the $O(m \times n)$ complexity typical of sequential software implementations.

* **Top-Level Module (`Top.v`):** Manages the global state machine, orchestrates Block RAM (BRAM) access for subject sequences, and handles the parallel loading of query strings.
* **Processing Element (`PE.v`):** The fundamental computational unit. It calculates match, mismatch, and gap penalties using signed arithmetic. Internal registers maintain vertical, horizontal, and diagonal score dependencies.
* **Systolic Wrapper (`Genvar_wrapper.v`):** Employs Verilog `generate` blocks to instantiate a scalable number of PEs (default: 100), ensuring the design can be tailored to specific FPGA fabric constraints.
* **Scoring Logic (`Max.v`):** A high-speed reduction network that monitors the entire array in real-time to latch the global maximum score and its corresponding spatial-temporal coordinates ($i, j$).

---

## Directory Structure

```text
helix-100/
├── rtl/                        
│   ├── Top.v                   
│   ├── PE.v                    
│   ├── Max.v                   
│   └── Genvar_wrapper.v        
├── tb/                         
│   ├── Top_tb.v                
│   └── mem/                    
│       ├── seq1.mem            
│       └── seq2.mem           
├── reports/                   
│   ├── timing_report.png      
│   └── power_analysis.png      
├── docs/                       
│   └── smith_waterman_spec.pdf 
├── .gitignore                  
└── README.md                   
```

---

## Technical Specifications
* **Data Encoding:** 2-bit DNA encoding (A=00, C=01, G=10, T=11).
* **Precision:** Parameterized bit-width (default: 21-bit signed integers) to prevent overflow during long-sequence alignments.
* **Throughput:** One character comparison per clock cycle after the initial pipeline fill.
* **Features:** Integrated peak-score coordinate tracking (Index $i, j$) for alignment localization and traceback initialization.

---

## Verification and Simulation
The design is verified using Icarus Verilog and GTKWave. The testbench initializes internal memories with genetic data and monitors the `done` signal to validate the final peak alignment score against a software-defined golden model.

### Synthesis and Implementation
The `rtl/Top.v` module is optimized for synthesis using FPGA Block RAM (BRAM). For implementation on hardware:
1. Ensure `constraints/constraints.xdc` is included in the Vivado project.
2. The design targets a 100MHz system clock with a 10ns period.
3. Post-synthesis reports for timing and power are available in the `/reports` directory.

### Execution Instructions:
1.  Navigate to the project root.
2.  Compile the source files:
    ```bash
    iverilog -o sim rtl/*.v tb/Top_tb.v
    ```
3.  Execute the simulation:
    ```bash
    vvp sim
    ```
4.  Analyze the waveform:
    ```bash
    gtkwave simulation.vcd
    ```

---

## Implementation Results
The Helix-100 architecture is optimized for high-frequency operation on modern FPGA fabrics (e.g., Xilinx Artix-7). Detailed timing and power reports are located in the `/reports` directory, demonstrating minimal resource overhead and successful timing closure at target frequencies.
```
