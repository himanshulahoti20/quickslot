import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

// booking_id is the JSON key from both POST /bookings and GET /bookings/users/:id/bookings.
// userId defaults to 0 when absent (GET list response does not include user_id).
// startTime, endTime, venueName, sport default to '' when absent (POST confirmation response).
@freezed
abstract class Booking with _$Booking {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Booking({
    @JsonKey(name: 'booking_id') required int id,
    required int slotId,
    @JsonKey(defaultValue: 0) required int userId,
    required String date,
    @Default('active') String status,
    @Default('') String startTime,
    @Default('') String endTime,
    @Default('') String venueName,
    @Default('') String sport,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
}
