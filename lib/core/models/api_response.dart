class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data']) 
          : json['data'],
      errors: json['errors'],
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (data != null) 'data': data,
      if (errors != null) 'errors': errors,
      if (statusCode != null) 'statusCode': statusCode,
    };
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, data: $data)';
  }
}

class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final List<dynamic> items = json['data'] ?? [];
    return PaginatedResponse<T>(
      data: items.map((item) => fromJsonT(item)).toList(),
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 20,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  @override
  String toString() {
    return 'PaginatedResponse(currentPage: $currentPage, totalPages: $totalPages, totalItems: $totalItems)';
  }
} 