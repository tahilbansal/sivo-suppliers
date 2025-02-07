import 'package:flutter/material.dart';
import 'package:sivo_suppliers/models/api_error.dart';
import 'package:sivo_suppliers/models/order_details.dart';

class FetchOrder {
  final GetOrder? data;
  final bool isLoading;
  final ApiError? error;
  final VoidCallback refetch;

  FetchOrder({
    required this.data,
    required this.isLoading,
    required this.error,
    required this.refetch,
  });
}
