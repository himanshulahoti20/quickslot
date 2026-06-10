import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:app/core/api/api_endpoints.dart';
import 'package:app/core/api/exceptions.dart';
import 'package:app/features/venues/models/venue.dart';
import 'package:app/features/slots/models/slot.dart';
import 'package:app/features/bookings/models/booking.dart';

class ApiClient {
  ApiClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (currentUserId != null) {
            options.headers['X-User-Id'] = currentUserId.toString();
          }
          handler.next(options);
        },
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.base,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Set this on login; cleared on logout.
  static int? currentUserId;

  // ── public methods ──────────────────────────────────────────────────────────

  Future<List<Venue>> getVenues() async {
    try {
      final res = await _dio.get<List<dynamic>>(ApiEndpoints.venues);
      return _mapList(res.data!, Venue.fromJson);
    } on DioException catch (e) {
      _mapError(e);
    }
  }

  Future<List<Slot>> getSlots(int venueId, String date) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.venueSlots(venueId),
        queryParameters: {'date': date},
      );
      return _mapList(res.data!, Slot.fromJson);
    } on DioException catch (e) {
      _mapError(e);
    }
  }

  Future<Booking> createBooking(int slotId, String date) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.bookings,
        data: {'slot_id': slotId, 'date': date},
      );
      return Booking.fromJson(res.data!);
    } on DioException catch (e) {
      _mapError(e);
    }
  }

  Future<List<Booking>> getMyBookings(int userId) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.userBookings(userId),
      );
      return _mapList(res.data!, Booking.fromJson);
    } on DioException catch (e) {
      _mapError(e);
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    try {
      await _dio.delete<void>(ApiEndpoints.cancelBooking(bookingId));
    } on DioException catch (e) {
      _mapError(e);
    }
  }

  // ── private helpers ─────────────────────────────────────────────────────────

  List<T> _mapList<T>(List<dynamic> data, T Function(Map<String, dynamic>) fromJson) =>
      data.map((e) => fromJson(e as Map<String, dynamic>)).toList();

  // Returns Never so callers don't need an explicit throw/return after calling it.
  Never _mapError(DioException e) {
    if (_isNetworkError(e)) {
      throw NetworkException(message: e.message ?? 'Network error');
    }
    if (e.response?.statusCode == 409) {
      throw const SlotTakenException();
    }
    throw ApiException(
      statusCode: e.response?.statusCode ?? 0,
      message: _extractMessage(e),
    );
  }

  bool _isNetworkError(DioException e) =>
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.unknown;

  String _extractMessage(DioException e) {
    try {
      return (e.response!.data as Map<String, dynamic>)['message'] as String;
    } catch (_) {
      return e.message ?? 'Unknown error';
    }
  }
}
