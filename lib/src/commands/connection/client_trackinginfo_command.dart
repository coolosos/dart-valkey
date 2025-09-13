import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT TRACKINGINFO' command.
final class ClientTrackinginfoCommand
    extends ValKeyedCommand<Map<String, dynamic>> {
  @override
  List<String> get commandParts => ['CLIENT', 'TRACKINGINFO'];

  @override
  Map<String, dynamic> parse(dynamic data) {
    if (data is List) {
      final result = <String, dynamic>{};
      for (var i = 0; i < data.length; i += 2) {
        result[data[i] as String] = data[i + 1];
      }
      return result;
    }
    throw ValkeyException(
      'Invalid response for CLIENT TRACKINGINFO: expected a list, got ${data.runtimeType}',
    );
  }
}
