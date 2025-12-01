class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'],
    );
  }
}

class ApiListResponse<T> {
  final bool success;
  final List<T>? data;
  final String? message;

  ApiListResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ApiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiListResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<T>.from(json['data'].map((x) => fromJsonT(x)))
          : null,
      message: json['message'],
    );
  }
}