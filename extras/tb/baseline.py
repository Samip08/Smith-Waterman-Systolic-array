import time
import os

def smith_waterman_baseline(seq1, seq2, match=2, mismatch=-1, gap=-1):
    rows = len(seq1) + 1
    cols = len(seq2) + 1
    
    # Initialize matrix
    matrix = [[0 for _ in range(cols)] for _ in range(rows)]
    
    # Timing Start
    start_time = time.perf_counter()
    
    max_score = 0
    max_pos = (0, 0)

    # Core Algorithm (Sequential execution)
    for i in range(1, rows):
        for j in range(1, cols):
            # Calculate match score
            m_score = matrix[i-1][j-1] + (match if seq1[i-1] == seq2[j-1] else mismatch)
            # Calculate gap scores
            ins_score = matrix[i-1][j] + gap
            del_score = matrix[i][j-1] + gap
            
            # Local alignment condition
            matrix[i][j] = max(0, m_score, ins_score, del_score)
            
            if matrix[i][j] > max_score:
                max_score = matrix[i][j]
                max_pos = (i-1, j-1) # 0-indexed result

    # Timing End
    end_time = time.perf_counter()
    elapsed_ms = (end_time - start_time) * 1000
    
    return max_score, max_pos, elapsed_ms

def load_mem(filename):
    if not os.path.exists(filename):
        return None
    with open(filename, 'r') as f:
        # Convert binary strings "01" to integers
        return [int(line.strip(), 2) for line in f if line.strip()]

if __name__ == "__main__":
    # 1. Load your actual .mem files
    query = load_mem("seq1.mem")
    subject = load_mem("seq2.mem")

    if query and subject:
        score, pos, duration = smith_waterman_baseline(query, subject)
        
        print("="*45)
        print("       PYTHON SOFTWARE BASELINE REPORT       ")
        print("="*45)
        print(f"Algorithm:        Smith-Waterman (Local)")
        print(f"Matrix Size:      {len(query)} x {len(subject)} (10,000 cells)")
        print(f"Peak Score:       {score}")
        print(f"Peak Coordinates: Query[{pos[0]}], Subject[{pos[1]}]")
        print("-" * 45)
        print(f"EXECUTION TIME:   {duration:.4f} ms")
        print(f"THROUGHPUT:       { (len(query)*len(subject))/(duration/1000) / 1e6:.2f} MCUPS")
        print("="*45)
    else:
        print("Error: mem files not found. Ensure seq1.mem and seq2.mem exist.")