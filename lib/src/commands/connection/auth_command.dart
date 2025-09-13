import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'AUTH [username] password' command.
final class AuthCommand extends ValKeyedCommand<String> {
  AuthCommand({required this.password, this.username});
  final String? username;
  final String password;

  @override
  List<String> get commandParts {
    final parts = ['AUTH'];
    if (username != null) {
      parts.add(username!);
    }
    parts.add(password);
    return parts;
  }

  @override
  String parse(dynamic data) {
    if (data == 'OK') {
      return data;
    }
    throw ValkeyException(
      'Invalid response for AUTH: expected OK, got ${data.runtimeType}',
    );
  }
}
