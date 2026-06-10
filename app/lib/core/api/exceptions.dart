class SlotTakenException implements Exception {
  const SlotTakenException([this.message = 'This slot has already been booked.']);
  final String message;

  @override
  String toString() => 'SlotTakenException: $message';
}

class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.message});
  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class NetworkException implements Exception {
  const NetworkException({required this.message});
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}
