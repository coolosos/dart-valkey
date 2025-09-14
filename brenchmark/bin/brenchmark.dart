import 'dart:async';
import 'dart:io';

import 'package:dart_valkey/dart_valkey.dart';
import 'package:dart_valkey/src/extensions/all_commands.dart'; // Import the extension
import 'package:redis/redis.dart';
import 'package:shorebird_redis_client/shorebird_redis_client.dart';

class BenchmarkResult {
  // en KB (final - initial)
  BenchmarkResult({
    required this.iterations,
    required this.avgLatency,
    required this.throughput,
    required this.memoryDelta,
  });
  final int iterations;
  final double avgLatency; // en ms
  final double throughput; // ops/sec
  final double memoryDelta;
}

// Función auxiliar para medir memoria en KB.
int getMemoryKB() => ProcessInfo.currentRss ~/ 1024;

Future<BenchmarkResult> benchmarkDartValkey({int iterations = 1000}) async {
  final initialMemory = getMemoryKB();
  stdout.writeln('--- Benchmark dart_valkey ---');
  final client = ValkeyCommandClient(host: 'localhost', port: 6379);
  await client.connect();
  stdout.writeln('Conectado a dart_valkey');

  stdout.writeln('Memoria Inicial: $initialMemory KB');

  // Warmup
  await client.ping();
  await client.set('test_key', 'test_value');
  await client.get('test_key');

  List<double> latencies = [];
  final swTotal = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    final sw = Stopwatch()..start();
    await client.set('key_$i', 'value_$i');
    await client.get('key_$i');
    await client.ping();
    sw.stop();
    latencies.add(sw.elapsedMicroseconds / 1000.0); // ms
  }
  swTotal.stop();

  final finalMemory = getMemoryKB();
  stdout.writeln('Memoria Final: $finalMemory KB');
  final memDelta = (finalMemory - initialMemory).toDouble();
  stdout.writeln('Diferencia de Memoria: ${memDelta.toStringAsFixed(2)} KB');

  final totalLatency = latencies.reduce((a, b) => a + b);
  final avgLatency = totalLatency / iterations;
  final throughput = iterations / (swTotal.elapsedMilliseconds / 1000.0);

  stdout.writeln('--- Resultados dart_valkey ---');
  stdout.writeln('Iteraciones: $iterations');
  stdout.writeln('Latencia promedio: ${avgLatency.toStringAsFixed(2)} ms');
  stdout.writeln('Throughput: ${throughput.toStringAsFixed(2)} ops/sec');

  await client.close();
  stdout.writeln('Conexión cerrada (dart_valkey).\n');
  return BenchmarkResult(
    iterations: iterations,
    avgLatency: avgLatency,
    throughput: throughput,
    memoryDelta: memDelta,
  );
}

Future<BenchmarkResult> benchmarkRedisPackage({int iterations = 1000}) async {
  final initialMemory = getMemoryKB();
  stdout.writeln('--- Benchmark redis package ---');
  final redisConnection = RedisConnection();
  final redisCommand = await redisConnection.connect('localhost', 6379);
  stdout.writeln('Conectado a redis package');

  stdout.writeln('Memoria Inicial: $initialMemory KB');

  // Warmup
  await redisCommand.send_object(["PING"]);
  await redisCommand.send_object(["SET", "test_key", "test_value"]);
  await redisCommand.send_object(["GET", "test_key"]);

  List<double> latencies = [];
  final swTotal = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    final sw = Stopwatch()..start();
    await redisCommand.send_object(["SET", "key_$i", "value_$i"]);
    await redisCommand.send_object(["GET", "key_$i"]);
    await redisCommand.send_object(["PING"]);
    sw.stop();
    latencies.add(sw.elapsedMicroseconds / 1000.0);
  }
  swTotal.stop();

  final finalMemory = getMemoryKB();
  stdout.writeln('Memoria Final: $finalMemory KB');
  final memDelta = (finalMemory - initialMemory).toDouble();
  stdout.writeln('Diferencia de Memoria: ${memDelta.toStringAsFixed(2)} KB');

  final totalLatency = latencies.reduce((a, b) => a + b);
  final avgLatency = totalLatency / iterations;
  final throughput = iterations / (swTotal.elapsedMilliseconds / 1000.0);

  stdout.writeln('--- Resultados redis package ---');
  stdout.writeln('Iteraciones: $iterations');
  stdout.writeln('Latencia promedio: ${avgLatency.toStringAsFixed(2)} ms');
  stdout.writeln('Throughput: ${throughput.toStringAsFixed(2)} ops/sec');

  await redisConnection.close();
  stdout.writeln('Conexión cerrada (redis package).\n');
  return BenchmarkResult(
    iterations: iterations,
    avgLatency: avgLatency,
    throughput: throughput,
    memoryDelta: memDelta,
  );
}

Future<BenchmarkResult> benchmarkShorebirdRedisClient({
  int iterations = 1000,
}) async {
  final initialMemory = getMemoryKB();
  stdout.writeln('--- Benchmark shorebird_redis_client ---');
  final client = RedisClient();
  await client.connect();
  stdout.writeln('Conectado a shorebird_redis_client');

  stdout.writeln('Memoria Inicial: $initialMemory KB');

  // Warmup
  await client.execute(['PING']);
  await client.execute(['SET', 'test_key', 'test_value']);
  await client.execute(['GET', 'test_key']);

  List<double> latencies = [];
  final swTotal = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    final sw = Stopwatch()..start();
    await client.execute(['SET', 'key_$i', 'value_$i']);
    await client.execute(['GET', 'key_$i']);
    await client.execute(['PING']);
    sw.stop();
    latencies.add(sw.elapsedMicroseconds / 1000.0);
  }
  swTotal.stop();

  final finalMemory = getMemoryKB();
  stdout.writeln('Memoria Final: $finalMemory KB');
  final memDelta = (finalMemory - initialMemory).toDouble();
  stdout.writeln('Diferencia de Memoria: ${memDelta.toStringAsFixed(2)} KB');

  final totalLatency = latencies.reduce((a, b) => a + b);
  final avgLatency = totalLatency / iterations;
  final throughput = iterations / (swTotal.elapsedMilliseconds / 1000.0);

  stdout.writeln('--- Resultados shorebird_redis_client ---');
  stdout.writeln('Iteraciones: $iterations');
  stdout.writeln('Latencia promedio: ${avgLatency.toStringAsFixed(2)} ms');
  stdout.writeln('Throughput: ${throughput.toStringAsFixed(2)} ops/sec');

  await client.close();
  stdout.writeln('Conexión cerrada (shorebird_redis_client).\n');
  return BenchmarkResult(
    iterations: iterations,
    avgLatency: avgLatency,
    throughput: throughput,
    memoryDelta: memDelta,
  );
}

Future<void> main() async {
  const int rounds = 50;
  const int iterations = 1000;

  // Listas para acumular resultados
  List<BenchmarkResult> resultsDartValkey = [];
  List<BenchmarkResult> resultsRedisPackage = [];
  List<BenchmarkResult> resultsShorebird = [];

  // Ejecución intercalada de benchmarks en cada round
  for (int i = 0; i < rounds; i++) {
    stdout.writeln('=== Round ${i + 1} ===\n');
    resultsDartValkey.add(await benchmarkDartValkey(iterations: iterations));
    // Un delay corto para estabilizar conexiones entre rondas
    await Future.delayed(const Duration(seconds: 1));
    resultsRedisPackage
        .add(await benchmarkRedisPackage(iterations: iterations));
    await Future.delayed(const Duration(seconds: 1));
    resultsShorebird
        .add(await benchmarkShorebirdRedisClient(iterations: iterations));
    await Future.delayed(const Duration(seconds: 1));
  }

  // Función auxiliar para calcular la media de una lista de valores
  double average(List<double> values) =>
      values.reduce((a, b) => a + b) / values.length;

  // Calcular promedios para cada librería
  double avgLatencyDartValkey =
      average(resultsDartValkey.map((r) => r.avgLatency).toList());
  double avgThroughputDartValkey =
      average(resultsDartValkey.map((r) => r.throughput).toList());
  double avgMemoryDartValkey =
      average(resultsDartValkey.map((r) => r.memoryDelta).toList());

  double avgLatencyRedis =
      average(resultsRedisPackage.map((r) => r.avgLatency).toList());
  double avgThroughputRedis =
      average(resultsRedisPackage.map((r) => r.throughput).toList());
  double avgMemoryRedis =
      average(resultsRedisPackage.map((r) => r.memoryDelta).toList());

  double avgLatencyShorebird =
      average(resultsShorebird.map((r) => r.avgLatency).toList());
  double avgThroughputShorebird =
      average(resultsShorebird.map((r) => r.throughput).toList());
  double avgMemoryShorebird =
      average(resultsShorebird.map((r) => r.memoryDelta).toList());

  stdout.writeln('===== Promedio de Resultados tras $rounds rounds =====\n');

  stdout.writeln('dart_valkey:');
  stdout.writeln(
    'Latencia Promedio: ${avgLatencyDartValkey.toStringAsFixed(2)} ms',
  );
  stdout.writeln(
    'Throughput Promedio: ${avgThroughputDartValkey.toStringAsFixed(2)} ops/sec',
  );
  stdout.writeln(
    'Cambio de Memoria Promedio: ${avgMemoryDartValkey.toStringAsFixed(2)} KB\n',
  );

  stdout.writeln('redis package:');
  stdout.writeln('Latencia Promedio: ${avgLatencyRedis.toStringAsFixed(2)} ms');
  stdout.writeln(
    'Throughput Promedio: ${avgThroughputRedis.toStringAsFixed(2)} ops/sec',
  );
  stdout.writeln(
    'Cambio de Memoria Promedio: ${avgMemoryRedis.toStringAsFixed(2)} KB\n',
  );

  stdout.writeln('shorebird_redis_client:');
  stdout.writeln(
    'Latencia Promedio: ${avgLatencyShorebird.toStringAsFixed(2)} ms',
  );
  stdout.writeln(
    'Throughput Promedio: ${avgThroughputShorebird.toStringAsFixed(2)} ops/sec',
  );
  stdout.writeln(
    'Cambio de Memoria Promedio: ${avgMemoryShorebird.toStringAsFixed(2)} KB\n',
  );
}
