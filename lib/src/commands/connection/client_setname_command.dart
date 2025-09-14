import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT SETNAME connection-name' command.
final class ClientSetnameCommand extends ValkeyCommand<String> {
  ClientSetnameCommand(this.name);
  final String name;

  @override
  List<String> get commandParts => ['CLIENT', 'SETNAME', name];

  @override
  String parse(dynamic data) {
    if (data == 'OK') {
      return data;
    }
    throw ValkeyException(
      'Invalid response for CLIENT SETNAME: expected OK, got ${data.runtimeType}',
    );
  }
}
