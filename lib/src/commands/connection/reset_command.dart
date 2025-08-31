import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'RESET' command.
final class ResetCommand extends ValkeyCommand<String> {
  @override
  List<Object> get commandParts => ['RESET'];

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
