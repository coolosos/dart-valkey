import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'RESET' command.
final class ResetCommand extends ValKeyedCommand<String> {
  @override
  List<String> get commandParts => ['RESET'];

  @override
  String parse(dynamic data) {
    if (data == 'RESET') {
      return data;
    }
    throw ValkeyException(
      'Invalid response for RESET: expected RESET, got ${data.runtimeType}',
    );
  }
}
