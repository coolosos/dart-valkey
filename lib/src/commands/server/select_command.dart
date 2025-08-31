import '../command.dart';

/// Represents the `SELECT` command in Valkey.
///
/// Selects the database with the specified zero-based index.
final class SelectCommand extends ValkeyCommand<bool> {
  SelectCommand(this.index);

  final int index;

  @override
  List<Object> get commandParts => ['SELECT', index];

  @override
  bool parse(dynamic data) {
    return data == 'OK';

    // throw Exception('Unexpected response for SELECT: $data');
  }
}
