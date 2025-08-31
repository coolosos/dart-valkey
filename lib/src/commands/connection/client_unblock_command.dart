import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT UNBLOCK' command.
///
/// **Valkey Command:**
/// ```
/// CLIENT UNBLOCK client-id [TIMEOUT | ERROR]
/// ```
///
/// **Valkey Reply:**
/// ```
/// Integer reply: 0 if the client was not unblocked, 1 if the client was unblocked.
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to 0 or 1.
enum UnblockType {
  timeout,
  error,
}

final class ClientUnblockCommand extends ValkeyCommand<int> {
  ClientUnblockCommand(this.clientId, {this.unblockType});

  final int clientId;
  final UnblockType? unblockType;

  @override
  List<Object> get commandParts {
    final parts = ['CLIENT', 'UNBLOCK', clientId];
    if (unblockType != null) {
      parts.add(unblockType!.name.toUpperCase());
    }
    return parts;
  }

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for CLIENT UNBLOCK: expected an integer, got ${data.runtimeType}',
    );
  }
}
