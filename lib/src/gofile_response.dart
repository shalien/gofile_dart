class GoFileResponse {
  /// The status of the request
  /// Should be ok
  final String status;

  /// The data of the request maybe empty
  final Map<String, dynamic> data;

  /// Private constructor for the factory
  GoFileResponse._(this.status, this.data);

  /// Factory constructor
  /// Create the [GoFileResponse] from the [json]
  factory GoFileResponse.fromJson(Map<String, dynamic> json) {
    return GoFileResponse._(json['status'], json['data']);
  }
}
