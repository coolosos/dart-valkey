import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT GETNAME' command.
final class ClientGetnameCommand extends ValkeyCommand<String?> {
  @override
  List<Object> get commandParts => ['CLIENT', 'GETNAME'];

  @override
  String? parse(dynamic data) {
    if (data == null || data is String) {
      return data as String?;
    }
    throw ValkeyException(
      'Invalid response for CLIENT GETNAME: expected a string or null, got ${data.runtimeType}',
    );
  }
}
