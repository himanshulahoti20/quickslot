// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
  id: (json['booking_id'] as num).toInt(),
  slotId: (json['slot_id'] as num).toInt(),
  userId: (json['user_id'] as num?)?.toInt() ?? 0,
  date: json['date'] as String,
  status: json['status'] as String? ?? 'active',
  startTime: json['start_time'] as String? ?? '',
  endTime: json['end_time'] as String? ?? '',
  venueName: json['venue_name'] as String? ?? '',
  sport: json['sport'] as String? ?? '',
);

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
  'booking_id': instance.id,
  'slot_id': instance.slotId,
  'user_id': instance.userId,
  'date': instance.date,
  'status': instance.status,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'venue_name': instance.venueName,
  'sport': instance.sport,
};
