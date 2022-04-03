/// A formatted [Exception] for the GoFile API
/// Each [GoFileException] has a [status] and [data]
class GoFileException implements Exception {
  /// The status of the exception
  /// e.g. : non-premium
  final String status;

  /// Additional data for the exception
  final Map<String, dynamic>? data;

  /// Private constructor for the factory
  GoFileException._(this.status, {this.data});

  /// Create the exception from the [json] response
  factory GoFileException.fromJson(Map<String, dynamic> json) {
    return GoFileException._(json['status'], data: json['data']);
  }

  @override

  /// Will return the [status]
  String toString() {
    return status;
  }
}
