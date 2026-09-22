class ApiException implements Exception {
  final int statusCode;
  final String body;

  const ApiException({required this.statusCode, required this.body});

  @override
  String toString() {
    return 'Erreur HTTP $statusCode';
  }
}
