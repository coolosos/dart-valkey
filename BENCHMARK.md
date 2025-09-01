# Comparative Benchmark - Summary

**Test Environment**  
- **OS:** macOS  
- **Server:** Valkey on `localhost:6379`  
- **Iterations per Round:** 1000 `PING` commands  
- **Rounds:** 10 (the first round is discarded when calculating averages)

---

## Average Results (Rounds 2 to 10)

| Library                    | Average Latency (ms) | Average Throughput (ops/sec) | Average Memory Change (KB) |
|----------------------------|----------------------|------------------------------|----------------------------|
| **dart_valkey**            | 0.06                 | 15,969.92                    | 17.78                      |
| **redis package**          | 0.07                 | 14,972.81                    | 39.11                      |
| **shorebird_redis_client** | 0.08                 | 12,654.19                    | 216.89                     |

---
 