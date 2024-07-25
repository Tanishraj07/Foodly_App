import 'package:flutter/material.dart';
import 'package:restaurent/models/address_response.dart';
import 'package:restaurent/models/foods_model.dart';

class FetchAddresses {
  final List<AddressResponse>? data;
  final bool isLoading;
  final Exception? error;
  final VoidCallback? refetch;

  FetchAddresses({
    required this.data,
    required this.isLoading,
    required this.error,
    required this.refetch,
  });
}
