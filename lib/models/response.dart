import 'package:flutter/material.dart';

abstract class Response<T> {
  const Response();
  get data => null;
}

class Success<T> extends Response<T> {
  @override
  final T data;
  const Success({required this.data});
}

class Failure<T> extends Response<T> {
  final String message;
  const Failure({required this.message});
}

Response<T> handleResponse<T>(Response<T> response) {
  if (response is Success<T>) {
    debugPrint('Success: ${response.data}');
    return response;
  } else if (response is Failure<T>) {
    debugPrint('Failure: ${response.message}');
    return response;
  } else {
    debugPrint('Unknown response type');
    return response;
  }
}
