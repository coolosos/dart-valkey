import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'QUIT' command.
final class QuitCommand extends ValKeyedCommand<String> {
  @override
  List<String> get commandParts => ['QUIT'];

  @override
  String parse(dynamic data) {
    if (data == 'OK') {
      return data;
    }
    throw ValkeyException(
      'Invalid response for QUIT: expected OK, got ${data.runtimeType}',
    );
  }
}
