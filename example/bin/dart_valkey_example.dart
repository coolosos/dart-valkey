import 'dart:io';

import 'package:dart_valkey/dart_valkey.dart';

Future<void> main() async {
  // Configure the client to connect to your Valkey/Redis server.
  // By default, it connects to localhost on port 6379.
  final client = ValkeyCommandClient(
    host: 'localhost',
    port: 6379,
    // username: 'your-username', // optional
    // password: 'your-password', // optional
  );

  try {
    // Connect to the server
    await client.connect();
    stdout.writeln('Successfully connected to the Valkey server.');

    // Create a simple PING command
    final pingCommand = PingCommand('Hello from dart_valkey!');
    final pingResponse = await client.execute(pingCommand);
    stdout.writeln('PING response: $pingResponse');

    // Set a value
    final setCommand = SetCommand('dart_valkey_example', 'Hello, Valkey!');
    final setResponse = await client.execute(setCommand);
    stdout.writeln('SET response: $setResponse');

    // Get the value back
    final getCommand = GetCommand('dart_valkey_example');
    final getResponse = await client.execute(getCommand);
    stdout.writeln('GET response: $getResponse');
  } catch (e) {
    stdout.writeln('An error occurred: $e');
  } finally {
    // Ensure the client is always closed.
    stdout.writeln('Closing client connection.');
    await client.close();
  }
}
