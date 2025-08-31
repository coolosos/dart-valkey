class ValkeyException implements Exception {
  ValkeyException(this.message);
  final String message;
  @override
  String toString() => 'ValkeyException: $message';
}
