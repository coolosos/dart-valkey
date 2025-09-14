# Comparative Benchmark - Summary

**Test Environment**  
- **OS:** macOS  
- **Server:** Valkey on `localhost:6379`  
- **Workload:** Mixed (SET, GET, PING) operations per iteration
- **Iterations per Round:** 1000 operations (each operation includes SET, GET, PING)
- **Rounds:** 50 (the first round is discarded when calculating averages)

---

## Average Results (Rounds 2 to 10)

| Library                    | Average Latency (ms) | Average Throughput (ops/sec) | Average Memory Change (KB) |
|----------------------------|----------------------|------------------------------|----------------------------|
| **dart_valkey**            | 0.14                 | 7470.94                      | -3593.60                   |
| **redis package**          | 0.14                 | 7329.03                      | -107.20                    |
| **shorebird_redis_client** | 0.17                 | 6067.61                      | 229.76                     |

---