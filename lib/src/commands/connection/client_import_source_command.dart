import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT IMPORT-SOURCE' command.
final class ClientImportSourceCommand extends ValkeyCommand<bool> {
  @override
  List<String> get commandParts => ['CLIENT', 'IMPORT-SOURCE'];

  @override
  bool parse(dynamic data) {
    if (data is String) {
      if (data == 'OK') return true;
    }
    throw ValkeyException(
      'Invalid response for CLIENT IMPORT-SOURCE: expected OK, got ${data.runtimeType} "$data"',
    );
  }
}
