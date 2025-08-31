import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HELLO' command.
///
/// **Valkey Command:**
/// ```
/// HELLO
/// ```
///
/// **Valkey Reply:**
/// ```
/// A list of current server and connection properties.
/// ```
///
/// **Dart Result (from parse method):**
/// `Map<String, dynamic>` resolving to the server properties.
final class HelloCommand extends ValkeyCommand<Map<String, dynamic>> {
  HelloCommand({
    this.protocolVersion,
    this.username,
    this.password,
    this.clientName,
  });
  final int? protocolVersion;
  final String? username;
  final String? password;
  final String? clientName;

  @override
  List<Object> get commandParts {
    final List<Object> parts = ['HELLO'];
    if (protocolVersion != null) {
      parts.add(protocolVersion!);
    }
    if (username != null && password != null) {
      parts.addAll(['AUTH', username!, password!]);
    } else if (username == null && password != null) {
      parts.addAll(['AUTH', 'default', password!]);
    }
    if (clientName != null) {
      parts.addAll(['SETNAME', clientName!]);
    }
    return parts;
  }

  @override
  Map<String, dynamic> parse(dynamic data) {
    if (data is List) {
      final Map<String, dynamic> result = {};
      for (int i = 0; i < data.length; i += 2) {
        if (i + 1 < data.length) {
          result[data[i].toString()] = data[i + 1];
        }
      }
      return result;
    }
    throw ValkeyException(
      'Invalid response for HELLO: expected a list, got ${data.runtimeType}',
    );
  }
}
